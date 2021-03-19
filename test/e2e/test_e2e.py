import requests
from kazoo.client import KazooClient
from time import sleep


def waitUntilClusters(api_url):
    for i in range(12):
        response = requests.get(f"{api_url}/api/status/clusters")
        assert response.status_code == 200
        if len(response.json()['clusters']['active']) == 2:
            return True
        else:
            print(f"Waiting CronJob #{i}, {i * 20} sec")
            sleep(20)

    return False


def test_clusters(api_url, zk_url):
    response = requests.get(f"{api_url}/api/status/clusters")
    assert response.status_code == 200
    assert len(response.json()['clusters']['active']) == 2

    response = requests.get(f"{api_url}/api/status/cluster/topics")
    assert response.status_code == 200
    assert response.json()["topics"] == ["__consumer_offsets", "test"]

    zk = KazooClient(hosts=zk_url)
    zk.start()
    zk.delete("/kafka-manager/configs/cluster-disabled", recursive=False)
    zk.stop()

    response = requests.get(f"{api_url}/api/status/clusters")
    assert response.status_code == 200
    assert len(response.json()['clusters']['active']) == 1

    assert waitUntilClusters(api_url) == True
