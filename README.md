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
