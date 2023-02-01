#!/bin/bash

# Tested on Ubuntu 20.04 LTS on WSL

set -xe

TERRAFORM_VERSION=1.3.1
PYTHON_VERSION=3.10.0

sudo apt update
sudo apt install -y curl wget git unzip

# gcloud cli
sudo apt install -y apt-transport-https ca-certificates gnupg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt update && sudo apt install -y google-cloud-sdk

# gcloud cli components
sudo apt install -y kubectl google-cloud-sdk-skaffold

# kustomize
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
sudo mv kustomize /usr/local/bin

# terraform
sudo apt install -y unzip
curl -k -O https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# python
sudo apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev
wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz
sudo tar -xvf Python-${PYTHON_VERSION}.tgz
cd Python-${PYTHON_VERSION}
sudo ./configure --enable-optimizations
sudo make -j 4
sudo make altinstall

# docker
sudo apt install -y apt-transport-https ca-certificates gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable'
sudo apt install -y docker-ce
sudo usermod -a -G docker ${USER}
sudo service docker start

# Update PATH in ~/.bashrc - Put quotes around "Program Files" AND "Microsoft VS Code"

# zsh
# sudo apt install -y zsh

# ohmyzsh
# sudo sed -i s/required/sufficient/g /etc/pam.d/chsh
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
