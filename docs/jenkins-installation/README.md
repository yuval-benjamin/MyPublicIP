# Installing Jenkins using a Helm Chart

## Prerequisites
1. The helm command

## Installation

```bash
helm repo add jenkins https://charts.jenkins.io
helm repo update
helm install my-jenkins jenkins/jenkins
```

Now follow the printed directions to retrieve your admin password and port forwarding.

The jenkins needs a Service Account that has enough permissions to create resources and install helm charts on the cluster.
Use the jenkins-SA files to create a Service Account named *deployer*:

```bash
kubectl apply -f docs/jenkins-installation/jenkins-SA
```