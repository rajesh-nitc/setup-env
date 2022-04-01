#!/bin/bash

set -xe

TERRAFORM_VERSION=1.1.5
TERRAFORM_VALIDATOR_VERSION=2021-03-22
TERRAFORM_DOCS_VERSION=0.10.1

sudo apt update
sudo apt install -y curl wget git unzip tcpdump dnsutils

# vs code
# wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
# sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
# sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
# sudo apt update
# sudo apt install -y code
# rm packages.microsoft.gpg

# jetbrains toolbox
# wget -cO jetbrains-toolbox.tar.gz "https://data.services.jetbrains.com/products/download?platform=linux&code=TBA"
# sudo tar -xzf jetbrains-toolbox.tar.gz -C /opt
# rm jetbrains-toolbox.tar.gz

# gcloud cli
sudo apt install -y apt-transport-https ca-certificates gnupg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt update && sudo apt install -y google-cloud-sdk

# gcloud cli components
sudo apt install -y kubectl google-cloud-sdk-skaffold google-cloud-sdk-nomos google-cloud-sdk-kpt

# kustomize
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
sudo mv kustomize /usr/local/bin

# terraform
sudo apt install -y unzip
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

# tldr
pip3 install tldr

# pre-commit terraform
pip3 install pre-commit

# checkov terraform
# pip3 install checkov

# tflint
curl https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# terraform-validator
# gsutil cp gs://terraform-validator/releases/${TERRAFORM_VALIDATOR_VERSION}/terraform-validator-linux-amd64 .
# chmod +x terraform-validator-linux-amd64
# sudo mv terraform-validator-linux-amd64 /usr/local/bin/terraform-validator

# docker
sudo apt-get install -y apt-transport-https ca-certificates gnupg lsb-release
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -a -G docker ${USER}

# path
cat >> ~/.profile <<'EOF'
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
EOF

# zsh
# sudo apt install -y zsh

# ohmyzsh
# sudo sed -i s/required/sufficient/g /etc/pam.d/chsh
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
