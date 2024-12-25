FROM python:3.7-alpine

ADD ./src /app

WORKDIR /app

RUN pip install -r requirements.txt

RUN chown -R 1005:1005 /app

USER 1005

ENV PORT 80

CMD ["gunicorn", "-b", "0.0.0.0:80", "app:app"]