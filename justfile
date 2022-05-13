export E2E_TEST := "default"

default:
  @just --list

test-lint:
	./test/linter/test.sh
	echo
	echo =======================
	echo = LINTER TESTS PASSED =
	echo =======================

test-unit:
	helm plugin ls | grep unittest || helm plugin install https://github.com/quintush/helm-unittest
	helm unittest -f 'test/unit/*.yaml' -3 .
	echo
	echo =====================
	echo = UNIT TESTS PASSED =
	echo =====================

test: test-lint test-unit

_skaffold-ctx:
  skaffold config set default-repo localhost:5000

# (re) create local k8s cluster using k3d
k3d: _chk-py && _skaffold-ctx
  #!/usr/bin/env bash
  set -euxo pipefail

  k3d cluster rm cmak-operator || true
  k3d cluster create --config ./test/e2e/k3d.yaml

  source .venv/bin/activate
  pytest --capture=tee-sys -p no:warnings test/e2e/traefik.py

# install into local k8s
up: _skaffold-ctx down
  skaffold run

# remove from local k8s
down:
  skaffold delete || true

_chk-py:
  #!/usr/bin/env bash
  set -euxo pipefail
  if [ ! -d .venv ]; then
    python3 -mvenv .venv
    pip3 install -r test/e2e/requirements.txt
  fi

# run only e2e test script
test-e2e-sh: _chk-py
  #!/usr/bin/env bash
  set -euxo pipefail

  source .venv/bin/activate
  pytest --capture=tee-sys -p no:warnings test/e2e/{{E2E_TEST}}/test.py

# run single e2e test
test-e2e: up test-e2e-sh

