import click
import logging
from kazoo.client import KazooClient
from pathlib import Path


FORMAT = '%(asctime)-15s %(message)s'
logging.basicConfig(format=FORMAT, level=logging.INFO)


@click.command()
@click.argument("zk_url", type=str)
@click.argument("path", type=str)
@click.argument("config_file", type=click.File())
def create_cmak_cluster(zk_url, path, config_file):

    zk = KazooClient(hosts=zk_url)
    zk.start()

    logging.info(f"Setting {path} from {config_file.name}.")

    if zk.exists(path):
        zk.set(path, config_file.read().encode())
    else:
        zk.create(path, config_file.read().encode(), makepath=True)

    zk.stop()


if __name__ == "__main__":
    create_cmak_cluster() 
