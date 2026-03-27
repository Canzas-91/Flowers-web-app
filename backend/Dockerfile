FROM python:3.12-slim

WORKDIR /app
ENV PIP_DEFAULT_TIMEOUT=180
ENV PIP_RETRIES=15
ENV PIP_INDEX_URL=https://pypi.org/simple

COPY backend/requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir --prefer-binary --disable-pip-version-check -r requirements.txt

COPY backend/ /app/
COPY synthetic_orders.csv /app/synthetic_orders.csv

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8100"]
