**NOTE**: If you have already downloaded and setup local development before, please delete your minikube instance and start afresh. You can take dump of the database if you want to keep the data.

# Pre-requisites

- Install minikube (= 0.18.0) (https://kubernetes.io/docs/getting-started-guides/minikube/#installation). Do not install version 0.19. There are issues with kube-dns shipped with minikube 0.19.

- Install latest kubectl (>= 1.6.0) (https://kubernetes.io/docs/tasks/kubectl/install/)

- Start minikube:

```
minikube start --kubernetes-version v1.6.3

```
- Get your minikube ip:
```
minikube ip
```


# Instructions:

- Clone this repo and cd into the directory.

- Edit ``controller-configmap.yaml`` and set ``controller-conf.json -> provider.Local.gatewayIp`` to the minikube ip obtained from above.
- Run ``kubectl create -f project-conf.yaml``
- Run ``kubectl create -f project-secrets.yaml``

- Run ``kubectl create ns hasura``
- Run ``kubectl create -f controller-configmap.yaml``

- A fair warning, the next two steps will roughly download about 1-1.5GB of docker images.

- Run ``kubectl create -f shukra-init.yaml``

- This will take a while, follow the logs by running:

``kubectl logs platform-init-v0.11.0 -n hasura --follow``

  When you see a line that says "successfully initialised the platform's state", you can move onto the next step.

- Now, run ``kubectl create -f shukra-deployment.yaml``

- This will take some time too. You can either follow the logs of the shukra pod in the hasura namespace or check the status of the project as follows:

``kubectl get cm hasura-project-status -o json --watch``

This outputs some JSON. We wait for the ``services`` key's summary to say 'Synced'

- To access the cluster on locally (actually on the vcap.me domain), we have to setup port forwarding:
  - For Windows, follow instructions here: https://github.com/hasura/support/issues/250#issuecomment-299862303.
  - For Linux/Mac, Run: ``sudo ssh -p 22 -L 80:$(minikube ip):80 docker@$(minikube ip)`` and ``sudo ssh -p 22 -L 2022:$(minikube ip):2022 docker@$(minikube ip)`` in another window. The default password for `docker` user is `tcuser`.
  - This will forward port 80 and 2022 on your local machine to the minikube cluster.
- Your Hasura project should now be accessible at http://console.vcap.me.
  ``kubectl -n hasura get pods`` shows all the Hasura platform services as running (data, auth, console, sshd, postgres, session-redis etc.)
- Login to the console with: admin, adminpassword
- Postgres login: admin, pgpassword

# Cleanup/Uninstall the project

This will cleanup/uninstall the project including the data in the database.

- Delete the hasura namespace:

```
kubectl delete ns hasura
```
- Delete the project status configmap:

```
kubectl delete configmap hasura-project-status
```
- Delete the data directory:

**Be careful!**. This will delete all data in the database. Take a dump of the data before this if you want to.

```
ssh -p 22 docker@$(minikube ip) sudo rm -rf /data/hasura.io
```
The default password for `docker` user is `tcuser`.

If you want to install again, you can start from the "Instructions" sections in this README.

# Exposing local minikube to public Internet

Follow the instructions here: https://github.com/hasura/ngrok

# Upcoming features
- Migration from local development (minikube) to Kubernetes cluster on any cloud provider.

