FROM python:3.8-alpine3.12

COPY *.py /opt/

RUN set -x && \
  apk add --update --no-cache jq curl && \
  pip install click~=7.0 kazoo~=2.8

WORKDIR /opt
