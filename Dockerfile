FROM python:3.11-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

FROM python:3.11-slim AS runner
WORKDIR /app
RUN adduser --disabled-password flaskuser
USER flaskuser
COPY --from=builder /root/.local /home/flaskuser/.local
COPY --chown=flaskuser:flaskuser . .
ENV PATH=/home/flaskuser/.local/bin:$PATH
EXPOSE 5000
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]