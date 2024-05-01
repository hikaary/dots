import subprocess

from libqtile.bar import Bar
from qtile_extras import widget
from qtile_extras.widget.decorations import RectDecoration

from .variables import Colors, Variables

from .spotify import Spotify

widget_defaults = dict(
    font="Fira Code Nerd Font",
    fontsize=18,
    padding=4,
    foreground=Colors.active,
)

sep = widget.Sep(padding=8, linewidth=0)


def get_active_connection():
    result = subprocess.run(["ip", "route", "show"], capture_output=True, text=True)
    output = result.stdout

    if "wlan0" in output:
        return "WiFi"
    elif "eth0" in output or "enp" in output:
        return "Ethernet"
    return "Unknown"


decoration_group = {
    "decorations": [
        RectDecoration(
            colour=Colors.Base,
            radius=16,
            filled=True,
            padding_y=4,
            group=True,
        )
    ],
    "padding": 10,
}


def init_bar():
    widgets = [
        widget.Memory(
            format="{MemUsed: .2f}{mm}",
            measure_mem="G",
            font="JetBrains Mono Bold",
            **decoration_group,
        ),
        widget.WiFiIcon(
            padding_y=11,
            foreground=Colors.active,
            active_colour=Colors.highlight,
            **decoration_group,
        ),
        Spotify(format="{icon} {artist} - {track}"),
        widget.Spacer(),
        widget.GroupBox(
            highlight_method="text",
            fontsize=15,
            margin_x=12,
            borderwidth=0,
            highlight_color=Colors.focus,
            this_current_screen_border=Colors.highlight,
            foreground=Colors.active,
            active=Colors.active,
            inactive=Colors.inactive,
            **decoration_group,
        ),
        widget.Spacer(),
        widget.Clock(
            format="%Y-%m-%d",
            font="JetBrains Mono Bold",
            foreground=Colors.active,
            **decoration_group,
        ),
        widget.Clock(
            format="%H:%M %p",
            foreground=Colors.active,
            font="JetBrains Mono Bold",
            **decoration_group,
        ),
    ]

    if Variables.battery:
        widgets.insert(
            -7,
            widget.UPowerWidget(
                foreground=Colors.active,
                spacing=10,
                battery_height=12,
                margin=2,
                **decoration_group,
            ),
        )
    else:
        widgets.insert(
            -7,
            widget.Image(
                filename=Variables.qconf + "icons/no-battery.svg",
                margin_y=5,
                **decoration_group,
            ),
        )

    return Bar(
        widgets=widgets,
        margin=calculate_margin(),
        size=40,
        # background=Colors.Base,
        background="#00000001",
        foreground=Colors.Text,
        opacity=0.8,
    )


def calculate_margin():
    width = Variables.primary_monitor_with
    left_right_margin = int(width * 0.10)
    return [10, left_right_margin, 0, left_right_margin]
