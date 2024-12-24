# MyPublicIP

This is a Python Flask app to discover your public IP.

## App Main Page
![alt text](./docs/images/main-page.png?raw=true "output")

## App Architecture 
![alt text](./docs/images/architecture.png?raw=true "output")

# Deploy on your own
## Prerequisites
1. A Kuberenetes cluster
2. A Jenkins instance, preferably on your K8s cluster. If you do not have one follow this [tutorial](https://github.com/yuval-benjamin/MyPublicIP/blob/main/docs/jenkins-installation/README.md)

## Steps

1. Create a Jenkins pipeline and connect it to this git
2. Run the main branch 
3. To make sure the app is deployed, On your K8s cluster run:
```bash
kubectl get pods
```
The output should be something like this:
![alt text](./images/kubectl-get-pods.png?raw=true "output")

4. If you have created your app internally (no Ingress), you can still access the app and make sure it works using this command: 
```bash
sudo kubectl port-forward svc/my-public-ip 80:80
```
and access the app on http://<KubernetesIP