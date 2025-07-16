```markdown
# BigLeap API Helm Chart

A Helm chart for deploying the BigLeap API - a simple Express.js RESTful API for user management.

## TL;DR

```bash
helm repo add bigleap https://vedantchimote.github.io/bigleap-helm-chart
helm install my-bigleap bigleap/bigleap
```

## Introduction

This chart bootstraps a BigLeap API deployment on a Kubernetes cluster using the Helm package manager.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

## Installing the Chart

To install the chart with the release name my-bigleap:

```bash
helm install my-bigleap bigleap/bigleap
```

The command deploys BigLeap API on the Kubernetes cluster with default configuration. The Parameters section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the my-bigleap deployment:

```bash
helm delete my-bigleap
```

## Parameters

The following table lists the configurable parameters of the BigLeap chart and their default values.

| Parameter           | Description        | Default        |
|--------------------|--------------------|----------------|
| `image.repository` | Image repository   | `bigleap-api`  |
| `image.tag`        | Image tag          | `1.0.0`        |
| `image.pullPolicy` | Image pull policy  | `IfNotPresent` |
| `replicaCount`     | Number of replicas | `1`            |
| `service.type`     | Service type       | `ClusterIP`    |
| `service.port`     | Service port       | `80`           |

## Updating Your Chart

After making changes, package your chart again, update the index, and push to GitHub:

```bash
helm package ./charts/bigleap -d ./bigleap-helm-chart/
helm repo index ./bigleap-helm-chart/ --url https://vedantchimote.github.io/bigleap-helm-chart
cd bigleap-helm-chart
git add .
git commit -m "Update chart documentation and metadata"
git push origin main
```