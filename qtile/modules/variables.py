import os
import signal
import subprocess
from dataclasses import dataclass
from os import path

import psutil


def is_battery_present():
    battery = psutil.sensors_battery()
    return battery is not None


def get_monitors_count():
    return int(
        subprocess.check_output(
            'xrandr | grep -w connected | wc -l',
            shell=True,
        )
    )


def toggle_vpn(_=None):
    if Variables.VPN_PID is None:
        vpn = subprocess.Popen(
            [
                # 'doas',
                # '/bin/sing-box',
                # 'run',
                # '-c',
                # '~/Yandex.Disk/sing-box/config.json',
                # '~/.config/qtile/scripts/vpn.sh'
                Variables.qconf + 'scripts/vpn.sh'
            ],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
        )
        Variables.VPN_PID = vpn.pid
        subprocess.run(['dunstify', 'vpn', 'enable'])
    else:
        os.kill(Variables.VPN_PID, signal.SIGTERM)
        Variables.VPN_PID = None
        subprocess.run(['dunstify', 'vpn', 'disable'])


@dataclass
class Variables:
    home = path.expanduser('~')
    qconf = home + '/.config/qtile/'

    lock_image = qconf + 'icons/lock.svg'
    sleep_image = qconf + 'icons/sleep.svg'
    shutdown_image = qconf + 'icons/shutdown.svg'
    battery = is_battery_present()
    mod = 'mod4'

    terminal = 'alacritty'
    float_terminal = terminal + ' --class float_terminal'
    rr = qconf + 'scripts/recordrofi'
    volmute = qconf + 'scripts/vol.sh mute'
    volup = qconf + 'scripts/vol.sh up'
    voldown = qconf + 'scripts/vol.sh down'
    lock = 'slock'
    sleep = 'slock && systemctl suspend'
    translator = 'dmenu-translate'
    rofi = home + '/.config/rofi/launchers/type-7/launcher.sh'
    bluetooth = qconf + 'scripts/bluetooth.sh'
    brightness = qconf + 'scripts/brightness.sh'
    sstool = 'flameshot gui'

    autostart_sh = qconf + 'scripts/autostart.sh'
    app_groups = {
        1: ['firefox'],
        2: [''],
        3: ['planify'],
        4: ['webcord'],
        5: ['firefox', ''],
        6: ['nekoray', 'iwgtk', ''],
        7: [],
        8: ['KeePassXC'],
        9: ['obsidian'],
        0: [''],
    }
    monitors = get_monitors_count()

    toggle_vpn = toggle_vpn

    VPN_PID: int | None = None


@dataclass
class Colors:
    border_focus = '#89b4fa'
    border_normal = '#11111b'

    widget_foreground = '#cdd6f4'
    bar_background = '#1d2021'

    widget_background_groups = '#343743'
    widget_inactive_groups = '#7f849c'
    widget_active_groups = '#7f849c'
