#!/bin/bash

# Exit script on error
set -e

# =====================
# Variables
# =====================
PYTHON_VERSION="3.12"
TERRAFORM_VERSION="1.5.0"
OH_MY_ZSH_PLUGINS=("zsh-autosuggestions" "terraform" "gcloud" "git" "docker" "kubectl" "zsh-syntax-highlighting")

# =====================
# Update and Upgrade System
# =====================
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# =====================
# Install Dependencies
# =====================
echo "Installing common dependencies..."
sudo apt install -y \
    build-essential \
    curl \
    wget \
    git \
    unzip \
    apt-transport-https \
    ca-certificates \
    gnupg \
    software-properties-common \
    lsb-release

# =====================
# Install Python
# =====================
echo "Installing Python $PYTHON_VERSION..."
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt update
sudo apt install -y python$PYTHON_VERSION python$PYTHON_VERSION-venv python$PYTHON_VERSION-distutils
sudo ln -sf /usr/bin/python$PYTHON_VERSION /usr/bin/python3
sudo ln -sf /usr/bin/pip$PYTHON_VERSION /usr/bin/pip3

# =====================
# Install Google Cloud SDK
# =====================
echo "Installing Google Cloud SDK..."
curl -sSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt update
sudo apt install -y google-cloud-cli

# =====================
# Install Terraform
# =====================
echo "Installing Terraform $TERRAFORM_VERSION..."
wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# =====================
# Install VS Code (for WSL)
# =====================
echo "Installing Visual Studio Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/microsoft.gpg > /dev/null
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt update
sudo apt install -y code

# =====================
# Install Zsh and Oh My Zsh
# =====================
echo "Installing Zsh..."
sudo apt install -y zsh

if [[ "$SHELL" != "$(which zsh)" ]]; then
  echo "Changing default shell to Zsh..."
  chsh -s $(which zsh)
fi

echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# =====================
# Install Oh My Zsh Plugins
# =====================
echo "Installing Oh My Zsh plugins..."

# Install zsh-autosuggestions
if [[ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
fi

# Install zsh-syntax-highlighting
if [[ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
fi

# Enable plugins in ~/.zshrc
for plugin in "${OH_MY_ZSH_PLUGINS[@]}"; do
  if ! grep -q "$plugin" ~/.zshrc; then
    sed -i "/^plugins=/ s/)/ $plugin)/" ~/.zshrc
  fi
done

# =====================
# Install Docker
# =====================
echo "Installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
rm get-docker.sh
echo "Docker installed. You must log out and back in to use Docker as a non-root user."

# =====================
# Install Helm
# =====================
echo "Installing Helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# =====================
# Final Message
# =====================
echo "Installation complete. Restart your terminal or log out and back in for changes to take effect."
