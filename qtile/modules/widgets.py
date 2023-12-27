import subprocess

from libqtile.bar import Bar
from qtile_extras import widget

from .custom_widgets.vpn import XrayProxy
from .variables import Colors, Variables

widget_defaults = dict(
    font='Fira Code Nerd Font',
    fontsize=14,
    padding=4,
    foreground=Colors.widget_foreground,
)

sep = widget.Sep(padding=10, linewidth=2)


def init_bar():
    widgets = [
        widget.Spacer(length=20),
        widget.Memory(
            format='{MemUsed: .2f}{mm}',
            measure_mem='G',
        ),
        sep,
        widget.CurrentLayoutIcon(
            scale=0.55,
            foreground=Colors.widget_foreground,
            use_mask=True,
        ),
        sep,
        widget.Prompt(bell_style='visual'),
        widget.Spacer(),
        widget.GroupBox(
            highlight_method='text',
            fontsize=15,
            margin_x=12,
            borderwidth=0,
            highlight_color=Colors.widget_foreground,
            this_current_screen_border=Colors.widget_foreground,
            foreground=Colors.widget_foreground,
            active=Colors.widget_active_groups,
            inactive=Colors.widget_inactive_groups,
        ),
        widget.Spacer(),
        sep,
        XrayProxy(
            scale=0.58,
            images=['proxy-on', 'proxy-off'],
            systemd='sing-box',
            theme_path=Variables.qconf + 'icons',
        ),
        sep,
        widget.WiFiIcon(
            padding_y=9,
            foreground=Colors.widget_foreground,
            active_colour=Colors.widget_foreground,
        ),
        sep,
        widget.Clock(format='%Y-%m-%d %a %H:%M'),
        widget.Spacer(length=20),
    ]
    if Variables.battery:
        widgets.insert(-3, widget.UPowerWidget())

    return Bar(
        widgets=widgets,
        margin=calculate_margin(),
        size=32,
        background=Colors.bar_background,
        opacity=0.7,
    )


def get_screen_resolution():
    try:
        cmd = "xrandr --current | grep ' primary' | awk '{print $4}' | sed 's/+0+0//'"
        result = subprocess.check_output(cmd, shell=True).decode('utf-8').strip()
        width, height = map(int, result.split('x'))
        return width, height
    except Exception:
        return 1920, 1080


def calculate_margin():
    width, _ = get_screen_resolution()
    left_right_margin = int(width * 0.20)
    return [10, left_right_margin, 0, left_right_margin]