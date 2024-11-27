#!/bin/bash

# Colors for pretty output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Print colored status messages
print_status() {
  echo -e "${BLUE}[*]${NC} $1"
}

print_success() {
  echo -e "${GREEN}[+]${NC} $1"
}

print_error() {
  echo -e "${RED}[!]${NC} $1"
}

# Get the real user who executed the script
REAL_USER=$(logname)
REAL_USER_ID=$(id -u "$REAL_USER")
REAL_USER_GROUP=$(id -gn "$REAL_USER")

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  print_error "Please run this script as root"
  exit 1
fi

# Function to run commands as the real user
run_as_user() {
  sudo -u "$REAL_USER" XDG_RUNTIME_DIR="/run/user/$REAL_USER_ID" "$@"
}

# Function to check if a package is installed
is_installed() {
  pacman -Qi "$1" &>/dev/null
  return $?
}

# Function to install a package if it's not already installed
install_if_needed() {
  if ! is_installed "$1"; then
    print_status "Installing $1..."
    pacman -S --noconfirm "$1" || {
      print_error "Failed to install $1"
      exit 1
    }
    print_success "$1 installed successfully"
  else
    print_status "$1 is already installed"
  fi
}

# Clean up existing PipeWire installation
cleanup_pipewire() {
  print_status "Cleaning up existing PipeWire installation..."

  # Stop all related services as real user
  run_as_user systemctl --user stop pipewire.socket pipewire.service pipewire-pulse.socket pipewire-pulse.service wireplumber.service 2>/dev/null

  # Kill any remaining processes
  run_as_user killall -9 pipewire wireplumber 2>/dev/null

  # Clean up runtime directories
  rm -rf "/run/user/$REAL_USER_ID/pipewire"
  rm -rf "/run/user/$REAL_USER_ID/wireplumber"

  # Clean up cache directories
  rm -rf "/home/$REAL_USER/.cache/pipewire"
  rm -rf "/home/$REAL_USER/.cache/wireplumber"

  # Clean up state directories
  rm -rf "/home/$REAL_USER/.local/state/pipewire"
  rm -rf "/home/$REAL_USER/.local/state/wireplumber"

  print_success "Cleanup completed"
}

