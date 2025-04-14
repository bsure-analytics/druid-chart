# Druid Chart

This is an opinionated Helm chart for Apache Druid.
It provides the following features:

+ Use the Druid Operator to bring its Druid and DruidIngestion CRDs,
  but without its quirks like e.g. JSON or Java system properties in YAML configuration.
+ Use K8s instead of ZooKeeper for service discovery, coordination and leader election.
+ Use K8s jobs instead of a middle manager to run the ingestions.
+ Use pre-existing S3 buckets for storing indexing segments and logs.

# Prerequisites

+ Kubernetes
+ Helm
+ GNU Make
+ A secret with the same name as the generated Druid resource and the following keys for accessing the configured S3
  bucket(s):
  + `AWS_ACCESS_KEY_ID`
  + `AWS_REGION`
  + `AWS_SECRET_ACCESS_KEY`

# Development

First, make sure `kubectl get nodes -o wide` is working.
For local development, you can use Kind (Kubernetes in Docker), e.g. bundled with Docker Desktop.

Next, check the file `values.yaml`.
For any values you want to fill in or override, please do so in the file `.values.yaml` - you may need to create this
file first. 

Finally, deploy the druid-operator:

```shell
make
```

That's it - enjoy!
