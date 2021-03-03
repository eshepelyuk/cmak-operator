import click
import logging
from kazoo.client import KazooClient
from pathlib import Path
from hashlib import md5


FORMAT = '%(asctime)-15s %(message)s'
logging.basicConfig(format=FORMAT, level=logging.INFO)


@click.command()
@click.option('--overwrite-zk/--no-overwrite-zk', "over_zk", default=True)
@click.argument("zk_url", type=str)
@click.argument("zk_root", type=str)
@click.argument('json_dir', type=click.Path(exists=True, dir_okay=True, file_okay=False))
def cmak2zk(over_zk, zk_url, zk_root, json_dir):

    zk = KazooClient(hosts=zk_url)
    zk.start()

    for json_file in Path(json_dir).glob("*.json"):
        json_b = json_file.read_bytes()
        dst = f"{zk_root}/{json_file.stem}"

        if zk.exists(dst):
            file_md5 = md5(json_b).hexdigest()

            zk_b, stat = zk.get(dst)
            zk_md5 = md5(zk_b).hexdigest()
            logging.info(f"md5 of {dst}: {zk_md5}, md5 of {json_file}: {file_md5}")

            if zk_md5 != file_md5 and over_zk is True:
                zk.set(dst, json_b)
                logging.info(f"Overwritten {dst} from {json_file}")
        else:
            zk.create(dst, json_b, makepath=True)
            logging.info(f"Created {dst} from {json_file}")

    zk.stop()


if __name__ == "__main__":
    cmak2zk()
