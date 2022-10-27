#!/bin/bash

set -xe

# Terraform Plugin Cache
mkdir -p "$HOME/.terraform.d/plugin-cache"
echo "export TF_PLUGIN_CACHE_DIR=$HOME/.terraform.d/plugin-cache" >> "$HOME/.zshrc"

# Path
echo "export PATH=$HOME/.local/bin:$PATH" >> "$HOME/.zshrc"

# ohmyzsh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
sed -i "s/robbyrussell/agnoster/" $HOME/.zshrc
sed -i "s/plugins=(git)/plugins=(git zsh-autosuggestions terraform)/" $HOME/.zshrc
echo 'HYPHEN_INSENSITIVE="true"' >> "$HOME/.zshrc"
echo 'DISABLE_AUTO_TITLE="true"' >> "$HOME/.zshrc"

# update path (for code. to work) in ~/.zshrc: For e.g. put quotes around "Program Files" AND "Microsoft VS Code"
# https://gist.github.com/stramel/658d702f3af8a86a6fe8b588720e0e23
# update font to DejaVu Sans Mono for Powerline in wsl terminal properties

# vscode dark+ theme on windows terminal
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

