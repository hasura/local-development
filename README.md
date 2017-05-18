# Pre-requisites

- Install minikube (= 0.18) (https://kubernetes.io/docs/getting-started-guides/minikube/#installation). Do not install version 0.19. There are issues with kube-dns shipped with minikube 0.19.
''
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
  We wait for the ``services`` key's summary to say 'Synced'

- To access the cluster on localhost (actually on the vcap.me domain), we have to setup port forwarding:
  - For Windows, follow instructions here: https://github.com/hasura/support/issues/250#issuecomment-299862303.
  - For Linux/Mac, Run: ``sudo ssh -p 22 80:$(minikube ip):80 docker@$(minikube ip)``. The default password for `docker` user is `tcuser`.
  - This will forward port 80 on your local machine to the minikube cluster.
- Your Hasura project should now be accessible at http://console.vcap.me.
  ``kubectl -n hasura get pods`` shows all the Hasura platform services as running (data, auth, console, sshd, postgres, session-redis etc.)
- Login to the console with: admin, adminpassword
- Postgres login: admin, pgpassword

# Cleanup / uninstall / retry if error
- Delete the minikube instance: ``minikube delete``
- Re-create it with: ``minikube start``

# Exposing local minikube to public Internet

Follow the instructions here: https://github.com/hasura/ngrok

# Upcoming features
- Migration from local development (minikube) to Kubernetes cluster on any cloud provider.
