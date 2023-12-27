from libqtile.lazy import lazy
from qtile_extras.popup.toolkit import (PopupImage, PopupRelativeLayout,
                                        PopupText)

from .variables import Colors, Variables


def show_power_menu(qtile):
    controls = [
        PopupImage(
            filename=Variables.lock_image,
            pos_x=0.15,
            pos_y=0.1,
            width=0.1,
            height=0.5,
            highlight=Colors.widget_foreground,
            mouse_callbacks={"Button1": lazy.spawn(Variables.lock)},
        ),
        PopupImage(
            filename=Variables.sleep_image,
            pos_x=0.45,
            pos_y=0.1,
            width=0.1,
            height=0.5,
            highlight=Colors.widget_foreground,
            mouse_callbacks={"Button1": lazy.spawn(Variables.sleep)},
        ),
        PopupImage(
            filename=Variables.shutdown_image,
            pos_x=0.75,
            pos_y=0.1,
            width=0.1,
            height=0.5,
            highlight="A00000",
            mouse_callbacks={"Button1": lazy.shutdown()},
        ),
        PopupText(
            text="Lock",
            pos_x=0.1,
            pos_y=0.7,
            width=0.2,
            height=0.2,
            h_align="center",
        ),
        PopupText(
            text="Sleep",
            pos_x=0.4,
            pos_y=0.7,
            width=0.2,
            height=0.2,
            h_align="center",
        ),
        PopupText(
            text="Shutdown",
            pos_x=0.7,
            pos_y=0.7,
            width=0.2,
            height=0.2,
            h_align="center",
        ),
    ]

    layout = PopupRelativeLayout(
        qtile,
        width=400,
        height=120,
        controls=controls,
        background=Colors.powermenu_background,
        initial_focus=None,
        close_on_click=True,
        hide_interval=1,
    )

    layout.show(centered=True)
