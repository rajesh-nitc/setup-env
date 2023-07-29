#!/bin/bash

# Tested on Ubuntu 20.04 LTS on WSL

set -xe

PYTHON_VERSION=3.12
TERRAFORM_VERSION=1.3.1

sudo apt update
sudo apt install -y curl wget git unzip

# python
sudo apt install -y software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update
sudo apt install -y python${PYTHON_VERSION}
python${PYTHON_VERSION} --version
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python${PYTHON_VERSION} 1
python3 --version
sudo apt install -y python${PYTHON_VERSION}-dev python${PYTHON_VERSION}-venv

# pip
wget https://bootstrap.pypa.io/get-pip.py
sudo python3 get-pip.py
pip3 --version

# gcloud cli
sudo apt-get install -y apt-transport-https ca-certificates gnupg curl sudo
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update
sudo apt-get install -y google-cloud-cli

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

# pre-commit
pip3 install pre-commit

# docker
sudo apt install -y apt-transport-https ca-certificates gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable'
sudo apt install -y docker-ce
sudo usermod -a -G docker ${USER}
sudo service docker start

# install nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.39.3/install.sh | bash

# install node
nvm install node

# If code . does not work in WSL, Update PATH in ~/.bashrc - Put quotes around "Program Files" AND "Microsoft VS Code"

# zsh
# sudo apt install -y zsh

# ohmyzsh
# sudo sed -i s/required/sufficient/g /etc/pam.d/chsh
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
