.PHONY: test
test: test-lint test-unit

.PHONY: test-lint
test-lint:
	@./test/linter/test.sh
	@echo
	@echo =======================
	@echo = LINTER TESTS PASSED =
	@echo =======================

.PHONY: test-unit
test-unit:
	@helm plugin ls | grep unittest || helm plugin install https://github.com/quintush/helm-unittest
	@helm unittest -f 'test/unit/*.yaml' -3 .
	@echo
	@echo =====================
	@echo = UNIT TESTS PASSED =
	@echo =====================
