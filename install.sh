#!/bin/bash

DOTFILES_FOLDER=`pwd`

clear
echo "Trying to do some things here and here..."
echo "Using $DOTFILES_FOLDER"

## VSCode config files
VSCODE_CONFIG_PATH="$HOME/Library/Application Support/Code/User"
echo "Symlinking config to the $VSCODE_CONFIG_PATH"
ln -sf "$DOTFILES_FOLDER/vscode/settings.json" "$VSCODE_CONFIG_PATH/settings.json"
