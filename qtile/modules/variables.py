import os
import json
from dataclasses import dataclass
from os import path

import psutil
from libqtile import qtile


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

    os.system(f"echo {new_value} | sudo tee {backlight_path}")


def adjust_brightness(action):
    os.system(f"brightnessctl set {action}")
    current_brightness = int(os.popen("brightnessctl get").read().rstrip())
    max_brightness = int(os.popen("brightnessctl max").read().rstrip())
    brightness_percentage = (current_brightness / max_brightness) * 100
    os.system(f'notify-send "Brightness: {brightness_percentage:.0f}%"')


def adjust_volume(action):
    os.system(f"amixer -q set Master {action}")
    if action == "toggle":
        status = "Muted" if "off" in os.popen("amixer get Master").read() else "Unmuted"
        os.system(f'notify-send "Volume: {status}"')
    else:
        volume = os.popen("amixer get Master | grep -oP '\[.*?%'").read().split("[")[1]
        os.system(f'notify-send "Volume: {volume}"')


def get_screens_count():
    items = os.popen("way-displays -g | grep -E \"  'eDP-|  'DP-\"").read().split("\n")
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
        4: ["WebCord", "discord", "besktop"],
        5: ["firefox", ""],
        6: ["iwgtk", ""],
        7: [],
        8: ["keepassxc"],
        9: ["obsidian"],
        0: ["nekoray", "xwaylandvideobridge"],
    }
    monitors = len(qtile.core.outputs)


# @dataclass
# class Colors:
#     border_focus = '#83c092'
#     border_normal = '#11111b'
#
#     widget_foreground = '#D3C6AA'
#     bar_background = '#1d2021'
#
#     widget_background_groups = '#343743'
#     widget_inactive_groups = '#343743'


# @dataclass
# class Colors:
#     border_focus = "#b4befe"
#     border_normal = "#11111b"
#
#     widget_foreground = "#cdd6f4"
#     bar_background = "#11111b"
#
#     widget_background_groups = "#a6e3a1"
#     widget_inactive_groups = "#6c7086"
#     widget_active_groups = "#89b4fa"
#     this_current_screen_border = "#a6e3a1"


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
