FROM python:3.8-alpine3.11

COPY *.py *.txt /opt/

RUN pip install -r /opt/requirements.txt

WORKDIR /opt 
