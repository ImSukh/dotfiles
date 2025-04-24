#!/bin/bash

# Script to checkout a branch based on environment config and run the install script

# Exit on error
set -e

# Check if environment config is provided
if [ -z "$DOTFILES_BRANCH" ]; then
  echo "Error: DOTFILES_BRANCH environment variable is not set."
  echo "Usage: DOTFILES_BRANCH=branch_name ./run-branch-install.sh"
  exit 1
fi

echo "Using branch: $DOTFILES_BRANCH"

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