from __future__ import annotations

from fastapi import APIRouter, HTTPException, Query
from pydantic import BaseModel

from forecast_service import evaluate_holdout_metrics, forecast_demand, model_health, train_and_save_model


forecast_router = APIRouter()


class ForecastOut(BaseModel):
    date: str
    forecast: int
    purchase_plan: int


class ForecastHealthOut(BaseModel):
    model_loaded: bool


class ForecastMetricsOut(BaseModel):
    rows: int
    train_rows: int
    test_rows: int
    test_days: int
    mae: float
    rmse: float
    mape_percent: float
    accuracy: float


@forecast_router.get("", response_model=list[ForecastOut])
def get_forecast(
    days: int = Query(default=30, ge=1, le=365),
    safety_stock: float = Query(default=0.15, ge=0, le=5),
) -> list[ForecastOut]:
    try:
        return [ForecastOut(**row.__dict__) for row in forecast_demand(days=days, safety_stock=safety_stock)]
    except (FileNotFoundError, ValueError) as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc
    except Exception as exc:
        raise HTTPException(status_code=500, detail=f"Forecast generation failed: {exc}") from exc


@forecast_router.get("/health", response_model=ForecastHealthOut)
def get_forecast_health() -> ForecastHealthOut:
    return ForecastHealthOut(**model_health())


@forecast_router.get("/metrics", response_model=ForecastMetricsOut)
def get_forecast_metrics(test_days: int = Query(default=30, ge=1, le=365)) -> ForecastMetricsOut:
    try:
        return ForecastMetricsOut(**evaluate_holdout_metrics(test_days=test_days))
    except (FileNotFoundError, ValueError) as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc
    except Exception as exc:
        raise HTTPException(status_code=500, detail=f"Forecast metrics failed: {exc}") from exc


@forecast_router.post("/retrain", response_model=ForecastHealthOut)
def retrain_forecast_model() -> ForecastHealthOut:
    try:
        train_and_save_model()
    except Exception as exc:
        raise HTTPException(status_code=500, detail=f"Forecast retraining failed: {exc}") from exc
    return ForecastHealthOut(**model_health())
