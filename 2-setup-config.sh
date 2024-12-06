#!/bin/bash

# Exit script on error
set -xe

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
    echo "export PATH=\$PATH:/snap/bin" >> "$ZSHRC_FILE"
fi

if ! grep -q "TF_PLUGIN_CACHE_DIR" "$ZSHRC_FILE"; then
    echo "export TF_PLUGIN_CACHE_DIR=\"$TF_PLUGIN_CACHE_DIR\"" >> "$ZSHRC_FILE"
fi

if ! grep -q "alias cdh='cd \$HOME'" ~/.zshrc; then
    echo "alias cdh='cd \$HOME'" >> ~/.zshrc
fi

# =====================
# Pre-Checks
# =====================
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

# Enable plugins in ~/.zshrc
for plugin in "${OH_MY_ZSH_PLUGINS[@]}"; do
  if ! grep -q "$plugin" ~/.zshrc; then
    sed -i "/^plugins=/ s/)/ $plugin)/" ~/.zshrc
  fi
done

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
echo "Enhanced configurations for Terraform, VS Code, Zsh, and Git have been set up."
echo "Configuration complete. To apply Zsh changes, run: source ~/.zshrc"
