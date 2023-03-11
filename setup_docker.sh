#!/bin/bash

sudo yum -y update
sudo yum -y install docker git

sudo systemctl start docker
sudo usermod -aG docker ec2-user

curl -sLo kind https://kind.sigs.k8s.io/dl/v0.11.0/kind-linux-amd64
sudo install -o root -g root -m 0755 kind /usr/local/bin/kind
rm -f ./kind
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -f ./kubectl
echo "kind: Cluster" > /home/ec2-user/kind.yaml
echo "apiVersion: kind.x-k8s.io/v1alpha4" >> /home/ec2-user/kind.yaml
echo "nodes:" >> /home/ec2-user/kind.yaml
echo "- role: control-plane" >> /home/ec2-user/kind.yaml
echo "  image: kindest/node:v1.19.11@sha256:07db187ae84b4b7de440a73886f008cf903fcf5764ba8106a9fd5243d6f32729" >> /home/ec2-user/kind.yaml
echo "  extraPortMappings:" >> /home/ec2-user/kind.yaml
echo "  - containerPort: 30000" >> /home/ec2-user/kind.yaml
echo "    hostPort: 30000" >> /home/ec2-user/kind.yaml
echo "  - containerPort: 30001" >> /home/ec2-user/kind.yaml
echo "    hostPort: 30001" >> /home/ec2-user/kind.yaml
# kind create cluster --config /home/ec2-user/kind.yaml
