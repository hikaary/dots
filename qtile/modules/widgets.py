import subprocess

from libqtile import qtile
from libqtile.bar import Bar
from qtile_extras import widget

from .variables import Colors, Variables

from qtile_extras.widget import WiFiIcon

widget_defaults = dict(
    font="Fira Code Nerd Font",
    fontsize=18,
    padding=4,
    foreground=Colors.active,
)

sep = widget.Sep(padding=8, linewidth=2)


def get_active_connection():
    result = subprocess.run(["ip", "route", "show"], capture_output=True, text=True)
    output = result.stdout

    if "wlan0" in output:
        return "WiFi"
    elif "eth0" in output or "enp" in output:
        return "Ethernet"
    return "Unknown"


wifi_widget = WiFiIcon(
    custom_icon_paths=[Variables.qconf + "icons/"],
    disconnected_icon="no-wifi.svg",
    padding_y=12,
    foreground=Colors.active,
    active_colour=Colors.highlight,
)

ethernet_widget = widget.Image(
    filename=Variables.qconf + "icons/ethernet.svg", margin_y=7
)
disconnect_widget = widget.Image(
    filename=Variables.qconf + "icons/no-wifi.svg", margin_y=7
)

network_widget_box = widget.WidgetBox(
    widgets=[wifi_widget, ethernet_widget, disconnect_widget], hide=True
)


def update_network_widget():
    connection_type = get_active_connection()
    if connection_type == "WiFi":
        network_widget_box.widgets = [wifi_widget]
    elif connection_type == "Ethernet":
        network_widget_box.widgets = [ethernet_widget]
    else:
        network_widget_box.widgets = [disconnect_widget]
    network_widget_box.draw()
    qtile.call_soon(update_network_widget)


def init_bar():
    widgets = [
        widget.Spacer(length=10),
        widget.Image(
            filename=Variables.qconf + "icons/ram.svg",
            margin_y=5,
            margin_x=-6,
        ),
        widget.Memory(
            format="{MemUsed: .2f}{mm}",
            measure_mem="G",
            font="JetBrains Mono Bold",
            foreground=Colors.active,
        ),
        sep,
        # widget.Wttr(
        #     lang="ru",
        #     location={
        #         "Moscow": "Moscow",
        #     },
        #     format="%C %t %f",
        #     units="m",
        #     update_interval=30,
        # ),
        widget.Prompt(
            bell_style="visual",
            font="JetBrains Mono Bold",
            foreground=Colors.active,
        ),
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
        ),
        widget.Spacer(),
        sep,
        widget.Clock(
            format="%Y-%m-%d",
            font="JetBrains Mono Bold",
            foreground=Colors.active,
        ),
        sep,
        widget.Clock(
            format="%H:%M %p",
            foreground=Colors.active,
            font="JetBrains Mono Bold",
        ),
        widget.Spacer(length=5),
    ]

    if Variables.battery:
        widgets.insert(-5, widget.UPowerWidget(foreground=Colors.active))
    else:
        widgets.insert(
            -5,
            widget.Image(
                filename=Variables.qconf + "icons/no-battery.svg",
                margin_y=5,
            ),
        )

    connection = get_active_connection()
    if connection == "WiFi":
        widgets.insert(
            -5,
            widget.WiFiIcon(
                padding_y=12,
                foreground=Colors.active,
                active_colour=Colors.highlight,
            ),
        )
    elif connection == "Ethernet":
        widgets.insert(
            -5,
            widget.Image(
                filename=Variables.qconf + "icons/ethernet.svg",
                margin_y=7,
            ),
        )
    else:
        widgets.insert(
            -5,
            widget.Image(
                filename=Variables.qconf + "icons/no-wifi.svg",
                margin_y=7,
            ),
        )

    return Bar(
        widgets=widgets,
        margin=calculate_margin(),
        size=40,
        background=Colors.unfocus,
        opacity=0.8,
    )


def calculate_margin():
    width = Variables.primary_monitor_with
    left_right_margin = int(width * 0.20)
    return [10, left_right_margin, 0, left_right_margin]
