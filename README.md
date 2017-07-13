# Prerequisites

- Install [virtualbox](https://www.virtualbox.org/wiki/Downloads).
  - You should have atleast 4GB of RAM (because the VM might take upto 2GB of RAM)
  - You should have a 64bit system (Windows or Mac or Linux)
- Windows users: install [`git-bash`](https://git-for-windows.github.io/):
  - You can use [this git bash installation guide](https://blog.hasura.io/setting-up-git-bash-for-windows-e26b59e44257) for reference
  - Use `git-bash` for running all the subsequent commands in this README!
- Install `hasuractl`.
  - Windows:

    Download [hasuractl.exe](https://storage.googleapis.com/hasuractl/v0.1.4/windows-amd64/hasuractl.exe) and place it in your `PATH`. Refer to this [video reference](https://drive.google.com/file/d/0B_G1GgYOqazYUDJFcVhmNHE1UnM/view) if you need help with the installation on Windows.

  - Linux:

    ```
    curl -Lo hasuractl https://storage.googleapis.com/hasuractl/v0.1.4/linux-amd64/hasuractl && chmod +x hasuractl && sudo mv hasuractl /usr/local/bin/
    ```

    Feel free to leave off the `sudo mv hasuractl /usr/local/bin` if you would like to add hasuractl to your path manually

  - Mac:

    ```
    curl -Lo hasuractl https://storage.googleapis.com/hasuractl/v0.1.4/darwin-amd64/hasuractl && chmod +x hasuractl && sudo mv hasuractl /usr/local/bin/
    ```

    Feel free to leave off the `sudo mv hasuractl /usr/local/bin` if you would like to add hasuractl to your path manually

- Install latest kubectl (>= 1.6.0) (https://kubernetes.io/docs/tasks/kubectl/install/)

### NOTE:

- If you are on windows, you should only use git-bash to execute commands that you see in this documentation.
- If you already have hasuractl installed, replace the old binary with the new one.

# Starting hasura

1. Create an account on [beta.hasura.io](https://beta.hasura.io) if you do not have one

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

# Quickstart

`hasuractl quickstart list` will give you a list of currently available quickstart base repos.

You can choose any project from the available list, for example, if you want to use nodejs-express, you'll have to run the quickstart command with the project name, followed by the desired app name, like-
```
hasuractl quickstart nodejs-express app
```
Doing so will create a copy of the quickstart project in the current directory which you can git-push to your app.

#### NOTE: It's not required that the VM should be running for this command to work. 

# Credentials

You can get the project credentials by running the following command-
```
hasuractl credentials
```
#### NOTE: The VM must be running in order to fetch the project credentials.


# Exposing your local hasura project over internet

`hasuractl local start` gives you a URL (eg, `c100.hasura.me`) that points to your local project, but this URL only works locally on your computer.

If you need your iOS/Android app to access the project, or share the project publicly, you need to expose the project over internet. To do this, login to your beta dashboard, go to https://beta.hasura.io/local-development, and modify the Public URL. After this, you can run

```
hasuractl local expose
```

Now, you can access your project at the Public URL you've configured.

**NOTE**:
On Windows, currently the command does not output anything when using Git Bash. It works nonetheless. You can use CMD instead, ONLY FOR THIS COMMAND.


# Adding your ssh key

Adding your SSH key enables you to use the `git push` feature. To add your ssh key, you can run

```
hasuractl add-ssh-key
```

### NOTE:

- Your public key has to exist before running this command. If you don't have a public key, you can follow the instructions [here](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/#generating-a-new-ssh-key).
- You can also add the public key from the advanced settings in the console.

# Updating the platform version:

The current version of the platform is `v0.12.3`. No major features are added since `v0.11`. However, we will provide instructions to upgrade to `v0.12` soon.

# Common errors & troubleshooting:

1) Windows:
   ```
   ...The system cannot find the PATH specified.
   ```
   You've not added `hasuractl` to the `PATH` correctly and/or you're not using `git-bash`.

2) Virtualbox or minikube errors:

   If you are facing errors of the type: `Error getting state for host: machine does not exist`, try each of the following:

   1. Run `hasuractl local stop` and after a few minutes (check your virtualbox console to see if the VM has actually stopped), run `hasuractl local start` again and everything should be back up.
   2. If that doesn't work, run `hasuractl local clean`, wait for a few minutes and then `hasuractl local start` again.
   3. If none of the above work, remove the `~/.minihasura` folder and start everything from the beginning of this guide again viz. `hasuractl login`, `hasuractl local start`.

# Upcoming features
- Migration from local development to Kubernetes cluster on any cloud provider.
