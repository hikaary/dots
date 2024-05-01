import os
import json
from dataclasses import dataclass
from os import path

import psutil
from libqtile import qtile


import subprocess


def is_battery_present():
    battery = psutil.sensors_battery()
    return battery is not None


def adjust_keyboard_backlight(action):
    backlight_path = "/sys/class/leds/platform::kbd_backlight/brightness"
    max_brightness_path = "/sys/class/leds/platform::kbd_backlight/max_brightness"

    with open(max_brightness_path, "r") as f:
        max_brightness = int(f.read().strip())

    with open(backlight_path, "r") as f:
        current = int(f.read().strip())

    if action == "down":
        new_value = max(0, current - 1)
    elif action == "up":
        new_value = min(max_brightness, current + 1)
    else:
        new_value = max_brightness if current == 0 else 0

    subprocess.run(
        ["sudo", "tee", backlight_path], input=str(new_value).encode(), check=True
    )


def adjust_brightness(action):
    subprocess.run(["brightnessctl", "set", action], check=True)
    current_brightness = subprocess.run(
        ["brightnessctl", "get"], capture_output=True, text=True
    ).stdout.strip()
    max_brightness = subprocess.run(
        ["brightnessctl", "max"], capture_output=True, text=True
    ).stdout.strip()
    brightness_percentage = (int(current_brightness) / int(max_brightness)) * 100
    subprocess.run(["notify-send", f"Brightness: {brightness_percentage:.0f}%"])


def adjust_volume(action):
    subprocess.run(f"amixer -q set Master {action}", shell=True)
    if action == "toggle":
        result = subprocess.run(
            "amixer get Master", capture_output=True, text=True, shell=True
        )
        status = "Muted" if "off" in result.stdout else "Unmuted"
        subprocess.run(["notify-send", f"Volume: {status}"])
    else:
        result = subprocess.run(
            "amixer get Master | grep -oP '\\[.*?%'",
            capture_output=True,
            text=True,
            shell=True,
        )
        volume = result.stdout.split("[")[1]
        subprocess.run(["notify-send", f"Volume: {volume}"])


def get_screens_count():
    result = subprocess.run(
        "way-displays -g | grep -E \"  'eDP-|  'DP-\"",
        capture_output=True,
        text=True,
        shell=True,
    )
    items = result.stdout.split("\n")
    return len(items) - 1


@dataclass
class Variables:
    home = path.expanduser("~")
    qconf = home + "/.config/qtile/"

    lock_image = qconf + "icons/lock.svg"
    sleep_image = qconf + "icons/sleep.svg"
    shutdown_image = qconf + "icons/shutdown.svg"
    battery = is_battery_present()
    mod = "mod4"
    primary_monitor_with = 2560
    adjust_brightness = adjust_brightness
    adjust_volume = adjust_volume
    adjust_keyboard_backlight = adjust_keyboard_backlight

    terminal = "env -u WAYLAND_DISPLAY alacritty"
    float_terminal = terminal + " --class float_terminal"
    lock_sh = qconf + "scripts/lock.sh"
    brightness_sh = qconf + "scripts/brightness.sh"
    sleep = "slock && systemctl suspend"
    wifi_manager = "networkmanager_dmenu"
    bluetooth = qconf + "scripts/bluetooth.sh"
    sstool = qconf + "scripts/sstool"

    autostart_sh = qconf + "scripts/autostart.sh"
    app_groups = {
        1: ["firefox"],
        2: [""],
        3: ["planify", "Beeper"],
        4: ["WebCord", "discord", "vesktop", "Vesktop"],
        5: ["firefox", ""],
        6: ["iwgtk", ""],
        7: ["EasyEffects"],
        8: ["keepassxc"],
        9: ["obsidian"],
        0: ["easyeffects", "xwaylandvideobridge"],
    }
    monitors = len(qtile.core.outputs)


class PywalColors:
    def __init__(self):
        wal_colors_path = os.path.expanduser("~/.cache/wal/colors.json")
        with open(wal_colors_path) as f:
            wal_colors = json.load(f)

        self.focus = wal_colors["special"]["foreground"]  # Акцентный цвет
        self.unfocus = wal_colors["special"]["background"]  # Фоновый цвет
        self.active = wal_colors["colors"]["color4"]  # Активный элемент
        self.inactive = wal_colors["colors"]["color2"]  # Неактивный элемент
        self.highlight = wal_colors["colors"]["color1"]  # Выделение


class Catppuccin:
    Rosewater = "#f5e0dc"
    Flamingo = "#f2cdcd"
    Pink = "#f5c2e7"
    Mauve = "#cba6f7"
    Red = "#f38ba8"
    Maroon = "#eba0ac"
    Peach = "#fab387"
    Yellow = "#f9e2af"
    Green = "#a6e3a1"
    Teal = "#94e2d5"
    Sky = "#89dceb"
    Sapphire = "#74c7ec"
    Blue = "#89b4fa"
    Lavender = "#b4befe"
    Text = "#cdd6f4"
    Subtext1 = "#bac2de"
    Subtext0 = "#a6adc8"
    Overlay2 = "#9399b2"
    Overlay1 = "#7f849c"
    Overlay0 = "#6c7086"
    Surface2 = "#585b70"
    Surface1 = "#45475a"
    Surface0 = "#313244"
    Base = "#1e1e2e"
    Mantle = "#181825"
    Crust = "#11111b"

    def __init__(self):
        self.active = self.Text
        self.inactive = self.Surface0
        self.focus = self.Sky
        self.highlight = self.Lavender
        self.unfocus = self.Teal
        self.base = self.Base


Colors = Catppuccin()
