#!/bin/bash

set -xe

TERRAFORM_VERSION=1.1.5
TERRAFORM_VALIDATOR_VERSION=2021-03-22
TERRAFORM_DOCS_VERSION=0.10.1

sudo apt-get update --allow-releaseinfo-change
sudo apt-get install -y curl wget git unzip

# vs code
# if wsl: commented
# if chromebook: uncomment
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get update --allow-releaseinfo-change
sudo apt-get install -y code
rm packages.microsoft.gpg

# gcloud sdk
sudo apt install -y apt-transport-https ca-certificates gnupg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update --allow-releaseinfo-change && sudo apt-get install -y google-cloud-sdk

# gcloud additional components
sudo apt install -y kubectl google-cloud-sdk-skaffold google-cloud-sdk-nomos google-cloud-sdk-kpt

# kustomize
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
sudo mv kustomize /usr/local/bin

# terraform
sudo apt-get install -y unzip
curl -k -O https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# terraform-docs
curl -k -LO https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64
mv terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64 terraform-docs
chmod +x terraform-docs
sudo mv terraform-docs /usr/local/bin

# python
sudo apt install -y python3 python3-dev python3-venv python3-pip 
pip3 install pip-tools

# jupyter notebook
# pip3 install jupyterlab
# pip3 install bash_kernel
# python3 -m bash_kernel.install

# pre-commit terraform
pip3 install pre-commit

# checkov terraform
pip3 install checkov

# tflint
curl https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# terraform-validator
gsutil cp gs://terraform-validator/releases/${TERRAFORM_VALIDATOR_VERSION}/terraform-validator-linux-amd64 .
chmod +x terraform-validator-linux-amd64
sudo mv terraform-validator-linux-amd64 /usr/local/bin/terraform-validator

# docker
sudo apt-get install -y apt-transport-https ca-certificates gnupg lsb-release
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update --allow-releaseinfo-change
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -a -G docker ${USER}

# zsh
sudo apt install -y zsh
sudo sed -i s/required/sufficient/g /etc/pam.d/chsh

# ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
