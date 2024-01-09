import os

from libqtile import qtile
from libqtile.backend.wayland.inputs import InputConfig
from modules import *  # noqa

if qtile.core.name == 'wayland':
    os.environ['XDG_SESSION_DESKTOP'] = 'qtile:wlroots'
    os.environ['XDG_CURRENT_DESKTOP'] = 'qtile:wlroots'

wl_input_rules = {
    'type:keyboard': InputConfig(
        kb_layout='us, ru',
        kb_repeat_rate=60,
        kb_repeat_delay=220,
        kb_options='grp:caps_toggle',
    ),
    'type:touchpad': InputConfig(
        tap=True,
        natural_scroll=True,
        dwt=True,
    ),
}

dgroups_key_binder = None
dgroups_app_rules = []

follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True

cursor_warp = True
auto_fullscreen = True
focus_on_window_activation = 'smart'
reconfigure_screens = True
auto_minimize = True

wmname = 'Qtile'
