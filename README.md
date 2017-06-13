# Prerequisites

- Install [virtualbox](https://www.virtualbox.org/wiki/Downloads).
- Install `hasuractl`.
  - Windows:

    Download [hasuractl.exe](https://storage.googleapis.com/hasuractl/v0.1.1/windows-amd64/hasuractl.exe) and place it in your `PATH`.

  - Linux:

    ```
    curl -Lo hasuractl https://storage.googleapis.com/hasuractl/v0.1.1/linux-amd64/hasuractl && chmod +x hasuractl && sudo mv hasuractl /usr/local/bin/
    ```

    Feel free to leave off the `sudo mv hasuractl /usr/local/bin` if you would like to add hasuractl to your path manually.

  - Mac:

    ```
    curl -Lo hasuractl https://storage.googleapis.com/hasuractl/v0.1.1/darwin-amd64/hasuractl && chmod +x hasuractl && sudo mv hasuractl /usr/local/bin/
    ```

    Feel free to leave off the `sudo mv hasuractl /usr/local/bin` if you would like to add hasuractl to your path manually.

- Install latest kubectl (>= 1.6.0) (https://kubernetes.io/docs/tasks/kubectl/install/)

# Starting hasura

1. Create an account on [beta.hasura.io](https://beta.hasura.io) if you do not have one.

2. Run:

   ```
   hasuractl login
   ```

3. After you have successfully logged in, run this command:

   **NOTE:** Please be advised that if you are running the next command for the first time, it will roughly download about 1-1.5GB of docker images.

   ```
   hasuractl local start
   ```

   It might take a long time for this to finish, depending on your internet connection. The command exits by pointing you to a url to login to the console.

# Stopping hasura

```
hasuractl local stop
```

This will stop the running hasura platform. You can start it again by running `hasuractl local start`.

# Cleaning hasura

If you like to clean the existing hasura platform to start afresh, you can run this:

```
hasuractl local clean
```

**NOTE**: The above command will delete all data and configuration. However, the underlying VM is not deleted and hence the downloaded images still exist inside the VM. This is what you should be using if you plan to run `hasuractl local start` again. If you would also like to delete the underlying VM, you should run this:

```
hasuractl local delete
```

The above command will delete the the VM completely and hence all the downloaded images with it.

# Updating the platform version:

The current version of the platform is `v0.12.2`. No major features are added since `v0.11`. However, we will provide instructions to upgrade to `v0.12` soon.

# Errors:

When you try to login to the console, if it fails with a message saying 'postgres.hasura' is not resolved, run this command:

```
kubectl delete po -n kube-system -l k8s-app=kube-dns
```

Wait for a few seconds and try again.

# Upcoming features
- Exposing local hasura to public internet
- Migration from local development to Kubernetes cluster on any cloud provider.
