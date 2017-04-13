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

- Make sure you get a domain label for your minikube IP (say it's 192.168.99.101):
```
curl \
  -H 'Authorization: Bearer <beta.hasura.io user-token>' \
  -d '{"ipaddr": "192.168.99.101"}' \
  https://cloud.beta.hasura.io/v1/localdev
```

- ALTERNATIVELY, you can create your own DNS label and add it to ``/etc/hosts``.
  However, you'll have to add an entry to ``/etc/hosts`` for every subdomain.

- Let's say the domain label is: ``c101.hasura.me``.
  Now, subdomain.c101.hasura.me will redirect to your minikube (this will only work locally ofcourse).

# Instructions:

- Edit ``controller-configmap.yaml`` and set ``controller-conf.json -> provider.Local.gatewayIp`` to the minikube ip obtained from above.
- Edit ``project-conf.yaml`` and set the domain to the value generated above.
- Run ``kubectl create -f project-conf.yaml``
- Run ``kubectl create -f project-secrets.yaml``
- Run ``kubectl create ns hasura``
- Run ``kubectl create -f controller-configmap.yaml``
- Run ``kubectl create -f shukra-deployment.yaml``
- Several deployments will now automatically be created.
  Your Hasura project will be ready, as soon as
  ``console.c101.hasura.me`` is accessible and
  ``kubectl -n hasura get pods`` shows all the Hasura platform services as running (data, auth, console, sshd, postgres, session-redis etc.)
- Login to the console with: admin, adminpassword
- Postgres login: admin, pgpassword

# Cleanup / uninstall / retry if error

- Delete the minikube instance: ``minikube delete``
- Re-create it with: ``minikube start``

# Upcoming features

- Migration from local development (minikube) to kubernetes on any cloud provider
- Expose local minikube to the public Internet for easy testing/sharing (currently, c101.hasura.me type domains
  cannot be shared because they are just labels to point to the local minikube ip)
