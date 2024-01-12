from dataclasses import dataclass
from os import path

import psutil
from libqtile import qtile


def is_battery_present():
    battery = psutil.sensors_battery()
    return battery is not None


@dataclass
class Variables:
    home = path.expanduser('~')
    qconf = home + '/.config/qtile/'

    lock_image = qconf + 'icons/lock.svg'
    sleep_image = qconf + 'icons/sleep.svg'
    shutdown_image = qconf + 'icons/shutdown.svg'
    battery = is_battery_present()
    mod = 'mod4'
    primary_monitor_with = 2560

    terminal = 'alacritty'
    float_terminal = terminal + ' --class float_terminal'
    lock_sh = qconf + 'scripts/lock.sh'
    sleep = 'slock && systemctl suspend'
    rofi = home + '/.config/rofi/launchers/type-7/launcher.sh'
    bluetooth = qconf + 'scripts/bluetooth.sh'
    sstool = qconf + 'scripts/sstool'

    autostart_sh = qconf + 'scripts/autostart.sh'
    load_settings_sh = qconf + 'scripts/load_settings.sh'
    app_groups = {
        1: ['brave'],
        2: [''],
        3: ['planify'],
        4: ['WebCord'],
        5: ['firefox', ''],
        6: ['nekoray', 'iwgtk', ''],
        7: [],
        8: ['keepassxc'],
        9: ['obsidian'],
        0: [''],
    }
    monitors = len(qtile.core.outputs)


@dataclass
class Colors:
    border_focus = '#83c092'
    border_normal = '#11111b'

    widget_foreground = '#D3C6AA'
    bar_background = '#1d2021'

    widget_background_groups = '#343743'
    widget_inactive_groups = '#343743'
