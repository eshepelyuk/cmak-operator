import pytest


def pytest_addoption(parser):
    parser.addoption("--api-url", action="store", help="cmak api url")
    parser.addoption("--zk-url", action="store", help="zk url")


@pytest.fixture(scope="module")
def api_url(request):
    return request.config.getoption("--api-url")


@pytest.fixture(scope="module")
def zk_url(request):
    return request.config.getoption("--zk-url")
