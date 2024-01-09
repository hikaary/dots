from libqtile.command import lazy
from libqtile.config import Click, Drag, Key, ScratchPad

from .groups import groups
from .variables import Variables

mod = 'mod4'


mouse = [
    Drag(
        [mod],
        'Button1',
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], 'Button3', lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], 'Button2', lazy.window.bring_to_front()),
]


keys = [
    Key([mod], 'h', lazy.layout.left(), desc='Move focus to left'),
    Key([mod], 'l', lazy.layout.right(), desc='Move focus to right'),
    Key([mod], 'j', lazy.layout.down(), desc='Move focus down'),
    Key([mod], 'k', lazy.layout.up(), desc='Move focus up'),
    Key(
        [mod, 'shift'],
        'h',
        lazy.layout.shuffle_left(),
        lazy.layout.move_left().when(layout=['treetab']),
        desc='Move window to the left/move tab left in treetab',
    ),
    Key(
        [mod, 'shift'],
        'l',
        lazy.layout.shuffle_right(),
        lazy.layout.move_right().when(layout=['treetab']),
        desc='Move window to the right/move tab right in treetab',
    ),
    Key(
        [mod, 'shift'],
        'j',
        lazy.layout.shuffle_down(),
        lazy.layout.section_down().when(layout=['treetab']),
        desc='Move window down/move down a section in treetab',
    ),
    Key(
        [mod, 'shift'],
        'k',
        lazy.layout.shuffle_up(),
        lazy.layout.section_up().when(layout=['treetab']),
        desc='Move window downup/move up a section in treetab',
    ),
    Key(
        [mod],
        'tab',
        lazy.group.next_window(),
        desc='Move window focus to other window',
    ),
    Key([mod, 'control'], 'h', lazy.layout.grow_left(), desc='Grow window to the left'),
    Key(
        [mod, 'control'], 'l', lazy.layout.grow_right(), desc='Grow window to the right'
    ),
    Key([mod, 'control'], 'j', lazy.layout.grow_down(), desc='Grow window down'),
    Key([mod, 'control'], 'k', lazy.layout.grow_up(), desc='Grow window up'),
    Key([mod], 'n', lazy.layout.normalize(), desc='Reset all window sizes'),
    Key(
        [mod, 'shift'],
        'Return',
        lazy.group['ScratchTerm'].dropdown_toggle('main_app'),
        desc='Float terminal',
    ),
    Key(
        [mod, 'shift'],
        'a',
        lazy.group['ScratchAudio'].dropdown_toggle('main_app'),
        desc='Pulsemixer',
    ),
    Key(
        [mod],
        'p',
        lazy.group['ScratchPlayer'].dropdown_toggle('main_app'),
        desc='Music player',
    ),
    Key(
        [mod],
        't',
        lazy.group['ScratchTG'].dropdown_toggle('main_app'),
        desc='Telegram',
    ),
    Key([mod], 'Return', lazy.spawn(Variables.terminal), desc='Launch terminal'),
    Key([mod, 'control'], 'tab', lazy.next_layout(), desc='Toggle between layouts'),
    Key([mod], 'q', lazy.window.kill(), desc='Kill focused window'),
    Key([mod, 'shift'], 'r', lazy.reload_config(), desc='Reload the config'),
    Key([mod], 'f', lazy.window.toggle_floating(), desc='Toggle floating'),
    Key(['mod4'], 'd', lazy.spawncmd()),
    Key([mod], 's', lazy.spawn(Variables.bluetooth), desc='Launch Bluetooth'),
    Key([mod], 'c', lazy.layout.maximize(), desc='Toggle maximize'),
    Key([mod, 'shift'], 'p', lazy.spawn(Variables.sstool), desc='Take screenshot'),
]

for group in groups:
    if isinstance(group, ScratchPad):
        continue

    key = str(0) if group.name == str(10) else group.name

    keys.append(
        Key(
            [mod],
            group.name,
            lazy.group[group.name].toscreen(group.screen_affinity),
            lazy.to_screen(group.screen_affinity),
        )
    )

    keys.append(
        Key(
            [mod, 'shift'],
            group.name,
            lazy.window.togroup(group.name),
        )
    )
