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
    status = subprocess.call(['systemctl', 'is-active', '--quiet', 'sing-box'])
    action = 'start' if status else 'stop'
    subprocess.Popen(
        [
            Variables.qconf + 'scripts/vpn.sh',
            action,
        ]
    )


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
    add_planify_task = 'io.github.alainm23.planify.quick-add'

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


@dataclass
class Colors:
    border_focus = '#89b4fa'
    border_normal = '#11111b'

    widget_foreground = '#cdd6f4'
    bar_background = '#090d10'

    widget_background_groups = '#343743'
    widget_inactive_groups = '#7f849c'
    widget_active_groups = '#7f849c'
