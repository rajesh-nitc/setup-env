#!/bin/bash

set -xe

CLOUDSDK_INSTALL_DIR=$HOME/.local

mkdir -p "$HOME/.terraform.d/plugin-cache"

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo "export PATH=$PATH:$CLOUDSDK_INSTALL_DIR/google-cloud-sdk/bin:$CLOUDSDK_INSTALL_DIR/bin" >> "$HOME/.zshrc"
echo "export TF_PLUGIN_CACHE_DIR=$HOME/.terraform.d/plugin-cache" >> "$HOME/.zshrc"

sed -i "s/robbyrussell/agnoster/" $HOME/.zshrc
sed -i "s/plugins=(git)/plugins=(git zsh-autosuggestions web-search gcloud)/" $HOME/.zshrc
echo 'HYPHEN_INSENSITIVE="true"' >> "$HOME/.zshrc"
echo 'DISABLE_AUTO_TITLE="true"' >> "$HOME/.zshrc"
echo "CLOUDSDK_HOME=$HOME/.local/google-cloud-sdk" >> "$HOME/.zshrc"