#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Error handling
set -e
trap 'echo -e "${RED}Error: Script failed on line $LINENO${NC}"; exit 1' ERR

# Logging function
log() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
  log_error "This script must be run as root"
  log_warning "Please use 'su -' or 'sudo -i' to switch to the root user, then run the script again"
  exit 1
fi

# Check if systemd is running
if ! pidof systemd >/dev/null; then
  log_error "This script requires systemd to be running"
  exit 1
fi

# Check if running on Arch Linux
if [ ! -f /etc/arch-release ]; then
  log_error "This script is designed for Arch Linux"
  exit 1
fi

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to check if a package is installed
is_package_installed() {
  pacman -Qi "$1" >/dev/null 2>&1
}

# Function to install Rust for the current user
install_rust() {
  log "Installing Rust..."
  if ! su - $SUDO_USER -c 'command -v rustc' >/dev/null 2>&1; then
    su - $SUDO_USER -c 'curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y'
    su - $SUDO_USER -c 'source $HOME/.cargo/env'
    log_success "Rust installed successfully"
  else
    log_warning "Rust is already installed"
  fi
}

# Function to install aura
install_aura() {
  log "Installing aura..."
  if ! command_exists aura; then
    if ! command_exists git; then
      log "Installing git..."
      pacman -S --noconfirm git || {
        log_error "Failed to install git"
        exit 1
      }
    fi

    su - $SUDO_USER -c 'git clone https://github.com/fosskers/aura.git' || {
      log_error "Failed to clone aura repository"
      exit 1
    }

    su - $SUDO_USER -c 'cd aura/rust && cargo install --path aura-pm && cd ../..' || {
      log_error "Failed to build aura"
      exit 1
    }

    su - $SUDO_USER -c 'rm -rf aura'
    mv /home/$SUDO_USER/.cargo/bin/aura /usr/bin/ || {
      log_error "Failed to move aura binary to /usr/bin/"
      exit 1
    }

    aura -Scc --noconfirm
    log_success "Aura installed successfully"
  else
    log_warning "Aura is already installed"
  fi
}

# Function to install paru if not present
install_paru() {
  log "Checking paru installation..."
  if ! command_exists paru; then
    log "Installing paru..."
    if ! command_exists git; then
      pacman -S --noconfirm git || {
        log_error "Failed to install git"
        exit 1
      }
    fi

    su - $SUDO_USER -c 'git clone https://aur.archlinux.org/paru.git' || {
      log_error "Failed to clone paru repository"
      exit 1
    }

    su - $SUDO_USER -c 'cd paru && makepkg -si --noconfirm' || {
      log_error "Failed to build and install paru"
      exit 1
    }

    su - $SUDO_USER -c 'rm -rf paru'
    log_success "Paru installed successfully"
  else
    log_warning "Paru is already installed"
  fi
}

# Install base dependencies
log "Installing base dependencies..."
pacman -Syu --noconfirm base-devel || {
  log_error "Failed to install base dependencies"
  exit 1
}

# Install Rust if needed
install_rust

# Install aura if needed
install_aura

# Install paru if needed
install_paru

# Install packages from the packages file
if [ -f "packages" ]; then
  log "Installing packages from packages file..."
  packages=$(grep -v '^#' packages | tr '\n' ' ')
  if [ -n "$packages" ]; then
    paru -S --noconfirm $packages || {
      log_error "Failed to install packages"
      exit 1
    }
    log_success "All packages installed successfully"
  else
    log_warning "No packages found in packages file"
  fi
else
  log_warning "packages file not found"
fi

# Install other apps
sudo npm install -g repomix

# Install tmux plugin manager
log "Installing tmux plugin manager..."
if [ ! -d "/home/$SUDO_USER/.tmux/plugins/tpm" ]; then
  su - $SUDO_USER -c 'git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm' || {
    log_error "Failed to install tmux plugin manager"
    exit 1
  }
  log_success "Tmux plugin manager installed successfully"
else
  log_warning "Tmux plugin manager is already installed"
fi

# Add user to groups
log "Adding user to groups..."
usermod -a -G video,audio,input,power,storage,optical,lp,scanner,dbus,adbusers,uucp $SUDO_USER || {
  log_error "Failed to add user to groups"
  exit 1
}

# Configure cursor theme
log "Configuring cursor theme..."
mkdir -p /home/$SUDO_USER/.icons/default
cat >/home/$SUDO_USER/.icons/default/index.theme <<EOF
[Icon Theme]
Inherits=Bibata-Modern-Ice
EOF

cat >/usr/share/icons/default/index.theme <<EOF
[Icon Theme]
Inherits=Bibata-Modern-Ice
EOF

chown -R $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.icons

# Disable IPv6
log "Disabling IPv6..."
cat >/etc/sysctl.d/40-ipv6.conf <<EOF
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
EOF

# Setup IWD
touch /etc/iwd/main.conf
cat >/etc/iwd/main.conf <<EOF
[General]
EnableNetworkConfiguration=True

[Network]
RoutePriorityOffset=300
EOF
systemctl enable systemd-resolved.service

sysctl --system || {
  log_error "Failed to apply sysctl settings"
  exit 1
}

# Apply X resources if file exists
if [ -f "/home/$SUDO_USER/.Xresources" ]; then
  log "Applying X resources..."
  su - $SUDO_USER -c 'xrdb -merge ~/.Xresources' || {
    log_warning "Failed to merge .Xresources"
  }
fi

log_success "Setup completed successfully!"

# Final system update
log "Performing final system update..."
paru -Syu --noconfirm || {
  log_warning "Final system update failed, but setup is complete"
}

echo -e "\n${GREEN}=== Setup Summary ===${NC}"
echo -e "${BLUE}• System updated${NC}"
echo -e "${BLUE}• Required tools installed${NC}"
echo -e "${BLUE}• User groups configured${NC}"
echo -e "${BLUE}• Cursor theme set${NC}"
echo -e "${BLUE}• IPv6 disabled${NC}"
echo -e "${BLUE}• X resources applied${NC}"
