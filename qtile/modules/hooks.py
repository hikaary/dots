from subprocess import Popen

from libqtile import hook, qtile

from .variables import Variables


@hook.subscribe.startup_once
def autostart():
    Popen(Variables.resume_sh)
    Popen(Variables.autostart_sh)


@hook.subscribe.suspend
def lock_on_sleep():
    qtile.spawn(Variables.lock)


@hook.subscribe.resume
def resume():
    Popen(Variables.resume_sh)
