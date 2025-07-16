# BigLeap API Helm Chart

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/bigleap)](https://artifacthub.io/packages/helm/bigleap/bigleap)

A Helm chart for deploying the BigLeap API - a simple Express.js RESTful API for user management with Swagger documentation.

## Introduction

BigLeap API is a RESTful service built with Express.js that provides basic user management capabilities. This Helm chart simplifies the deployment of the BigLeap API on Kubernetes clusters, with configurable options for scaling, resource allocation, and service exposure.

## Features

- Complete user management API with CRUD operations
- Swagger UI for API documentation and testing
- Horizontal Pod Autoscaling support
- Configurable resource requests and limits
- Ingress support for external access
- Prometheus metrics endpoint (optional)

## TL;DR

```bash
# Add the Helm repository
helm repo add bigleap https://vedantchimote.github.io/bigleap-helm-chart

# Update your Helm repositories
helm repo update

# Install the chart with the release name "my-api"
helm install my-api bigleap/bigleap
```

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure (if persistence is enabled)

## Installing the Chart

To install the chart with the release name `my-api`:

```bash
helm install my-api bigleap/bigleap
```

The command deploys BigLeap API on the Kubernetes cluster with default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-api` deployment:

```bash
helm delete my-api
```

This removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |

### Common parameters

| Name                | Description                                                                                  | Value           |
| ------------------- | -------------------------------------------------------------------------------------------- | --------------- |
| `nameOverride`      | String to partially override bigleap.fullname template (will maintain the release name)      | `""`            |
| `fullnameOverride`  | String to fully override bigleap.fullname template                                           | `""`            |
| `commonLabels`      | Labels to add to all deployed objects                                                        | `{}`            |
| `commonAnnotations` | Annotations to add to all deployed objects                                                   | `{}`            |

### BigLeap API parameters

| Name                       | Description                                                          | Value                    |
| -------------------------- | -------------------------------------------------------------------- | ------------------------ |
| `replicaCount`             | Number of BigLeap API replicas                                       | `1`                      |
| `image.repository`         | BigLeap API image repository                                         | `vedantchimote/bigleap-api` |
| `image.tag`                | BigLeap API image tag                                                | `1.0.0`                  |
| `image.pullPolicy`         | BigLeap API image pull policy                                        | `IfNotPresent`           |
| `image.pullSecrets`        | BigLeap API image pull secrets                                       | `[]`                     |
| `podAnnotations`           | Annotations for BigLeap API pods                                     | `{}`                     |
| `podSecurityContext`       | Security context for BigLeap API pods                                | `{}`                     |
| `securityContext`          | Security context for BigLeap API container                           | `{}`                     |
| `resources.limits`         | The resources limits for the BigLeap API container                   | `{}`                     |
| `resources.requests`       | The requested resources for the BigLeap API container                | `{}`                     |
| `nodeSelector`             | Node labels for BigLeap API pods assignment                          | `{}`                     |
| `tolerations`              | Tolerations for BigLeap API pods assignment                          | `[]`                     |
| `affinity`                 | Affinity for BigLeap API pods assignment                             | `{}`                     |

### Service parameters

| Name                      | Description                                                      | Value       |
| ------------------------- | ---------------------------------------------------------------- | ----------- |
| `service.type`            | BigLeap API service type                                         | `ClusterIP` |
| `service.port`            | BigLeap API service port                                         | `80`        |
| `service.nodePort`        | Node port for BigLeap API service                                | `""`        |
| `service.annotations`     | Additional custom annotations for BigLeap API service            | `{}`        |

### Ingress parameters

| Name                  | Description                                                                    | Value                    |
| --------------------- | ------------------------------------------------------------------------------ | ------------------------ |
| `ingress.enabled`     | Enable ingress record generation for BigLeap API                               | `false`                  |
| `ingress.className`   | IngressClass that will be used to implement the Ingress                        | `""`                     |
| `ingress.annotations` | Additional annotations for the Ingress resource                                | `{}`                     |
| `ingress.hosts`       | An array with hosts and paths for the Ingress                                  | `[]`                     |
| `ingress.tls`         | TLS configuration for the Ingress                                              | `[]`                     |

### Autoscaling parameters

| Name                                  | Description                                                                            | Value   |
| ------------------------------------- | -------------------------------------------------------------------------------------- | ------- |
| `autoscaling.enabled`                 | Enable autoscaling for BigLeap API                                                     | `false` |
| `autoscaling.minReplicas`             | Minimum number of BigLeap API replicas                                                 | `1`     |
| `autoscaling.maxReplicas`             | Maximum number of BigLeap API replicas                                                 | `10`    |
| `autoscaling.targetCPUUtilizationPercentage` | Target CPU utilization percentage                                               | `80`    |
| `autoscaling.targetMemoryUtilizationPercentage` | Target Memory utilization percentage                                         | `80`    |

## Configuration and Installation Details

### Environment Variables

The following table lists the configurable environment variables of the BigLeap API chart and their default values:

| Parameter                | Description                                | Default                                                 |
|--------------------------|--------------------------------------------|---------------------------------------------------------|
| `env.PORT`               | Port for the API to listen on              | `3000`                                                  |
| `env.NODE_ENV`           | Node environment                           | `production`                                            |

### Using custom configuration

To use custom configuration, you can specify environment variables using the `env` parameter:

```yaml
env:
  PORT: "8080"
  NODE_ENV: "development"
  CUSTOM_VAR: "custom-value"
```

### Deploying with Ingress

To deploy BigLeap API with Ingress, enable the Ingress controller and define the host:

```yaml
ingress:
  enabled: true
  className: "nginx"
  annotations:
    kubernetes.io/ingress.class: nginx
    kubernetes.io/tls-acme: "true"
  hosts:
    - host: bigleap.example.com
      paths:
        - path: /
          pathType: ImplementationSpecific
  tls:
    - secretName: bigleap-tls
      hosts:
        - bigleap.example.com
```

## About BigLeap API

BigLeap API is a simple Express.js RESTful API designed for user management, supporting CRUD operations. It includes:

- RESTful API for managing users
- API documentation via Swagger UI
- Comprehensive testing using Jest
- Code quality analysis with SonarQube
- In-memory data store (easily replaceable with a database)

For more information, visit the [BigLeap GitHub repository](https://github.com/vedantchimote/bigleap).

## License

Copyright &copy; 2023 Vedant Chimote

Licensed under the MIT License. See [LICENSE](LICENSE) for more information.