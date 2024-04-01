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

    # Используем subprocess.run вместо os.popen
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

    terminal = "kitty"
    float_terminal = terminal + " --class float_terminal"
    lock_sh = qconf + "scripts/lock.sh"
    brightness_sh = qconf + "scripts/brightness.sh"
    sleep = "slock && systemctl suspend"
    rofi = home + "/.config/rofi/launchers/type-7/launcher.sh"
    bluetooth = qconf + "scripts/bluetooth.sh"
    sstool = qconf + "scripts/sstool"

    autostart_sh = qconf + "scripts/autostart.sh"
    app_groups = {
        1: ["firefox"],
        2: [""],
        3: ["planify", "firefox"],
        4: ["WebCord", "discord", "vesktop"],
        5: ["firefox", ""],
        6: ["iwgtk", ""],
        7: [],
        8: ["keepassxc"],
        9: ["obsidian"],
        0: ["nekoray", "xwaylandvideobridge"],
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


Colors = PywalColors()
