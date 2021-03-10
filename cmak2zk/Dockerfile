FROM python:3.8-alpine3.12

COPY *.py /app/bin/

RUN set -x && \
  apk add --verbose --update --no-cache jq curl && \
  pip install click~=7.0 kazoo~=2.8 zk-shell~=1.3 ruamel.yaml~=0.16 jsonmerge~=1.8

ENTRYPOINT ["python3", "/app/bin/cmak2zk.py"]
CMD ["--help"]

WORKDIR /app/
