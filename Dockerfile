FROM python:3.8-alpine3.11

COPY *.py /opt/

RUN pip install click~=7.0 kazoo~=2.8

WORKDIR /opt
