#!/bin/bash

echo "=== Dotfiles Bootstrap ==="

echo "-> Stowing packages..."
cd ~/dotfiles
for app in bash git hypr kitty waybar rofi wlogout swaync wallust swappy ags cava; do
    stow "$app"
    echo "Stowed $app"
done

echo "-> Checking Neovim configuration..."
if [ ! -d "$HOME/.config/nvim" ]; then
    echo "Cloning Neovim repository..."
    git clone git@github.com:yakultbottle/nvim-config.git ~/.config/nvim
else
    echo "ERROR: Neovim repo already exists"
    exit 1
fi

echo "=== Setup Complete! ==="
