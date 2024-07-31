#!/bin/bash

# Function to install yay
install_yay() {
    echo "Installing yay..."
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
}

pacman_packages=(
    7-zip acpi acpid acpid-dinit amd-ucode arc-gtk-theme arc-icon-theme
    artix-archlinux-support base base-devel bibata-cursor-theme blueman
    bluez-dinit bluez-utils brightnessctl btrfs-progs calf cmake cpio
    dhclient dhcp-dinit dhcpcd dinit dosfstools efibootmgr elogind-dinit
    exfat-utils fd firefox fish fzf git gnome-bluetooth-3.0 go grim grub
    gst-plugin-pipewire htop hyprland hyprlock hyprpaper hyprshot imv
    inotify-tools iwd iwd-dinit jq kitty kvantum lazygit less libpulse
    libreoffice-fresh linux linux-firmware linux-headers lsp-plugins
    lxappearance man-db mariadb mkinitcpio mpd mplayer mpv neofetch neovim
    net-tools netstat-nat noto-fonts-cjk noto-fonts-emoji npm ntfs-3g
    obs-studio opendoas pcsc-tools pipewire pipewire-alsa
    pipewire-docs pipewire-jack pipewire-pulse pipewire-pulse-dinit
    pulsemixer pwgen python python-dbus python-pip python-psutil qbittorrent
    reflector ripgrep rsync sddm sddm-dinit sddm-kcm slurp smartmontools
    speedtest-cli starship swayidle swaylock sysstat nemo tk tlp tlp-dinit
    tmux tree ttf-font-awesome ttf-jetbrains-mono udiskie unrar unzip
    virtualbox virtualbox-host-modules-arch vlc wget wireless_tools
    wireplumber wl-clipboard wlogout wlroots wpa_supplicant xcape xclip
    xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-wlr xorg-xev
    xorg-xinit xorg-xrandr xorg-xrdb xorg-xsetroot xorg-xwayland xssstate
    xwaylandvideobridge xxkb zenity zip
)

yay_packages=(
    bitwarden-cli dbeaver debtap dmenu-bluetooth
    docker docker-compose docker-dinit downgrade
    eww-git floorp-bin fuzzel-git g-ls gat google-chrome nerd-fonts-complete-mono-glyphs
    obsidian-icon-theme otf-daddytimemono-git pyenv pyprland python-dbus-next
    python-iwlib python-poetry
    rate-mirrors rustup sexpect spotify telegram-desktop ttf-daddytime-mono-nerd
    ttf-firacode-nerd ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols v2ray
    v2ray-dinit vesktop-bin watchman-bin
    xplorer-bin waybar pamixer
    catppuccin-gtk-theme-mocha papirus-folders-catppuccin-git
    xxh-appimage
)

sudo pacman -Syu --noconfirm

sudo pacman -S --needed --noconfirm ${pacman_packages[@]}

if ! command -v yay &> /dev/null; then
    install_yay
fi

yay -S --needed --noconfirm ${yay_packages[@]}

echo "All packages have been installed successfully!"

echo "Install xxh plugins"

mv ./.xxh ~/
xxh +I xxh-plugin-fish-userconfig
xxh +I xxh-plugin-fish-ohmyfish
