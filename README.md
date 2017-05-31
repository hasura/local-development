**NOTE:** If you have already setup local development before version ``v0.11.0``, please delete your minikube instance and start afresh. You can take dump of the database if you want to keep the data.

# Pre-requisites

- Install [minikube](https://github.com/kubernetes/minikube/releases/tag/v0.18.0) (version ``0.18.0``) . Do not install version ``0.19.0``. There are issues with kube-dns shipped with minikube 0.19.
- Install latest kubectl (>= 1.6.0) (https://kubernetes.io/docs/tasks/kubectl/install/)
- Install [`jq`](https://stedolan.github.io/jq/), a super handy tool for managing JSON from the command line.

# Instructions:

- Start minikube:

  ```
  minikube start --kubernetes-version v1.6.3
  ```

- Clone this repo and cd into the directory.
  ```
  git clone https://github.com/hasura/local-development.git
  cd local-development
  ```

- Edit ``controller-configmap.yaml`` and set the ``gatewayIp`` field to the ip of your minikube instance. You can get this by running:

  ```
  minikube ip
  ```

- Now create the necessary resources to setup the platform
  ```
  kubectl create -f project-conf.yaml
  kubectl create -f project-secrets.yaml
  kubectl create ns hasura
  kubectl create -f controller-configmap.yaml
  ```

**NOTE:** The next steps will roughly download about 1-1.5GB of docker images.

- Now, initialise the Hasura project (this will run initialise the state for the platform, eg: running initial schema migrations)
  ``` 
  kubectl create -f platform-init.yaml
  ```
  It can take a while, follow the logs by running: ``kubectl logs platform-init-v0.11.0 -n hasura --follow``

  When you see a line that says "**successfully initialised the platform's state**", you can move onto the next step.

- Now, run the Hasura platform. This will bring up all the services and keeps them in sync with the project configuration. 
  ```
  kubectl create -f platform-sync.yaml
  ```
  Again, this command will take some time because all the docker images for running these services will be downloaded. You'll probably have to wait between 5mins to upwards of 20mins depending on your Internet connection. 
  To check the status of the project, run: ``kubectl get cm hasura-project-status -o json | jq -r '.data.services' | jq '.summary.tag'``
  This should output a value "**Synced**", which means that you're good to go!

- To access the platform on a domain, we make use of ``vcap.me``, a domain which always points to 127.0.0.1. For this to work, we have to setup port forwarding:
  - For Windows, follow instructions here: https://github.com/hasura/support/issues/275#issuecomment-303976934.
  - On Linux/Mac, Run:

    ```
    export GW_IP=$(minikube ip) && sudo ssh -N -o UserKnownHostsFile=/dev/null -L 80:$GW_IP:80 -L 2022:$GW_IP:2022 docker@$GW_IP
    ```
    Paste the above command as is (don't substitute any values) into your terminal and run it. The default password for `docker` user is `tcuser`. This will forward port 80 (and hence the sudo) and 2022 on your local machine to the minikube cluster. Once the SSH command runs succesfully, keep that terminal open and don't close it. Ignore this terminal for subsequent instructions.
- Your Hasura project should now be accessible at http://console.vcap.me.
  ``kubectl -n hasura get pods`` shows all the Hasura platform services as running (data, auth, console, sshd, postgres, session-redis etc.)
- Login to the console with: ``admin``, ``adminpassword``
- Postgres login: ``admin``, ``pgpassword``

# Errors:

When ``platform-init`` fails, we have to clean up the state as follows before trying again

  ```
  # Clean up the state
  kubectl delete configmap hasura-project-status
  kubectl delete ns hasura # This will take some time
  minikube ssh "sudo rm -rf /data/hasura.io"
  kubectl create ns hasura

  # Run init once again
  kubectl create -f platform-init.yaml
  ```

# Cleanup/Uninstall the project

This will cleanup/uninstall the project including the data in the database.

- Delete the created resources:

  ```
  kubectl delete ns hasura
  kubectl delete configmap hasura-project-status
  kubectl delete configmap hasura-project-conf
  kubectl delete secret hasura-project-secrets
  ```
- Delete the data directory:

  **Be careful!**. This will delete all data in the database. Take a dump of the data before this if you want to.

  ```
  minikube ssh "sudo rm -rf /data/hasura.io"
  ```
If you want to install again, you can start from the "Instructions" sections in this README.

# Exposing local minikube to public Internet

Follow the instructions here: https://github.com/hasura/ngrok

# Upcoming features
- Migration from local development (minikube) to Kubernetes cluster on any cloud provider.
