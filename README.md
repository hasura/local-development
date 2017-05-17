# Pre-requisites

- Install minikube (https://kubernetes.io/docs/getting-started-guides/minikube/#installation)

- Install kubectl (https://kubernetes.io/docs/tasks/kubectl/install/)

- Start minikube:

```
minikube start
```

- Get your "user token" from https://beta.hasura.io/settings

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
- Run ``kubectl create -f shukra-deployment.yaml``
- Several deployments will now automatically be created.
- To access the cluster on localhost (actually on the vcap.me domain), we have to setup port forwarding:
  - For Windows, follow instructions here: https://github.com/hasura/support/issues/250#issuecomment-299862303.
  - For Linux/Mac, Run: ``sudo ssh -p 22 80:$(minikube ip):80 docker@$(minikube ip)``. The default password for `docker` user is `tcuser`.
  - This will forward port 80 on your local machine to the minikube cluster.
- Your Hasura project will be ready, as soon as
  ``console.vcap.me`` is accessible and
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
