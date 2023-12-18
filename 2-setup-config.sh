#!/bin/bash

set -xe

GCLOUD_REGION="us-east4"

# Terraform Plugin Cache
mkdir -p "$HOME/.terraform.d/plugin-cache"
echo "export TF_PLUGIN_CACHE_DIR=$HOME/.terraform.d/plugin-cache" >> "$HOME/.zshrc"

# Docker client to authenticate with GCP Artifact Registry
gcloud auth configure-docker $GCLOUD_REGION-docker.pkg.dev

# Git
mkdir -p $HOME/.ssh
ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa

# global
git config --global url."git@github.com:".insteadOf git://github.com/
git config --global user.name "rajesh"
git config --global user.email ""
# view config
# git config --list --global

# local repo
# git config user.name "rajesh"
# git config user.email ""
# view config
# git config --list --local

# Custom
# export GIT_SSH_COMMAND="ssh -i ~/.ssh/github"

# ohmyzsh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
sed -i "s/robbyrussell/robbyrussell/" $HOME/.zshrc
sed -i "s/plugins=(git)/plugins=(zsh-autosuggestions terraform gcloud git)/" $HOME/.zshrc
echo 'HYPHEN_INSENSITIVE="true"' >> "$HOME/.zshrc"

# Sync time between wsl container and host
echo "sudo ntpdate time.windows.com" >> "$HOME/.zshrc"

# To run the aabove command i.e. sudo ntpdate time.windows.com without password :
# visudo
# Add below command at the end of file
# ALL  ALL=NOPASSWD: /usr/sbin/ntpdate time.windows.com

# To resolve Azure dns issue on wsl:
# https://github.com/microsoft/WSL/issues/8022#issuecomment-1032554287

# OPTIONAL - To use vscode dark+ theme on Windows Terminal
# {
#             "background": "#1E1E1E",
#             "black": "#000000",
#             "blue": "#2472C8",
#             "brightBlack": "#666666",
#             "brightBlue": "#3B8EEA",
#             "brightCyan": "#29B8DB",
#             "brightGreen": "#23D18B",
#             "brightPurple": "#D670D6",
#             "brightRed": "#F14C4C",
#             "brightWhite": "#E5E5E5",
#             "brightYellow": "#F5F543",
#             "cursorColor": "#808080",
#             "cyan": "#11A8CD",
#             "foreground": "#CCCCCC",
#             "green": "#0DBC79",
#             "name": "Dark+",
#             "purple": "#BC3FBC",
#             "red": "#CD3131",
#             "selectionBackground": "#FFFFFF",
#             "white": "#E5E5E5",
#             "yellow": "#E5E510"
#         }
