#!/bin/bash

set -xe

# Terraform Plugin Cache
mkdir -p "$HOME/.terraform.d/plugin-cache"
echo "export TF_PLUGIN_CACHE_DIR=$HOME/.terraform.d/plugin-cache" >> "$HOME/.zshrc"

# Path
echo "export PATH=$HOME/.local/bin:$PATH" >> "$HOME/.zshrc"

# ohmyzsh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
sed -i "s/robbyrussell/af-magic/" $HOME/.zshrc
sed -i "s/plugins=(git)/plugins=(git zsh-autosuggestions terraform)/" $HOME/.zshrc
echo 'HYPHEN_INSENSITIVE="true"' >> "$HOME/.zshrc"
echo 'DISABLE_AUTO_TITLE="true"' >> "$HOME/.zshrc"

# MANUALLY PUT QUOTES IN PATH in ~/.zshrc 
# For e.g. "Program Files" AND "Microsoft VS Code"
