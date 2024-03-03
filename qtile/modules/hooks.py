from subprocess import Popen

from libqtile import hook
from libqtile.backend.wayland.xdgwindow import XdgWindow
from libqtile.command import lazy

from .variables import Variables, get_screens_count


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
        window.toggle_maximize()


@hook.subscribe.screen_change
def screen_change(event):
    Variables.monitors = get_screens_count()


@hook.subscribe.screen_change
def screen_change_final(event):
    lazy.reload_config()
