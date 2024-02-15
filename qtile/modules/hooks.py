from subprocess import Popen

from libqtile import hook
from libqtile.backend.wayland.xdgwindow import XdgWindow

from .variables import Variables


@hook.subscribe.startup_once
def autostart():
    Popen(Variables.autostart_sh)
    Popen(Variables.brightness_sh)


@hook.subscribe.suspend
def lock_on_sleep():
    Popen(Variables.lock_sh)


@hook.subscribe.client_new
def resize_telegram_viewer(window):
    if not isinstance(window, XdgWindow):
        return

    wm_class = window.get_wm_class()
    if wm_class and wm_class[0] == 'org.telegram.desktop':
        window.enable_floating()

        x, y = window.get_size()
        window.move_floating(int(x * 0.2), int(y * 0.6))
        window.set_size_floating(int(x * 0.25), int(y * 0.773))
