#!/bin/bash

set -xe

# zsh
sudo apt install -y zsh

# ohmyzsh
sudo sed -i s/required/sufficient/g /etc/pam.d/chsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Terraform Plugin Cache
mkdir -p "$HOME/.terraform.d/plugin-cache"
echo "export TF_PLUGIN_CACHE_DIR=$HOME/.terraform.d/plugin-cache" >> "$HOME/.zshrc"

# Path
echo "export PATH=$HOME/.local/bin:$PATH" >> "$HOME/.zshrc"

# ohmyzsh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
sed -i "s/robbyrussell/bira/" $HOME/.zshrc
sed -i "s/plugins=(git)/plugins=(git zsh-autosuggestions terraform)/" $HOME/.zshrc
echo 'HYPHEN_INSENSITIVE="true"' >> "$HOME/.zshrc"
echo 'DISABLE_AUTO_TITLE="true"' >> "$HOME/.zshrc"
