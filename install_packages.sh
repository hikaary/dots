#!/bin/bash

# Function to install aura
install_aura() {
    echo "Installing aura..."
    git clone https://aur.archlinux.org/aura-bin.git
    cd aura-bin
    makepkg -s
    # TODO complete install
    cd ..
    rm -rf aura-bin
    aura -Scc --noconfirm
}

# Check if aura is installed, if not, install it
if ! command -v aura &> /dev/null; then
    install_aura
fi

# Read packages from the file
packages=$(cat packages | grep -v '^#' | tr '\n' ' ')

# Update system first
aura -Syu --noconfirm

# Install packages
aura -A --noconfirm $packages

echo "All packages have been installed successfully!"

echo "Installing xxh plugins"

curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish

mv ./.xxh ~/
xxh +I xxh-plugin-fish-userconfig
xxh +I xxh-plugin-fish-ohmyfish
