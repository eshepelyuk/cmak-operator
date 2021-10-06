#!/bin/bash

helm lint . --strict
helm lint . --strict -f test/linter/values-lint.yaml
helm lint . --strict -f test/linter/values-ssl.yaml
helm dep up test/linter/subchart && helm lint test/linter/subchart --strict

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


