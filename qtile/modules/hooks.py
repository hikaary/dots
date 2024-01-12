from subprocess import Popen

from libqtile import hook

from .variables import Variables


@hook.subscribe.startup_once
def autostart():
    Popen(Variables.load_settings_sh)
    Popen(Variables.autostart_sh)


@hook.subscribe.suspend
def lock_on_sleep():
    pass


@hook.subscribe.resume
def resume():
    Popen(Variables.load_settings_sh)
    Popen(Variables.lock_sh)
