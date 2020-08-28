import click
import logging
from kazoo.client import KazooClient
from pathlib import Path


FORMAT = '%(asctime)-15s %(message)s'
logging.basicConfig(format=FORMAT, level=logging.INFO)


@click.command()
@click.argument("zk_url", type=str)
@click.argument("zk_root", type=str)
@click.argument('json_dir', type=click.Path(exists=True, dir_okay=True, file_okay=False))
def create_cmak_cluster(zk_url, zk_root, json_dir):

    zk = KazooClient(hosts=zk_url)
    zk.start()

    for json_file in Path(json_dir).glob("*.json"):
        dst = f"{zk_root}/{json_file.stem}"
        logging.info(f"Setting {dst} from {json_file}.")

        if zk.exists(dst):
            zk.set(dst, json_file.read_bytes())
        else:
            zk.create(dst, json_file.read_bytes(), makepath=True)

    zk.stop()


if __name__ == "__main__":
    create_cmak_cluster() 
