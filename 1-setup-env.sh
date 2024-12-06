#!/bin/bash

# Using it on Ubuntu 24.04.1 LTS

# Exit script on error
set -e

# =====================
# Variables
# =====================
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
# Install Dev tools
# =====================
sudo snap install docker --classic
sudo snap install google-cloud-sdk --classic
sudo snap install helm --classic
sudo snap install kubectl --classic
sudo snap install terraform --classic

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
# Final Message
# =====================
echo "Installation complete. Restart your terminal."
