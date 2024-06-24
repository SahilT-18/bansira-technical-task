# Hello World Node.js Application

## Description
This repository contains the required code and steps involved in the deployment of a Node.js "Hello World" application on Kubernetes.

### Prerequisites
- Docker
- Kubernetes cluster
- Helm
- ArgoCD CLI

## Steps 
- Cloning Repository
  - Firstly, clone the repository in your system to fetch the necessary configuration files required for the solution. To clone the repository, run the following command;
    ```
    git clone https://github.com/SahilT-18/bansira-technical-task.git
    ```

- Dockerization
  - Next, configure Docker secrets in the GitHub repository. In your GitHub repository, follow mentioned path to add secrets - `Settings > Secrets > New repository secret > Add secret`.
  - Add the following secrets:
      - Name: `DOCKER_HUB_USERNAME`, Value: [Your Docker Hub username]
      - Name: `DOCKER_HUB_ACCESS_TOKEN`, Value: [Your Docker Hub access token]
  - Once the secrets are configured successfully, you will find a workflow pipeline named as **docker-image.yml** which is responsible to build and push the *Node.js Hello World*  docker image to dockerhub.
  - From the **Actions** section, you have trigger the pipeline manually as I have kept the trigger as `workflow_dispatch`. The trigger can be changed to `push` or `pull` according to your requirement.
  - For reference, you can find same docker image here - https://hub.docker.com/repository/docker/sahilt7/hello-world-node/tags

- Kubernetes Deployment 
  - For this solution, I have used *minikube* as the Kubernetes cluster. You can also use kind or any of cloud provider such as AWS or Azure to have access to a Kubernetes cluster. If you choose to go with minikube, get started by running the command given below;
    ```
    minikube start
    ```
  - As we have installed **kubectl** as a prerequisite, you can use it to interact with the cluster to ensure all the pods are in running state. 
    ```
    kubectl get pods -A
    ```
  - Now, create a namespace for deploying the application.
    ```
    kubectl create namespace argocd
    ```
  - ArgoCD can be installed in the cluster by applying the manifest file to the namespace created.
    ```
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    ```
  - After that, let’s expose our ArgoCD server UI through port forwarding. You can access the ArgoCD UI on `http://localhost:8080/` or `http:instance_public_ip:8080` if you are hosting cluster on cloud any provider.
    ```
    kubectl port-forward svc/argocd-server -n argocd --address 0.0.0.0 8080:443 > /dev/null 2>&1 &
    ```

  - You will be prompted to enter the *username* and *password* for signing in. By default, the username is **admin** and the password can be generated using the following command;
    ```
    kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
    ```
  
  - Now, you can login to ArgoCD via CLI by passing - `argocd login localhost:8080`. It will ask for the username and password. Set both, and the login will be successful.

  - Create the application by executing the mentioned command,
    ```
    argocd app create <application_name> --repo <repository_name> --path <path/to/helm/chart> --dest-server https://kubernetes.default.svc --dest-namespace default
    ```

  - To check the status of the application use - `argocd app get <application_name>`. In the output of the command, you will be able to see that both *Service* and *Deployment* are in **OutOfSync** status.
  Let's sync the application with the following command - `argocd app sync <application_name>`. In the ArgoCD UI, you can now see that the health status of our Service is Healthy and Deployment is Progressing. The Deployment might take some time to change the status to become Healthy.

  - Using port-forward, you can easily access your deployed application.
    ```
    kubectl port-forward svc/<service_name> -n default --address 0.0.0.0 9090:3000 > /dev/null 2>&1 &
    ```

## Conclusion
This template will guide you through the entire process from creating the Docker image to deploying it using Helm and ArgoCD on a Kubernetes cluster.