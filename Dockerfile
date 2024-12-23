# Only download requirements once
FROM python:3.13-alpine AS builder
WORKDIR /install
COPY src/requirements.txt .
RUN pip install --prefix=/install -r requirements.txt
 
# Run tests
FROM python:3.13-alpine AS tester

COPY --from=builder /install /usr/local
COPY ./src /src
COPY ./tests /tests

RUN python3 -m unittest /tests/test.py

# For production
FROM python:3.13-alpine

COPY --from=tester /src /app
COPY --from=builder /install /usr/local

WORKDIR /app

RUN chown -R 1005:1005 /app
USER 1005

ENV PORT 80

CMD ["gunicorn", "-b", "0.0.0.0:80", "app:app"]