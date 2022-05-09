import requests
from kazoo.client import KazooClient
from time import sleep
import urllib3

def waitUntilClusters(api_url):
    for i in range(12):
        response = requests.get(f"{api_url}/api/status/clusters", verify=False)
        assert response.status_code == 200
        if len(response.json()['clusters']['active']) == 2:
            return True
        else:
            print(f"Waiting CronJob #{i}, {i * 20} sec")
            sleep(20)

    return False


def test_clusters(api_url, zk_url):
    urllib3.disable_warnings()

    response = requests.get(f"{api_url}/api/status/clusters", verify=False)
    assert response.status_code == 200
    assert len(response.json()['clusters']['active']) == 2

    response = requests.get(f"{api_url}/api/status/cluster/topics", verify=False)
    assert response.status_code == 200
    assert response.json()["topics"] == ["__consumer_offsets", "test"]

    zk = KazooClient(hosts=zk_url)
    zk.start()
    zk.delete("/kafka-manager/configs/cluster-disabled", recursive=False)
    zk.stop()

    response = requests.get(f"{api_url}/api/status/clusters", verify=False)
    assert response.status_code == 200
    assert len(response.json()['clusters']['active']) == 1

    assert waitUntilClusters(api_url) == True
