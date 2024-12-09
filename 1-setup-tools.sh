#!/bin/bash

# Using it on Ubuntu 24.04.1 LTS

# Exit script on error
set -xe

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
# Install Dev tools using Snap
# =====================
sudo snap install docker --classic
sudo snap install google-cloud-sdk --classic
sudo snap install helm --classic
sudo snap install kubectl --classic
sudo snap install terraform --classic

# =====================
# Install Python3.12, Zsh and Oh My Zsh using Apt
# =====================
echo "Installing Zsh..."
sudo apt install -y zsh python3.12 python3.12-venv

if [[ "$SHELL" != "$(which zsh)" ]]; then
  echo "Changing default shell to Zsh..."
  chsh -s "$(which zsh)"
fi

echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# =====================
# Final Message
# =====================
echo "Installation complete. Restart terminal."
