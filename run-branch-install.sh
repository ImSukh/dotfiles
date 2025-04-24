#!/bin/bash

# Script to checkout a branch based on environment config and run the install script

# Exit on error
set -e

# Check if environment configs are provided
if [ -z "$DOTFILES_BRANCH" ]; then
  echo "Error: DOTFILES_BRANCH environment variable is not set."
  echo "Usage: DOTFILES_BRANCH=branch_name ./run-branch-install.sh"
  exit 1
fi

if [ -z "$DOTFILES_REPO" ]; then
  echo "Error: DOTFILES_REPO environment variable is not set."
  exit 1
fi

# Check if remote repository is configured
echo "Checking remote repository configuration..."
git remote get-url origin
git remote set-url origin "$DOTFILES_REPO"


echo "Using GitHub repository: $DOTFILES_REPO"
echo "Using branch: $DOTFILES_BRANCH"

# First, fetch from remote to update branch information
echo "Fetching latest branch information..."
git fetch --unshallow
git pull

# List all available branches
echo "Available branches:"
git branch -r

git checkout "$DOTFILES_BRANCH"

# Check if the checkout was successful
if [ $? -ne 0 ]; then
  echo "Error: Failed to checkout branch $DOTFILES_BRANCH"
  exit 1
fi

echo "Successfully checked out branch: $DOTFILES_BRANCH"

if [ ! -f "./install.sh" ]; then
  echo "Error: install.sh script not found after checkout."
  exit 1
fi

# Make install.sh executable if it isn't already
chmod +x ./install.sh

echo "Running install.sh script..."
# Execute the install script from the branch
./install.sh

echo "Installation complete!"