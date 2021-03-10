# CMAK operator

![Release](https://img.shields.io/github/v/tag/eshepelyuk/cmak-operator?logo=github&sort=semver&style=for-the-badge&label=current)
![Docker Hub](https://img.shields.io/docker/pulls/eshepelyuk/cmak-operator-cli?logo=docker&style=for-the-badge)
![Artifact HUB](https://img.shields.io/endpoint?style=for-the-badge&url=https://artifacthub.io/badge/repository/cmak-operator)
![MIT licence](https://img.shields.io/github/license/eshepelyuk/cmak-operator?logo=mit&style=for-the-badge)

CMAK operator is a set of tools packaged as Helm chart, that allows to install
and configure [CMAK](https://github.com/yahoo/CMAK)
(previously Kafka Manager) into Kubernetes cluster.

[CMAK](https://github.com/yahoo/CMAK) (previously Kafka Manager)
is well-known and mature tool for monitoring and managing
[Apache Kafka](https://kafka.apache.org/) clusters.

## Installation

CMAK operator could be installed only with [Helm 3](https://helm.sh/docs/).
Helm chart is published to public Helm repository, hosted on GitHub itself.

It’s recommended to install CMAK operator into a dedicated namespace.

Add Helm repository

    $ helm repo add cmak https://eshepelyuk.github.io/cmak-operator
    $ helm repo update

Install latest version

    $ helm install --create-namespace -n cmak-ns mycmak cmak/cmak-operator

Search for available versions

    $ helm search repo cmak-operator --versions
    NAME                    CHART VERSION   APP VERSION     DESCRIPTION
    cmak/cmak-operator      0.2.1           3.0.0.5         CMAK operator for K8S.
    cmak/cmak-operator      0.2.0           3.0.0.5         CMAK operator for K8S.

Install specific version

    $ helm install --create-namespace -n cmak-ns --version 0.2.1 mycmak cmak/cmak-operator

### Verify installation

<div class="important">

By default, CMAK operator doesn’t create neither `Ingress`
nor any other K8S resources to expose UI via HTTP.

</div>

The simpliest test is to port forward CMAK UI HTTP port and access it from browser .

    $ kubectl port-forward -n cmak-ns service/cmak 9000:9000

Then, open <http://localhost:9000> in your browser.

## Configuration

### CMAK application

CMAK uses configuration file
[/cmak/conf/application.conf](https://github.com/yahoo/CMAK/blob/master/conf/application.conf).
Every parameter could be overriden via JVM system property, i.e. `-DmyProp=myVal`.
Properties are passed to CMAK container via `values.yaml`.

For example to enable basic auth add following to `values.yaml`.

``` yaml
ui:
  extraArgs:
  - "-DbasicAuthentication.enabled=true"
  - "-DbasicAuthentication.username=admin"
  - "-DbasicAuthentication.password=password"
```

### Kafka clusters

It’s extremely easy to configure multiple clusters in CMAK,
starting from cluster setup, connection settings and ending with authorization
using [Helm values files](https://helm.sh/docs/chart_template_guide/values_files/).

Check [CMAK operator values](https://artifacthub.io/packages/helm/cmak-operator/cmak-operator?modal=values-schema)
for all available options and their description.

Minimal values.yaml configuration for adding a several Kafka clusters to CMAK.

``` yaml
cmak:
  clusters:
    - name: "cluster-stage"
      curatorConfig:
        zkConnect: "kafka01.stage:2181,kafka02.stage:2181"
    - name: "cluster-prod"
      curatorConfig:
        zkConnect: "kafka01.prod:2181,kafka02.prod:2181,kafka03.prod:2181"
```

Connection settings could be configured for all clusters at once or per dedicated cluster.

``` yaml
cmak:
  clustersCommon:
    curatorConfig:
      zkMaxRetry: 100 
  clusters:
    - name: "cluster-stage"
      kafkaVersion: "2.5.0" 
      curatorConfig:
        zkConnect: "kafka01.stage:2181,kafka02.stage:2181"
    - name: "cluster-prod"
      kafkaVersion: "2.1.0" 
      enabled: false
      curatorConfig:
        zkConnect: "kafka01.prod:2181,kafka02.prod:2181,kafka03.prod:2181"
```

-   this setting is applied to both clusters.

-   applied only to `cluster-stage`.

-   applied only to `cluster-prod`.

Configuration should be passed to helm via command line during installation or upgrade.

``` bash
$ helm install --create-namespace -n cmak-ns -f cmak-values.yaml mycmak cmak/cmak-operator
```

## Architecture

![Component diagram](http://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.githubusercontent.com/eshepelyuk/cmak-operator/master/arch.puml)

CMAK operator comprises following components:

-   [CMAK](https://github.com/yahoo/CMAK/),
    powered by [Docker image](https://hub.docker.com/r/hlebalbau/kafka-manager/)
    from [@hleb-albau](https://github.com/hleb-albau/kafka-manager-docker).

-   [Apache ZooKeeper](https://zookeeper.apache.org/),
    powered by [official Docker image](https://hub.docker.com/_/zookeeper/).

-   Custom [cmak2zk tool](https://hub.docker.com/repository/docker/eshepelyuk/cmak2zk),
    used to configure Kafka clusters in CMAK from YAML files.

Following desing choices were made.

### Dedicated Zookeeper instance.

TO BE DEFINED.

### Not using REST for configuring CMAK clusters.

TO BE DEFINED.

### Reconciliation with CronJob.

TO BE DEFINED.

## Troubleshooting

CMAK doesn’t configure clusters from Helm values  
-   CMAK settings are not applied immediately, but only after `reconcile.schedule` period had passed.

-   Check logs of cron job to see if there’s no connection failure to ZK.

## Standalone cmak2zk tool

`cmak2zk` was developed as a part of `CMAK operator` and actively used by the operator itself.
But the same time this tool could be used on its own outside of Helm charts and Kubernetes.

Its purpose is to take Kafka cluster configuration for CMAK in YAML format
and populate CMAK compatible config in Zookeeper.
This allows to avoid manual configuration of CMAK and provides better possibilities
to use CMAK in declarative configuration or GitOps based flows.

`cmak2zk` is distributed as docker image
[available at DockerHub](https://hub.docker.com/repository/docker/eshepelyuk/cmak2zk).

To see available options, run the image without parameters.

    $ docker run eshepelyuk/cmak2zk:1.4.1
    Usage: cmak2zk.py [OPTIONS] ZK_URL YAML_CFG
    .....

Example `docker-compose` and Kafka cluster configuration are located at `cmak2zk/examples`.
One could run them using commands below.

    $ curl -sLo clusters.yaml \
      https://raw.githubusercontent.com/eshepelyuk/cmak-operator/master/cmak2zk/examples/clusters.yaml

    $ curl -sLo docker-compose-cmak2zk.yaml \
      https://raw.githubusercontent.com/eshepelyuk/cmak-operator/master/cmak2zk/examples/docker-compose-cmak2zk.yaml

    $ docker-compose -f docker-compose-cmak2zk.yaml up

Wait for some time until components are stabilizing, it may take up to 5 mins.
Then, open your browser at <http://localhost:9000>.
There should be two pre configured clusters, pointing to the same Kafka instance, running in Docker.
