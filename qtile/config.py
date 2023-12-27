from libqtile.backend.wayland.inputs import InputConfig
from libqtile.config import Click, Drag
from libqtile.lazy import lazy

from modules import *

mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []

follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True

cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

auto_minimize = True

wl_input_rules = {
    "type:touchpad": InputConfig(tap=True, natural_scroll=True, dwt=True),
}

wmname = "Qtile"
