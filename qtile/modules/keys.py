from libqtile.command import lazy
from libqtile.config import Key, KeyChord, ScratchPad

from .groups import groups
from .variables import Variables

mod = "mod4"


keys = [
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key(
        [mod, "shift"],
        "h",
        lazy.layout.shuffle_left(),
        lazy.layout.move_left().when(layout=["treetab"]),
        desc="Move window to the left/move tab left in treetab",
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        lazy.layout.move_right().when(layout=["treetab"]),
        desc="Move window to the right/move tab right in treetab",
    ),
    Key(
        [mod, "shift"],
        "j",
        lazy.layout.shuffle_down(),
        lazy.layout.section_down().when(layout=["treetab"]),
        desc="Move window down/move down a section in treetab",
    ),
    Key(
        [mod, "shift"],
        "k",
        lazy.layout.shuffle_up(),
        lazy.layout.section_up().when(layout=["treetab"]),
        desc="Move window downup/move up a section in treetab",
    ),
    Key(
        [mod],
        "tab",
        lazy.group.next_window(),
        desc="Move window focus to other window",
    ),
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key(
        [mod, "shift"],
        "Return",
        lazy.group["ScratchTerm"].dropdown_toggle("main_app"),
        desc="Float terminal",
    ),
    Key(
        [mod, "shift"],
        "a",
        lazy.group["ScratchAudio"].dropdown_toggle("main_app"),
        desc="Pulsemixer",
    ),
    Key(
        [mod],
        "t",
        lazy.group["ScratchTG"].dropdown_toggle("main_app"),
        desc="Telegram",
    ),
    Key(
        [mod],
        "v",
        lazy.group["ScratchVPN"].dropdown_toggle("main_app"),
        desc="VPN",
    ),
    Key(
        [mod],
        "m",
        lazy.group["ScratchKeePass"].dropdown_toggle("main_app"),
        desc="KeePass",
    ),
    Key(
        [mod],
        "r",
        lazy.group["ScratchDiscord"].dropdown_toggle("main_app"),
        desc="DiscordChat",
    ),
    Key(
        [mod, "shift"],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen",
    ),
    Key([mod], "Return", lazy.spawn(Variables.terminal), desc="Launch terminal"),
    Key([mod, "control"], "tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod], "f", lazy.window.toggle_floating(), desc="Toggle floating"),
    Key([mod], "d", lazy.spawncmd()),
    Key([mod], "s", lazy.spawn(Variables.bluetooth), desc="Launch Bluetooth"),
    Key([mod], "c", lazy.layout.maximize(), desc="Toggle maximize"),
    Key([mod, "shift"], "P", lazy.spawn(Variables.sstool), desc="Take screenshot"),
]

# functions keys
keys.extend(
    [
        Key(
            [],
            "XF86MonBrightnessUp",
            lazy.function(lambda _: Variables.adjust_brightness("+10%")),
        ),
        Key(
            [],
            "XF86MonBrightnessDown",
            lazy.function(lambda _: Variables.adjust_brightness("10%-")),
        ),
        Key(
            [],
            "XF86AudioLowerVolume",
            lazy.function(lambda _: Variables.adjust_volume("5%-")),
        ),
        Key(
            [],
            "XF86AudioRaiseVolume",
            lazy.function(lambda _: Variables.adjust_volume("5%+")),
        ),
        Key(
            [],
            "XF86AudioMute",
            lazy.function(lambda _: Variables.adjust_volume("toggle")),
        ),
        KeyChord(  # type: ignore
            [mod],
            "b",
            [
                Key(
                    [],
                    "d",
                    lazy.function(
                        lambda _: Variables.adjust_keyboard_backlight("down")
                    ),
                ),
                Key(
                    [],
                    "u",
                    lazy.function(lambda _: Variables.adjust_keyboard_backlight("up")),
                ),
                Key(
                    [],
                    "t",
                    lazy.function(
                        lambda _: Variables.adjust_keyboard_backlight("toggle")
                    ),
                ),
            ],
            name="Brightness",
        ),
    ]
)


# spotify  player
keys.extend(
    [
        KeyChord(  # type: ignore
            [mod],
            "p",
            [
                Key(
                    [],
                    "a",
                    lazy.group["ScratchPlayer"].dropdown_toggle("main_app"),
                    desc="Music player",
                ),
                Key([], "n", lazy.spawn("spt playback -n")),
                Key([], "t", lazy.spawn("spt playback -t")),
            ],
            name="Spotify",
        ),
    ]
)
# float settings

keys.extend(
    [
        Key(
            [mod],
            "Left",
            lazy.window.resize_floating(-30, 0),
            desc="Resize window left",
        ),
        Key(
            [mod],
            "Right",
            lazy.window.resize_floating(30, 0),
            desc="Resize window right",
        ),
        Key(
            [mod], "Down", lazy.window.resize_floating(0, 30), desc="Resize window down"
        ),
        Key([mod], "Up", lazy.window.resize_floating(0, -30), desc="Resize window up"),
        Key(
            [mod, "shift"],
            "Left",
            lazy.window.move_floating(-30, 0),
            desc="Move window left",
        ),
        Key(
            [mod, "shift"],
            "Right",
            lazy.window.move_floating(30, 0),
            desc="Move window right",
        ),
        Key(
            [mod, "shift"],
            "Down",
            lazy.window.move_floating(0, 30),
            desc="Move window down",
        ),
        Key(
            [mod, "shift"],
            "Up",
            lazy.window.move_floating(0, -30),
            desc="Move window up",
        ),
    ]
)

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
            [mod, "shift"],
            group.name,
            lazy.window.togroup(group.name),
        )
    )
