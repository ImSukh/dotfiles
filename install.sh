#!/bin/bash

# Install script for dotfiles
# This script will:
# 1. Install oh-my-zsh if not already installed
# 2. Symlink dotfiles to home directory
# 3. Install plugins and themes

set -e

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Installing dotfiles from $DOTFILES_DIR"

# Install oh-my-zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "oh-my-zsh is already installed"
fi
# Remove existing files if they exist
rm -f "$HOME/.aliases"
rm -f "$HOME/.zshrc"
rm -f "$HOME/.config/starship.toml"
rm -rf "$PLUGINS_DIR"

# Create symlinks
echo "Creating symlinks..."
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"

# Install custom plugins
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

# Install zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# Install zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  echo "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# Install powerlevel10k theme
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  echo "Installing powerlevel10k theme..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi
echo "Figuring out which code we are running"
# Get the latest VSCode version and commit hash
echo "Getting latest VSCode version..."
LATEST_TAG=$(curl -s https://api.github.com/repos/microsoft/vscode/tags | grep -o '"name": ".*"' | head -1 | sed 's/"name": "\(.*\)"/\1/')
if [ -z "$LATEST_TAG" ]; then
  echo "Failed to get latest VSCode tag from GitHub"
else
  echo "Latest VSCode tag: $LATEST_TAG"

  # Get the commit hash for this tag
  GIT_COMMIT=$(curl -s "https://api.github.com/repos/microsoft/vscode/git/refs/tags/$LATEST_TAG" | grep -o '"sha": ".*"' | head -1 | sed 's/"sha": "\(.*\)"/\1/')
  if [ -z "$GIT_COMMIT" ]; then
    echo "Failed to get commit hash for tag $LATEST_TAG"
  else
    echo "Commit hash: $GIT_COMMIT"

    # Construct the code path for Linux ARM64
    VSCODE_PATH="/vscode/vscode-server/bin/linux-arm64/$GIT_COMMIT/bin/remote-cli/code"
    echo "VSCode path for Linux ARM64: $VSCODE_PATH"

    # You can export this path or use it as needed
    export VSCODE_PATH
  fi
fi
# Instead of changing the default shell, set up Bash to automatically start zsh
echo "Setting up Bash to automatically start zsh..."

# Find zsh path
ZSH_PATH=$(which zsh)
if [ -z "$ZSH_PATH" ]; then
  echo "Warning: zsh not found in PATH. Please install zsh."
  exit 1
fi

# Create a .bashrc file that starts zsh, or append to it if it exists
BASHRC="$HOME/.bashrc"
BASH_PROFILE="$HOME/.bash_profile"

# Function to add zsh startup to a file
add_zsh_startup() {
  local file="$1"
  local content="
# Automatically switch to zsh (added by dotfiles installer)
if [ -x \"$ZSH_PATH\" ]; then
  export SHELL=\"$ZSH_PATH\"
  exec \"$ZSH_PATH\" -l
fi"

  # Check if the content already exists in the file
  if [ -f "$file" ] && grep -q "Automatically switch to zsh" "$file"; then
    echo "Zsh startup already configured in $file"
  else
    echo "Adding zsh startup to $file"
    echo "$content" >> "$file"
  fi
}

# Add to both .bashrc and .bash_profile to ensure it works in all environments
add_zsh_startup "$BASHRC"
add_zsh_startup "$BASH_PROFILE"

echo "Dotfiles installation complete!"
echo "Please restart your terminal or run 'source ~/.zshrc' to apply changes."