# Main installation function
main() {
  print_status "Starting PipeWire installation script..."

  # Stop and cleanup existing audio services
  print_status "Stopping existing audio services..."
  run_as_user systemctl --user stop pulseaudio.socket pulseaudio.service 2>/dev/null
  run_as_user systemctl --user mask pulseaudio.socket pulseaudio.service 2>/dev/null

  # Clean up existing PipeWire installation
  cleanup_pipewire

  # Required packages
  PACKAGES=(
    "pipewire"
    "lib32-pipewire"
    "pipewire-audio"
    "pipewire-alsa"
    "pipewire-pulse"
    "pipewire-jack"
    "lib32-pipewire-jack"
    "wireplumber"
    "bluez"
    "bluez-utils"
    "pipewire-zeroconf"
    "alsa-card-profiles"
    "alsa-ucm-conf"
    "sof-firmware"
  )

  # Install all required packages
  for pkg in "${PACKAGES[@]}"; do
    install_if_needed "$pkg"
  done

  # Enable and start Bluetooth service
  print_status "Enabling and starting Bluetooth service..."
  systemctl enable --now bluetooth.service

  # Create necessary directories
  print_status "Creating configuration directories..."
  mkdir -p /etc/wireplumber/wireplumber.conf.d/
  mkdir -p /etc/pipewire/pipewire.conf.d/
  mkdir -p "/home/$REAL_USER/.config/pipewire"
  mkdir -p "/home/$REAL_USER/.config/wireplumber"

  # Ensure correct permissions for runtime directory
  print_status "Setting up runtime directory..."
  mkdir -p "/run/user/$REAL_USER_ID/pipewire"
  chown "$REAL_USER:$REAL_USER_GROUP" "/run/user/$REAL_USER_ID/pipewire"
  chmod 700 "/run/user/$REAL_USER_ID/pipewire"

  # Configure Bluetooth settings for WirePlumber
  print_status "Configuring Bluetooth settings..."
  cat >/etc/wireplumber/wireplumber.conf.d/51-bluez-config.conf <<'EOF'
monitor.bluez.properties = {
    bluez5.enable-sbc-xq = true
    bluez5.enable-msbc = true
    bluez5.enable-hw-volume = true
    bluez5.headset-roles = [ hsp_hs hsp_ag hfp_hf hfp_ag ]
    bluez5.codecs = [ sbc sbc_xq aac ldac aptx aptx_hd ]
}
EOF

  # Configure ALSA settings
  print_status "Configuring ALSA settings..."
  cat >/etc/wireplumber/wireplumber.conf.d/50-alsa-config.conf <<'EOF'
monitor.alsa = {
  properties = {
    # Отключаем ACP из-за проблем с совместимостью
    alsa.use-acp = false
    
    # Включаем поддержку UCM
    alsa.use-ucm = true
    
    # Поддержка аудио портов
    alsa.support-audio-ports = true
    
    # Настройки для улучшения производительности
    alsa.nice = -11
    alsa.rtprio = 88
    alsa.default.format = "S32_LE"
    alsa.default.rate = 48000
    alsa.default.channels = 2
  }
  
  rules = [
    {
      matches = [
        {
          # Все входные устройства
          node.name = "~alsa_input.*"
        }
      ]
      actions = {
        update-props = {
          node.pause-on-idle = false
          session.suspend-timeout-seconds = 0
        }
      }
    }
    {
      matches = [
        {
          # Все выходные устройства
          node.name = "~alsa_output.*"
        }
      ]
      actions = {
        update-props = {
          node.pause-on-idle = false
          session.suspend-timeout-seconds = 0
        }
      }
    }
  ]
}
EOF

  # Отключаем проблемный модуль v4l2
  print_status "Configuring v4l2 settings..."
  cat >/etc/wireplumber/wireplumber.conf.d/51-disable-v4l2.conf <<'EOF'
wireplumber.profiles = {
  main = {
    monitor.v4l2 = disabled
  }
}
EOF

  # Enable auto-switch profile
  cat >/etc/wireplumber/wireplumber.conf.d/11-bluetooth-policy.conf <<'EOF'
wireplumber.settings = {
    bluetooth.autoswitch-to-headset-profile = true
}
EOF

  # Fix permissions for config files
  chown -R "$REAL_USER:$REAL_USER_GROUP" "/home/$REAL_USER/.config/pipewire"
  chown -R "$REAL_USER:$REAL_USER_GROUP" "/home/$REAL_USER/.config/wireplumber"

  print_status "Starting PipeWire services..."

  # Reload systemd daemon as user
  run_as_user systemctl --user daemon-reload
  sleep 2

  # Enable and start services as user with proper delays
  run_as_user systemctl --user enable --now pipewire.socket
  sleep 2
  run_as_user systemctl --user enable --now pipewire.service
  sleep 2
  run_as_user systemctl --user enable --now pipewire-pulse.socket
  sleep 2
  run_as_user systemctl --user enable --now pipewire-pulse.service
  sleep 2
  run_as_user systemctl --user enable --now wireplumber.service

  # Wait for services to start
  sleep 5

  # Final status check
  if run_as_user systemctl --user is-active --quiet pipewire.service &&
    run_as_user systemctl --user is-active --quiet pipewire-pulse.service &&
    run_as_user systemctl --user is-active --quiet wireplumber.service; then
    print_success "PipeWire installation completed successfully!"
    print_success "You may need to reboot your system for all changes to take effect."
    print_success "After reboot, check audio devices with: pactl info and wpctl status"
  else
    print_error "Some services failed to start. Checking status..."
    echo "PipeWire status:"
    run_as_user systemctl --user status pipewire
    echo "PipeWire-Pulse status:"
    run_as_user systemctl --user status pipewire-pulse
    echo "WirePlumber status:"
    run_as_user systemctl --user status wireplumber
  fi
}

# Run the main function
main
