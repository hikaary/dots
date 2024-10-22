#!/bin/bash

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root. Please use 'su -' or 'sudo -i' to switch to the root user, then run the script again."
  exit 1
fi

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to install doas
install_doas() {
  echo "Installing doas..."
  pacman -S --noconfirm opendoas
  echo "permit persist :wheel" >/etc/doas.conf
  chmod 0400 /etc/doas.conf
}

# Function to install Rust for the current user
install_rust() {
  echo "Installing Rust..."
  su - $SUDO_USER -c 'curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y'
  su - $SUDO_USER -c 'source $HOME/.cargo/env'
}

# Function to install aura
install_aura() {
  echo "Installing aura..."
  su - $SUDO_USER -c 'git clone https://github.com/fosskers/aura.git'
  su - $SUDO_USER -c 'cd aura/rust && cargo install --path aura-pm && cd ../..'
  su - $SUDO_USER -c 'rm -rf aura'
  mv /home/$SUDO_USER/.cargo/bin/aura /usr/bin/
  aura -Scc --noconfirm
}

# Install doas if not present
if ! command_exists doas; then
  install_doas
fi

# Install Rust if not present
if ! su - $SUDO_USER -c 'command -v rustc' >/dev/null 2>&1; then
  install_rust
fi

# Install aura if not present
if ! command_exists aura; then
  install_aura
fi

# Install packages
packages=$(grep -v '^#' packages | tr '\n' ' ')
aura -Syu --noconfirm
aura -A --noconfirm $packages

echo "All packages have been installed successfully!"

# Add user to groups
usermod -a -G video,audio,input,power,storage,optical,lp,scanner,dbus,adbusers,uucp $SUDO_USER

# Install emptty
su - $SUDO_USER -c 'git clone https://github.com/tvrzna/emptty'
cd /home/$SUDO_USER/emptty
make install-dinit
cd ..
rm -rf emptty

# Install lsr
git clone https://github.com/jmattaa/laser.git
cd laser
doas make install
cd ..
rm -rf laser

#Install theme
cp -r .themes/ ~/

# Enable emptty
dinitctl enable emptty

cargo install --locked gptcommit

# Remove IPv6
doas sysctl -w net.ipv7.conf.default.disable_ipv6=1
doas sysctl -w net.ipv6.conf.all.disable_ipv6=1

echo "Setup completed successfully!"
