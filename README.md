# CMAK (prev. Kafka Manager) for Kubernetes

[![Current](https://img.shields.io/github/v/tag/eshepelyuk/cmak-operator?logo=github&sort=semver&style=for-the-badge&label=current)](https://github.com/eshepelyuk/cmak-operator/releases/latest)
[![Artifact HUB](https://img.shields.io/endpoint?style=for-the-badge&url=https://artifacthub.io/badge/repository/cmak-operator)](https://artifacthub.io/packages/helm/cmak-operator/cmak-operator)
[![MIT License](https://img.shields.io/github/license/eshepelyuk/cmak-operator?logo=mit&style=for-the-badge)](https://opensource.org/licenses/MIT)

[CMAK](https://github.com/yahoo/CMAK) (prev. Kafka Manager)
is a tool for monitoring and managing [Apache Kafka](https://kafka.apache.org/) clusters.

CMAK operator is a Helm chart combining set of utilities,
that allows to install and configure CMAK in K8s cluster.

![Component diagram](https://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.githubusercontent.com/eshepelyuk/cmak-operator/master/arch.puml)

CMAK operator comprises following components:

* [CMAK](https://github.com/yahoo/CMAK/),
  powered by [CMAK docker](https://github.com/eshepelyuk/cmak-docker).
* [Apache ZooKeeper](https://zookeeper.apache.org/),
  powered by [official Docker image](https://hub.docker.com/_/zookeeper/).
* Custom [cmak2zk tool](https://github.com/users/eshepelyuk/packages/container/package/dckr%2Fcmak2zk),
  for configuring Kafka clusters in CMAK from YAML files.

## Installation

`cmak-operator` chart is published into OCI compatible registry
and requires Helm version >= 3.8.

It's recommended to install CMAK operator into a dedicated namespace.
To install specific `VERSION` use following command.

```sh
helm upgrade -i --wait --create-namespace -n cmak cmak-operator \
  oci://ghcr.io/eshepelyuk/helm/cmak-operator --version <VERSION>
```

To install the latest version - omit `--version` flag from previous command.

### Verify installation

By default, CMAK operator doesn't create neither `Ingress`
nor any other K8s resources to expose UI via HTTP.

The simpliest test is to port forward CMAK UI HTTP port and access it from browser.

```sh
kubectl port-forward -n cmak service/cmak 9000
```

Then, open http://localhost:9000 in a browser.

## Configuration

Configuration should be passed to helm via command line during installation or upgrade.

```sh
helm upgrade -i --wait --create-namespace -n cmak cmak-operator \
  oci://ghcr.io/eshepelyuk/helm/cmak-operator --version <VERSION> \
  -f cmak-values.yaml
```

### CMAK application settings

CMAK uses configuration file
[/cmak/conf/application.conf](https://github.com/yahoo/CMAK/blob/master/conf/application.conf).
Every parameter could be overriden via JVM system property, i.e. `-DmyProp=myVal`.
Properties are passed to CMAK container via `values.yaml`.

For example, to enable basic auth, add following to `values.yaml`.

```yaml
ui:
  extraArgs:
    - "-DbasicAuthentication.enabled=true"
    - "-DbasicAuthentication.username=admin"
    - "-DbasicAuthentication.password=password"
```

### Kafka clusters

It's extremely easy to configure multiple clusters in CMAK,
starting from cluster setup, connection settings and ending with authorization,
using [Helm values files](https://helm.sh/docs/chart_template_guide/values_files/).

Check [CMAK operator values](https://artifacthub.io/packages/helm/cmak-operator/cmak-operator?modal=values-schema)
for all available options and their description.

Minimal values.yaml configuration for adding a several Kafka clusters to CMAK.

```yaml
cmak:
  clusters:
    - name: "cluster-stage"
      curatorConfig:
        zkConnect: "kafka01.stage:2181,kafka02.stage:2181"
    - name: "cluster-prod"
      curatorConfig:
        zkConnect: "kafka01.prod:2181,kafka02.prod:2181,kafka03.prod:2181"
```

Connection settings could be configured for all clusters at once or per selected cluster.

```yaml
cmak:
  clustersCommon:
    curatorConfig:
      zkMaxRetry: 100 # <1>
  clusters:
    - name: "cluster-stage"
      kafkaVersion: "2.4.0" # <2>
      curatorConfig:
        zkConnect: "kafka01.stage:2181,kafka02.stage:2181"
    - name: "cluster-prod"
      kafkaVersion: "2.1.0" # <3>
      enabled: false
      curatorConfig:
        zkConnect: "kafka01.prod:2181,kafka02.prod:2181,kafka03.prod:2181"
```

1. this setting is applied to both clusters.
1. applied only to `cluster-stage`.
1. applied only to `cluster-prod`.

## Alternatives

[AKHQ](https://akhq.io/) project seems to be the most active open source tool
for managing and monitoring Kafka clusters.
It could be missing some functionality from CMAK,
but their developers are open for feature requests and contributions.

## How to contribute

Your contributions like feature suggesstions, bug reports and pull requests are always welcomed.

Please check [CONTRIBUTING](./CONTRIBUTING.md) guide for details.

