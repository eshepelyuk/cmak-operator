#!/bin/sh
set -e

TAG="$(yq r Chart.yaml version)"

git tag -am "Release $TAG" $TAG

skaffold build -t $TAG
