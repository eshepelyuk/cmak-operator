#!/bin/bash

helm lint . --strict
helm lint . --strict -f test/linter/values-lint.yaml
helm dep up test/linter/subchart && helm lint test/linter/subchart --strict
