# Introduction
This is a continuation of a previous project where an application was containerized and hosted in AWS ECR. We use that infrastructure and build on it with Kubernetes. 

We use the available k8s manifest files to create Pods, ReplicaSets, Deployments, and Services. The project ends with a web app and database running in a k8s cluster, and the changes to the web app being rolled out via changes to the relevant Deployment manifest.

# Steps To Replicate
1. Use the bash script in setup_docker.sh to configure Linux workstation.
1. Run `kind create cluster --config ~/kind.yaml` to create the k8s cluster (or use another cluster)
1. Set your ECR env variable - $ECR
1. Login to ECR `aws ecr get-login-password --region us-east-1 | docker login -u AWS $ECR --password-stdin`
1. Get Base64 of ~/.docker/config.json - `base64 ~/.docker/config.json | tr -d "\r\n" | tee secret-dkrcfg`
1. Run the following (remember alias k=kubectl):
    - `for i in color-be color-fe; do k create ns $i; done`
    - `sed -e "s_<base64-dkrcfgjson-here>_$(cat secret-dkrcfg)_g" sample-secret-ecr-be.yaml > secret-ecr-be.yaml`
    - `sed -e "s_<base64-dkrcfgjson-here>_$(cat secret-dkrcfg)_g" sample-secret-ecr-fe.yaml > secret-ecr-fe.yaml`
    - `sed -e "s|<db-password-here>|your_db_password|g" sample-secret-db-pass.yaml > secret-db-pass.yaml`
    - `k apply -f secret-ecr-be.yaml`
    - `k apply -f secret-ecr-fe.yaml`
    -` k apply -f secret-db-pass.yaml -n color-be`
    - `for i in pod rs dep svc rs-svc dep-svc; do k apply -f colors-db-$i.yaml; sleep 1; done`
    - `k apply -f secret-db-pass.yaml -n color-fe`
    - `for i in pod rs dep svc; do k apply -f colors-app-$i.yaml; sleep 1; done`

Voila! If everything goes according to plan, you should have a working replica of this environment. If not, message me - this is a work in progress.