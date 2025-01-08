#!/bin/bash

# Exit script on error
set -e

# =====================
# User-Defined Variables
# =====================
OH_MY_ZSH_PLUGINS=("zsh-autosuggestions" "terraform" "gcloud" "git" "docker" "kubectl" "zsh-syntax-highlighting")
GIT_USER_NAME="rajesh-nitc"
GIT_USER_EMAIL="rajesh.nitc@gmail.com"
TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
ZSHRC_FILE="$HOME/.zshrc"
CODE_USER_SETTINGS="$HOME/.config/Code/User/settings.json"
SSH_KEY_PATH="$HOME/.ssh/id_rsa"

# =====================
# Zsh Config
# =====================
echo "Updating Zsh configuration..."

# Add Snap to PATH in Zsh if not already present
if ! grep -q "/snap/bin" "$ZSHRC_FILE"; then
    echo "export PATH=\$PATH:/snap/bin" >>"$ZSHRC_FILE"
fi

if ! grep -q "TF_PLUGIN_CACHE_DIR" "$ZSHRC_FILE"; then
    echo "export TF_PLUGIN_CACHE_DIR=\"$TF_PLUGIN_CACHE_DIR\"" >>"$ZSHRC_FILE"
fi

if ! grep -q "alias cdh='cd \$HOME/DEV'" ~/.zshrc; then
    echo "alias cdh='cd \$HOME/DEV'" >>~/.zshrc
fi

if ! grep -q "^cd \$HOME/DEV" ~/.zshrc; then
    echo "cd \$HOME/DEV" >>~/.zshrc
fi

# =====================
# Pre-Checks
# =====================
# Check if VS Code is installed
if ! command -v code &>/dev/null; then
    echo "Error: VS Code not found. Please install it first."
    exit 1
fi

# =====================
# Install Oh My Zsh Plugins
# =====================
echo "Installing Oh My Zsh plugins..."

# Install zsh-autosuggestions
if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
fi

# Install zsh-syntax-highlighting
if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
fi

# Replace plugins section in .zshrc with values from OH_MY_ZSH_PLUGINS
sed -i "/^plugins=/c\plugins=(${OH_MY_ZSH_PLUGINS[*]})" ~/.zshrc

# =====================
# Terraform Config
# =====================
echo "Setting up Terraform configuration..."
mkdir -p "$TF_PLUGIN_CACHE_DIR"

cat <<EOF >"$HOME/.terraformrc"
plugin_cache_dir = "$TF_PLUGIN_CACHE_DIR"
disable_checkpoint = true
EOF
echo "Terraform configuration updated with plugin cache and checkpoint disabling."

# =====================
# Git Config
# =====================
echo "Setting up Git configuration..."
git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"
git config --global core.editor "code --wait"
git config --global pull.rebase true
git config --global init.defaultBranch main

# SSH Key for GitHub
if [[ ! -f "$SSH_KEY_PATH" ]]; then
    echo "Generating SSH key for GitHub..."
    ssh-keygen -t rsa -b 4096 -C "$GIT_USER_EMAIL" -f "$SSH_KEY_PATH" -N ""
    eval "$(ssh-agent -s)"
    ssh-add "$SSH_KEY_PATH"
    echo "SSH key generated. Add the following public key to GitHub:"
    cat "$SSH_KEY_PATH.pub"
fi

# =====================
# Gcloud Config
# =====================
# Check if the 'work' configuration already exists
if gcloud config configurations list --format="value(name)" | grep -q "^work$"; then
    echo "Configuration 'work' already exists. No action needed."
else
    # Create the 'work' configuration if it doesn't exist
    echo "Creating 'work' configuration..."
    gcloud config configurations create work
fi

# Check if the 'default' configuration already exists
if gcloud config configurations list --format="value(name)" | grep -q "^default$"; then
    echo "Configuration 'deafult' already exists. No action needed."
    gcloud config configurations activate default
else
    # Create the 'default' configuration if it doesn't exist
    echo "Creating 'default' configuration..."
    gcloud config configurations create default
fi

# For default / personal
# gcloud init
# gcloud auth application-default login # For application
# gcloud auth login # For gcloud cli

# =====================
# VS Code Config
# =====================
echo "Setting up Visual Studio Code configuration..."
mkdir -p "$(dirname "$CODE_USER_SETTINGS")"

cat <<EOF >"$CODE_USER_SETTINGS"
{
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
        "source.fixAll.eslint": true
    },
    "files.autoSave": "onFocusChange",
    "terminal.integrated.defaultProfile.linux": "zsh",
    "workbench.iconTheme": "vscode-icons",
    "workbench.colorTheme": "Visual Studio Dark",
    "extensions.ignoreRecommendations": false,
    "git.confirmSync": false
}
EOF
echo "VS Code configuration updated with modern settings."

# =====================
# Install VS Code Extensions
# =====================
echo "Installing recommended VS Code extensions..."

# List of modern best practice extensions
EXTENSIONS=(
    "ms-python.python"                       # Python support
    "dbaeumer.vscode-eslint"                 # ESLint support
    "esbenp.prettier-vscode"                 # Prettier - Code formatter
    "editorconfig.editorconfig"              # EditorConfig support
    "hashicorp.terraform"                    # Terraform support
    "redhat.vscode-yaml"                     # YAML support
    "ms-azuretools.vscode-docker"            # Docker support
    "googlecloudtools.cloudcode"             # Google Cloud support
    "eamodio.gitlens"                        # GitLens - Git supercharged
    "mhutchie.git-graph"                     # Git Graph
    "timonwong.shellcheck"                   # ShellCheck for shell scripts
    "foxundermoon.shell-format"              # Shell script formatting
    "mikestead.dotenv"                       # .env file support
    "VisualStudioExptTeam.vscodeintellicode" # IntelliCode AI
    "aaron-bond.better-comments"             # Better Comments
    "bierner.markdown-preview-github-styles" # Markdown preview
    "shardulm94.trailing-spaces"             # Trailing spaces remover
    "google.geminicodeassist"                # Gemini Code Assist
    "ms-toolsai.jupyter"                     # Jupyter notebook
    "ms-toolsai.datawrangler"                # Data Wrangler
    "GitHub.copilot"                         # GitHub copilot
)

# Install each extension
for EXTENSION in "${EXTENSIONS[@]}"; do
    code --install-extension "$EXTENSION"
done

echo "VS Code extensions installed."

# =====================
# Final Message
# =====================
echo "Enhanced configurations for Terraform, VS Code, Zsh, and Git have been set up."
echo "Configuration complete. To apply Zsh changes, run: source ~/.zshrc"
