#!/bin/bash

# Script to checkout a branch based on environment config and run the install script

# Exit on error
set -e

# Check if environment configs are provided
if [ -z "$DOTFILES_BRANCH" ]; then
  echo "Error: DOTFILES_BRANCH environment variable is not set."
  echo "Usage: DOTFILES_BRANCH=branch_name ./install.sh"
  exit 1
fi

echo "Using branch: $DOTFILES_BRANCH"

# First, fetch from remote to update branch information
echo "Fetching latest branch information..."
git fetch --unshallow
# Restore the run-branch-install.sh script to discard any local changes
git restore install.sh
git fetch origin "$DOTFILES_BRANCH":refs/remotes/origin/"$DOTFILES_BRANCH"

# List all available branches
echo "Available branches:"
git branch -r

git checkout -b "$DOTFILES_BRANCH" origin/"$DOTFILES_BRANCH"

# Check if the checkout was successful
if [ $? -ne 0 ]; then
  echo "Error: Failed to checkout branch $DOTFILES_BRANCH"
  exit 1
fi

echo "Successfully checked out branch: $DOTFILES_BRANCH"

if [ ! -f "./setup.sh" ]; then
  echo "Error: setup.sh script not found after checkout."
  exit 1
fi

# Make setup.sh executable if it isn't already
chmod +x ./setup.sh

echo "Running setup.sh script..."
# Execute the setup script from the branch
./setup.sh

echo "Installation complete!"