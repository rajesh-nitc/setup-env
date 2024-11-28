#!/bin/bash

# Exit script on error
set -e

# =====================
# User-Defined Variables
# =====================
# Modify these variables before running the script
GCLOUD_REGION="us-central1"
GIT_USER_NAME="rajesh-nitc"
GIT_USER_EMAIL=""
TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
GCLOUD_CONFIG_DIR="$HOME/.config/gcloud"
DOCKER_CONFIG_DIR="$HOME/.docker"
ZSHRC_FILE="$HOME/.zshrc"
CODE_USER_SETTINGS="$HOME/.config/Code/User/settings.json"
SSH_KEY_PATH="$HOME/.ssh/id_rsa"

# =====================
# Pre-Checks
# =====================
# Check if gcloud CLI is installed
if ! command -v gcloud &> /dev/null; then
    echo "Error: gcloud CLI not found. Please install it first."
    exit 1
fi

# Check if Git is installed
if ! command -v git &> /dev/null; then
    echo "Error: Git not found. Please install it first."
    exit 1
fi

# Check if VS Code is installed
if ! command -v code &> /dev/null; then
    echo "Error: VS Code not found. Please install it first."
    exit 1
fi

# =====================
# Terraform Config
# =====================
echo "Setting up Terraform configuration..."
mkdir -p "$TF_PLUGIN_CACHE_DIR"

cat <<EOF > "$HOME/.terraformrc"
plugin_cache_dir = "$TF_PLUGIN_CACHE_DIR"
disable_checkpoint = true
EOF
echo "Terraform configuration updated with plugin cache and checkpoint disabling."

# =====================
# gcloud Config
# =====================
echo "Setting up Google Cloud SDK configuration..."
mkdir -p "$GCLOUD_CONFIG_DIR"

gcloud components update --quiet
gcloud config set compute/region "$GCLOUD_REGION"
gcloud config set core/disable_usage_reporting true
gcloud config set core/log_http true

# Configure Docker authentication for gcloud
gcloud auth configure-docker "${GCLOUD_REGION}-docker.pkg.dev" --quiet
echo "gcloud configured for Docker authentication with region: $GCLOUD_REGION."

# =====================
# Docker Config
# =====================
echo "Setting up Docker configuration..."
mkdir -p "$DOCKER_CONFIG_DIR"

cat <<EOF > "$DOCKER_CONFIG_DIR/config.json"
{
    "experimental": "enabled",
    "features": {
        "buildkit": true
    }
}
EOF
echo "Docker configuration set with experimental features and BuildKit enabled."

# =====================
# VS Code Config
# =====================
echo "Setting up Visual Studio Code configuration..."
mkdir -p "$(dirname "$CODE_USER_SETTINGS")"

cat <<EOF > "$CODE_USER_SETTINGS"
{
    "editor.tabSize": 4,
    "editor.insertSpaces": true,
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

# List of recommended extensions
EXTENSIONS=(
    "ms-python.python"                  # Python support
    "hashicorp.terraform"               # Terraform support
    "googlecloudtools.cloudcode"        # Google Cloud support
    "dbaeumer.vscode-eslint"            # ESLint support
    "redhat.vscode-yaml"                # YAML support
    "ms-azuretools.vscode-docker"       # Docker support
    "formulahendry.code-runner"         # Run code from VSCode
    "editorconfig.editorconfig"         # EditorConfig support
    "eamodio.gitlens"                   # GitLens - Git supercharged
    "esbenp.prettier-vscode"            # Prettier - Code formatter
)

# Install each extension
for EXTENSION in "${EXTENSIONS[@]}"; do
    code --install-extension "$EXTENSION"
done

echo "VS Code extensions installed."

# =====================
# Zsh Config
# =====================
echo "Updating Zsh configuration..."

if ! grep -q "TF_PLUGIN_CACHE_DIR" "$ZSHRC_FILE"; then
    echo "export TF_PLUGIN_CACHE_DIR=\"$TF_PLUGIN_CACHE_DIR\"" >> "$ZSHRC_FILE"
fi

if ! grep -q "gcloud CLI config" "$ZSHRC_FILE"; then
    echo "alias gcloud='gcloud --quiet'" >> "$ZSHRC_FILE"
fi

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
# Final Message
# =====================
echo "Enhanced configurations for Terraform, gcloud, Docker, VS Code, Zsh, and Git have been set up."
echo "Configuration complete. To apply Zsh changes, run: source ~/.zshrc"
