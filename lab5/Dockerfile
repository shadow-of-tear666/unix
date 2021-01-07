FROM python:slim
USER root

RUN mkdir /app
WORKDIR /app

COPY ./app /app/

RUN pip install -r requirements.txt

ENTRYPOINT ["python", "manage.py", "runserver", "0.0.0.0:80"]