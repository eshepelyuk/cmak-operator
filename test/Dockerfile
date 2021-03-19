FROM python:3.8-alpine3.12

COPY e2e/*.py /test/e2e/

RUN set -x && pip install kazoo~=2.8 pytest~=5.4 requests~=2.25

WORKDIR /test

ENTRYPOINT ["pytest"]
CMD ["--help"]
