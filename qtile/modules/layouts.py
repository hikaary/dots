from libqtile import layout
from libqtile.config import Match

from .variables import Colors

layout_theme = {
    "border_width": 1,
    "margin": 15,
    "border_focus": Colors.Lavender,
    "border_normal": Colors.Crust,
}

floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        Match(wm_class="telegram-desktop"),
        Match(wm_class="org.telegram.desktop"),
        Match(wm_class="nekoray"),
        Match(wm_class="hiddify"),
    ],
    **layout_theme,
)

layouts = [
    layout.MonadTall(
        **layout_theme,
        single_border_width=1,
        ratio=0.7,
    ),
    layout.Stack(**layout_theme, num_stacks=2),
    layout.MonadWide(
        **layout_theme,
    ),
    layout.Max(
        border_width=0,
        only_focused=True,
        margin=10,
    ),
]
