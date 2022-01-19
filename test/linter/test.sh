#!/bin/bash

helm lint . --strict
if [ $? -ne 0 ]; then
  exit -1
fi

helm lint . --strict -f test/linter/values-lint.yaml
if [ $? -ne 0 ]; then
  exit -1
fi

helm lint . --strict -f test/linter/values-ssl.yaml
if [ $? -ne 0 ]; then
  exit -1
fi

helm dep up test/linter/subchart && helm lint test/linter/subchart --strict
if [ $? -ne 0 ]; then
  exit -1
fi

helm lint . --strict --set 'tolerations.sample=1'
if [ $? -eq 0 ]; then
  exit 1
fi

helm lint . --strict --set 'tolerations.sample={"qwe", "asd"}'
if [ $? -eq 0 ]; then
  exit 1
fi

helm lint . --strict --set 'nodeSelector={1,2,3}'
if [ $? -eq 0 ]; then
  exit 1
fi

helm lint . --strict --set 'affinity={1,2,3}'
if [ $? -eq 0 ]; then
  exit 1
fi

helm lint . --strict --set 'reconcile.annotations=false'
if [ $? -eq 0 ]; then
  exit 1
fi

helm lint . --strict --set 'reconcile.annotations={1,2,3}'
if [ $? -eq 0 ]; then
  exit 1
fi


