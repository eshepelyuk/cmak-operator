import pytest
from requests import ConnectionError, get
from time import sleep


@pytest.fixture(scope="package")
def api_url(request):
    return "https://localhost:18443"


@pytest.fixture(scope="package")
def zk_url(request):
    return "localhost:18080"


@pytest.fixture(scope="package")
def traefik(api_url, zk_url):
    for i in range(10):
        try:
            get(f"{api_url}", verify=False)
            return True
        except ConnectionError:
            print(f"Waiting for Traefik #{i}, {i * 20} sec")
            sleep(20)
    return False


