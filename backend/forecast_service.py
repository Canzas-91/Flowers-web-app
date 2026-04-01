from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
import contextlib
import uuid

import cmdstanpy
import joblib
import numpy as np
import pandas as pd
from prophet import Prophet
from cmdstanpy.utils import filesystem


BACKEND_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = BACKEND_DIR.parent
DATA_PATH = (
    PROJECT_ROOT / "synthetic_orders.csv"
    if (PROJECT_ROOT / "synthetic_orders.csv").exists()
    else BACKEND_DIR / "synthetic_orders.csv"
)
MODEL_PATH = BACKEND_DIR / "prophet_model.joblib"
TMP_DIR = BACKEND_DIR / "tmp"
STAN_OUTPUT_DIR = TMP_DIR / "stan_runs"


@dataclass
class ForecastRow:
    date: str
    forecast: int
    purchase_plan: int


REGRESSOR_COLUMNS = ("is_weekend", "month_sin", "month_cos")


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


def _clip_outliers_iqr(daily: pd.DataFrame) -> pd.DataFrame:
    cleaned = daily.copy()
    q1 = cleaned["y"].quantile(0.25)
    q3 = cleaned["y"].quantile(0.75)
    iqr = q3 - q1
    if not np.isfinite(iqr) or iqr <= 0:
        return cleaned

    lower = max(0.0, float(q1 - 1.5 * iqr))
    upper = float(q3 + 1.5 * iqr)
    cleaned["y"] = cleaned["y"].clip(lower=lower, upper=upper)
    return cleaned


def _add_calendar_features(frame: pd.DataFrame) -> pd.DataFrame:
    out = frame.copy()
    dates = pd.to_datetime(out["ds"])
    month = dates.dt.month.astype(float)

    out["is_weekend"] = (dates.dt.weekday >= 5).astype(int)
    out["month_sin"] = np.sin(2.0 * np.pi * month / 12.0)
    out["month_cos"] = np.cos(2.0 * np.pi * month / 12.0)
    return out


def _build_prophet_model() -> Prophet:
    model = Prophet(
        yearly_seasonality=True,
        weekly_seasonality=True,
        daily_seasonality=False,
        seasonality_mode="additive",
        changepoint_prior_scale=0.08,
        seasonality_prior_scale=8.0,
    )
    for reg in REGRESSOR_COLUMNS:
        model.add_regressor(reg)
    return model


def train_and_save_model(
    *,
    csv_path: Path = DATA_PATH,
    model_path: Path = MODEL_PATH,
) -> Path:
    _ensure_prophet_backend()
    history = _clip_outliers_iqr(build_daily_demand(csv_path))
    history = _add_calendar_features(history)

    model = _build_prophet_model()
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
    start_date = pd.Timestamp.now().normalize()
    future = pd.DataFrame({"ds": pd.date_range(start=start_date, periods=days, freq="D")})
    future = _add_calendar_features(future)
    forecast = model.predict(future)[["ds", "yhat"]].copy()

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


def evaluate_holdout_metrics(
    *,
    csv_path: Path = DATA_PATH,
    test_days: int = 30,
) -> dict[str, float | int]:
    
    if test_days < 1:
        raise ValueError("test_days must be >= 1")

    _ensure_prophet_backend()
    daily = _clip_outliers_iqr(build_daily_demand(csv_path))
    if len(daily) < 8:
        raise ValueError("Not enough history rows to evaluate (need at least 8 days).")

    test_days = int(min(test_days, max(1, len(daily) // 2)))
    train = daily.iloc[:-test_days].copy()
    test = daily.iloc[-test_days:].copy()

    train = _add_calendar_features(train)
    test_features = _add_calendar_features(test[["ds"]].copy())

    model = _build_prophet_model()
    model.fit(train, output_dir=str(STAN_OUTPUT_DIR.resolve()))
    pred = model.predict(test_features)[["ds", "yhat"]]

    merged = test.merge(pred, on="ds", how="left")
    y = merged["y"].astype(float).to_numpy()
    yhat = np.clip(merged["yhat"].astype(float).to_numpy(), 0, None)

    mae = float(np.mean(np.abs(y - yhat)))
    rmse = float(np.sqrt(np.mean((y - yhat) ** 2)))

    denom = np.where(y == 0, np.nan, y)
    mape = float(np.nanmean(np.abs((y - yhat) / denom)) * 100.0)
    accuracy = float(max(0.0, 1.0 - (mape / 100.0)))

    return {
        "rows": int(len(daily)),
        "train_rows": int(len(train)),
        "test_rows": int(len(test)),
        "test_days": int(test_days),
        "mae": mae,
        "rmse": rmse,
        "mape_percent": mape,
        "accuracy": accuracy,
    }
