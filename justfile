@test: test-lint test-unit

@test-e2e:
  helm test cmak-operator --logs

@test-lint:
	./test/linter/test.sh
	echo
	echo =======================
	echo = LINTER TESTS PASSED =
	echo =======================

@test-unit:
	helm plugin ls | grep unittest || helm plugin install https://github.com/quintush/helm-unittest
	helm unittest -f 'test/unit/*.yaml' -3 .
	echo
	echo =====================
	echo = UNIT TESTS PASSED =
	echo =====================

@_skaffold-ctx:
    skaffold config set default-repo localhost:5000

# (re) create local k8s cluster using k3d
@k3d: && _skaffold-ctx
    k3d cluster create --config ./test/e2e/k3d.yaml
    kubectl apply -f test/e2e/kafka.yaml

# deploy chart to local k8s
@up: _skaffold-ctx
    skaffold run
