#Pre-requisites

- Install minikube:
- Install kubectl:
- Make sure you get a domain label for your minikube IP (say it's 192.168.99.101):
```
curl \
  -H 'Authorization: Bearer <beta.hasura.io user-token>' \
  -d '{"ipaddr": "192.168.99.101"}' \
  https://cloud.beta.hasura.io/localdev
```
- Let's say the domain label is: ``c101.hasura.me``


#Instructions:

- Edit ``controller-configmap.yaml`` and sent ``controller-conf.json -> provider.Local.gatewayIp`` to the minikube ip obtained from above.
- Edit ``project-conf.yaml`` and set the domain to the value generated above.
- Run ``./gen-project-conf.sh | kubectl create -f -``
- Run ``kubectl create -f project-secrets.yaml``
- Run ``kubectl create ns hasura``
- Run ``kubectl create -f controller-configmap.yaml``
- Run ``kubectl create -f shukra-deployment.yaml``
