#!/bin/bash
set -x
set -e

REGISTRY='registry.localhost'
if [ -z $CI ];then
  REGISTRY='192.168.99.103'
fi

skaffold config set default-repo "${REGISTRY}:5000"
touch values-dev.yaml
skaffold run

[ "$(helm ls --deployed -q | wc -l)" -eq 1 ]

kubectl get all
