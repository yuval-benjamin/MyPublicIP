# MyPublicIP

This is a Python Flask app to discover your public IP.

## App Main Page
![alt text](./docs/images/main-page.png?raw=true "output")

## App Architecture 
![alt text](./docs/images/architecture.png?raw=true "output")

# Deploy on your own
## Prerequisites
1. A Kuberenetes cluster
2. A Jenkins instance, preferably on your K8s cluster, with a Slack Notification Plugin configured. If you do not have one, follow this [tutorial](https://github.com/yuval-benjamin/MyPublicIP/tree/main/docs/jenkins-installation)


## Steps

1. Create a Jenkins pipeline and connect it to this git
2. Run the main branch 
3. To make sure the app is deployed, On your K8s cluster run:
```bash
kubectl get pods
```
The output should be something like this:

![alt text](./docs/images/kubectl-get-pods.png?raw=true "output")

4. If you have created your app internally (no Ingress), you can still access the app and make sure it works using this command: 
```bash
sudo kubectl port-forward svc/my-public-ip 80:80
```
and access the app on http://<KubernetesIP

## Challenges I Encountered 
* Issues with creating an app password with Google - Used Slack instead. 
* App version staying static between different commits - Used [Uplift](http://upliftci.dev), an automatic tool to bump versions and create tags, according to conventional commits (That also creates a CHANGELOG!). 

## What's Next?
- Moving all credentials from Jenkins to one place (e.g AWS Secrets Manager).
- Keeping track of helm versions, maybe upload them to a designated registry.
- Keeping all Jenkins Configuration in Git, using the Configuration As Code Plugin.