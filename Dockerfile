FROM python:3.7.8

ENV HOST='0.0.0.0'

RUN apt-get update && apt-get install -y vim

ADD https://unpkg.com/react@16/umd/react.development.js /app/react.dev.js

COPY ./requirements.txt /app/requirements.txt

COPY ./app.py /app/app.py

WORKDIR /app

RUN pip install -r requirements.txt

EXPOSE 5000

CMD ["python", "app.py"]