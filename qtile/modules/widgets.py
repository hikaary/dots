import subprocess

from libqtile import qtile
from libqtile.bar import Bar
from qtile_extras import widget

from .variables import Colors, Variables

widget_defaults = dict(
    font='Fira Code Nerd Font',
    fontsize=18,
    padding=4,
    foreground=Colors.widget_foreground,
)

sep = widget.Sep(padding=8, linewidth=2)


def search():
    qtile.cmd_spawn('rofi -show drun')


def get_active_connection():
    result = subprocess.run(['ip', 'route', 'show'], capture_output=True, text=True)
    output = result.stdout

    if 'default via' in output:
        if 'wlan0' in output:
            return 'WiFi'
        elif 'eth0' in output:
            return 'Ethernet'
        elif 'enp' in output:
            return 'Ethernet'

    return 'Unknown'


def init_bar():
    widgets = [
        widget.Spacer(length=10),
        widget.Image(
            filename=Variables.qconf + 'icons/ram.svg',
            margin_y=5,
            margin_x=-6,
        ),
        widget.Memory(
            format='{MemUsed: .2f}{mm}',
            measure_mem='G',
            font='JetBrains Mono Bold',
        ),
        sep,
        widget.CurrentLayoutIcon(
            scale=0.55,
            foreground=Colors.widget_foreground,
            use_mask=True,
        ),
        sep,
        widget.Prompt(
            bell_style='visual',
            font='JetBrains Mono Bold',
        ),
        widget.Spacer(),
        widget.GroupBox(
            highlight_method='text',
            fontsize=15,
            margin_x=12,
            borderwidth=0,
            highlight_color=Colors.widget_foreground,
            this_current_screen_border=Colors.this_current_screen_border,
            foreground=Colors.widget_foreground,
            active=Colors.widget_active_groups,
            inactive=Colors.widget_inactive_groups,
        ),
        widget.Spacer(),
        sep,
        sep,
        widget.Clock(
            format='%Y-%m-%d',
            font='JetBrains Mono Bold',
        ),
        sep,
        widget.Clock(
            format='%H:%M %p',
            foreground=Colors.widget_foreground,
            font='JetBrains Mono Bold',
        ),
        widget.Spacer(length=5),
    ]

    if Variables.battery:
        widgets.insert(-5, widget.UPowerWidget())
    else:
        widgets.insert(
            -5,
            widget.Image(
                filename=Variables.qconf + 'icons/no-battery.svg',
                margin_y=5,
            ),
        )

    connection = get_active_connection()
    if connection == 'WiFi':
        widgets.insert(
            -5,
            widget.WiFiIcon(
                padding_y=12,
                foreground=Colors.widget_foreground,
                active_colour=Colors.widget_foreground,
            ),
        )
    elif connection == 'Ethernet':
        widgets.insert(
            -5,
            widget.Image(
                filename=Variables.qconf + 'icons/ethernet.svg',
                margin_y=7,
            ),
        )
    else:
        widgets.insert(
            -5,
            widget.Image(
                filename=Variables.qconf + 'icons/no-wifi.svg',
                margin_y=7,
            ),
        )

    return Bar(
        widgets=widgets,
        margin=calculate_margin(),
        size=40,
        background=Colors.bar_background,
        opacity=0.8,
    )


def calculate_margin():
    width = Variables.primary_monitor_with
    left_right_margin = int(width * 0.20)
    return [10, left_right_margin, 0, left_right_margin]
