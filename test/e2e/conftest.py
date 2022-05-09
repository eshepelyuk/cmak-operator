import pytest


@pytest.fixture(scope="module")
def api_url(request):
    return "https://localhost:18443"


@pytest.fixture(scope="module")
def zk_url(request):
    return "localhost:18080"
