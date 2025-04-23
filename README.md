# Druid Charts

This repository provides two opinionated Helm charts for Apache Druid:

| Chart       | Use Case    | Description                                                                                                                                                                                                                | Includes Extra Services                               |
|-------------|-------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------|
| `druid`     | Production  | Makes deployments to production environments easy: You control the configuration using YAML only — no embedded XML, JSON or Java system properties. Sensible defaults are provided to minimize your configuration efforts. | No                                                    |
| `druid-dev` | Development | Deploys a stack of charts to provide an out-of-the-box experience for setting up development environments.                                                                                                                 | Yes (Druid Operator, Metrics Server, MinIO, Postgres) |

# Architecture

+ The Druid Operator is used to deploy the cluster, but the Druid CRD (Custom Resource Definition) is fully
  encapsulated to eliminate common configuration quirks such as embedding XML, JSON or Java system properties in YAML.
+ The Kubernetes API replaces ZooKeeper for service discovery, coordination and leader election.
+ Kubernetes jobs replace the middle manager for running ingestion tasks.
+ Existing S3 buckets are used for storing indexing segments and logs.

# Setup

Add the repository to Helm:

```shell
helm repo add druid-charts https://bsure-analytics.github.io/druid-charts
helm repo update
```

## Development Environment

For deployment to a development environment, e.g. Kind (Kubernetes in Docker):

```shell
helm upgrade druid druid-charts/druid-dev --create-namespace --install --namespace druid
helm test druid --namespace druid
kubectl port-forward --namespace druid services/druid-client-routers 8088:80 &
kubectl port-forward --namespace druid services/druid-minio 9001:9001 &
```

... and then you can browse http://localhost:8088 to visit the Druid console.
You can also browse http://localhost:9001 to view the Minio console - the username and password are `minio`/`minio123`,
respectively.

## Production Environment

For deployment to a production environment:

```shell
helm upgrade druid druid-charts/druid --create-namespace --install --namespace druid --values my-values.yaml 
```

As an example for the `my-values.yaml` file, you could copy and edit the [values.yaml](charts/druid-dev/values.yaml)
file from the `druid-dev` chart.

## Troubleshooting

**Druid Console not loading?**
Make sure port 8088 is not already in use, or change the local port in the `kubectl port-forward` command.

**MinIO UI not loading?**
Make sure port 9001 is not already in use, or change the local port in the `kubectl port-forward` command.

**Helm deployment hangs?**
Try running `helm uninstall druid --namespace druid` and then retrying the installation.
