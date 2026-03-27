from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
import contextlib
import uuid

import cmdstanpy
import joblib
import pandas as pd
from prophet import Prophet
from cmdstanpy.utils import filesystem


BASE_DIR = Path(__file__).resolve().parent.parent
DATA_PATH = BASE_DIR / "synthetic_orders.csv"
MODEL_PATH = Path(__file__).resolve().parent / "prophet_model.joblib"
TMP_DIR = Path(__file__).resolve().parent / "tmp"
STAN_OUTPUT_DIR = TMP_DIR / "stan_runs"


@dataclass
class ForecastRow:
    date: str
    forecast: int
    purchase_plan: int


def _ensure_prophet_backend() -> None:
    TMP_DIR.mkdir(parents=True, exist_ok=True)
    STAN_OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    filesystem._TMPDIR = str(TMP_DIR.resolve())

    def _patched_create_named_text_file(
        dir: str, prefix: str, suffix: str, name_only: bool = False
    ) -> str:
        target_dir = Path(dir or TMP_DIR).resolve()
        target_dir.mkdir(parents=True, exist_ok=True)
        path = target_dir / f"{prefix}{uuid.uuid4().hex}{suffix}"
        with path.open("w", encoding="utf-8"):
            pass
        if name_only:
            with contextlib.suppress(FileNotFoundError):
                path.unlink()
        return str(path)

    filesystem.create_named_text_file = _patched_create_named_text_file

    try:
        cmdstanpy.cmdstan_path()
        return
    except ValueError:
        pass

    bundled = Path(__import__("prophet").__file__).resolve().parent / "stan_model" / "cmdstan-2.37.0"
    if bundled.exists():
        cmdstanpy.set_cmdstan_path(str(bundled))


def _load_orders(csv_path: Path = DATA_PATH) -> pd.DataFrame:
    if not csv_path.exists():
        raise FileNotFoundError(f"Synthetic orders file not found: {csv_path}")

    df = pd.read_csv(csv_path)
    required_columns = {"order_id", "order_date", "quantity", "category", "status"}
    missing = required_columns - set(df.columns)
    if missing:
        raise ValueError(f"synthetic_orders.csv is missing columns: {sorted(missing)}")

    df["order_date"] = pd.to_datetime(df["order_date"], errors="coerce")
    df["quantity"] = pd.to_numeric(df["quantity"], errors="coerce").fillna(0)
    df = df.dropna(subset=["order_date"])
    return df


def build_daily_demand(csv_path: Path = DATA_PATH) -> pd.DataFrame:
    df = _load_orders(csv_path)
    daily = (
        df.groupby(df["order_date"].dt.normalize(), as_index=False)["quantity"]
        .sum()
        .rename(columns={"order_date": "ds", "quantity": "y"})
        .sort_values("ds")
    )
    daily["ds"] = pd.to_datetime(daily["ds"])
    daily["y"] = daily["y"].astype(float)
    return daily


def train_and_save_model(
    *,
    csv_path: Path = DATA_PATH,
    model_path: Path = MODEL_PATH,
) -> Path:
    _ensure_prophet_backend()
    history = build_daily_demand(csv_path)

    model = Prophet(
        yearly_seasonality=True,
        weekly_seasonality=True,
        daily_seasonality=False,
        seasonality_mode="additive",
    )
    model.fit(history, output_dir=str(STAN_OUTPUT_DIR.resolve()))
    joblib.dump(model, model_path)
    return model_path


def load_model(model_path: Path = MODEL_PATH) -> Prophet:
    _ensure_prophet_backend()
    if not model_path.exists():
        raise FileNotFoundError(f"Forecast model not found: {model_path}")
    return joblib.load(model_path)


def ensure_model(model_path: Path = MODEL_PATH, csv_path: Path = DATA_PATH) -> Prophet:
    if not model_path.exists():
        train_and_save_model(csv_path=csv_path, model_path=model_path)
    return load_model(model_path)


def forecast_demand(
    *,
    days: int = 30,
    safety_stock: float = 0.15,
    model_path: Path = MODEL_PATH,
    csv_path: Path = DATA_PATH,
) -> list[ForecastRow]:
    if days < 1:
        raise ValueError("days must be >= 1")
    if safety_stock < 0:
        raise ValueError("safety_stock must be >= 0")

    model = ensure_model(model_path=model_path, csv_path=csv_path)
    future = model.make_future_dataframe(periods=days)
    forecast = model.predict(future)[["ds", "yhat"]].tail(days).copy()

    rows: list[ForecastRow] = []
    for row in forecast.itertuples(index=False):
        demand = max(0, int(round(row.yhat)))
        purchase_plan = max(demand, int(round(demand * (1 + safety_stock))))
        rows.append(
            ForecastRow(
                date=pd.Timestamp(row.ds).date().isoformat(),
                forecast=demand,
                purchase_plan=purchase_plan,
            )
        )
    return rows


def model_health(model_path: Path = MODEL_PATH) -> dict[str, bool]:
    return {"model_loaded": model_path.exists()}
