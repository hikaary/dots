from libqtile.config import DropDown, Group, Match, ScratchPad

from .layouts import layouts
from .variables import Variables

scratchpads = [
    ScratchPad(
        'ScratchTerm',
        [
            DropDown(
                'main_app',
                'alacritty',
                height=0.5,
                width=0.35,
                x=0.62,
                y=0.25,
                on_focus_lost_hide=False,
            ),
        ],
    ),
    ScratchPad(
        'ScratchAudio',
        [
            DropDown(
                'main_app',
                'alacritty -e pulsemixer',
                height=0.5,
                width=0.35,
                x=0.05,
                y=0.25,
            ),
        ],
    ),
    ScratchPad(
        'ScratchPlayer',
        [
            DropDown(
                'main_app',
                'alacritty -e ymcli',
                height=0.535,
                width=0.5,
                x=0.25,
                y=0.25,
            ),
        ],
    ),
    ScratchPad(
        'ScratchTG',
        [
            DropDown(
                'main_app',
                'telegram-desktop',
                height=0.8,
                width=0.25,
                x=0.1,
                y=0.1,
                on_focus_lost_hide=False,
            ),
        ],
    ),
    ScratchPad(
        'ScratchKeePass',
        [
            DropDown(
                'main_app',
                'keepassxc',
                height=0.8,
                width=0.3,
                x=-0.2,
                y=0.1,
                on_focus_lost_hide=False,
            ),
        ],
    ),
]


groups_config: dict[int, dict] = {
    1: {'screen': 1, 'layouts': layouts, 'layout': 'monadtall'},
    2: {'screen': 1, 'layouts': layouts, 'layout': 'monadtall'},
    3: {'screen': 0, 'layouts': layouts, 'layout': 'monadwide'},
    4: {'screen': 2, 'layouts': layouts, 'layout': 'monadtall'},
    5: {'screen': 2, 'layouts': layouts, 'layout': 'max'},
    6: {'screen': 1, 'layouts': layouts, 'layout': 'monadtall'},
    7: {'screen': 1, 'layouts': layouts, 'layout': 'monadtall'},
    8: {'screen': 2, 'layouts': layouts, 'layout': 'monadtall'},
    9: {'screen': 2, 'layouts': layouts, 'layout': 'monadtall'},
    0: {'screen': 1, 'layouts': layouts, 'layout': 'monadtall'},
}


def get_screen_number(group_number: int) -> int:
    if Variables.monitors < 3:
        return 0

    return groups_config[group_number]['screen']


groups: list[Group | ScratchPad] = []
for group_number, group_config in groups_config.items():
    screen = get_screen_number(group_number)

    matches = [
        Match(wm_class=wm_class) for wm_class in Variables.app_groups[group_number]
    ]

    group_kwargs = dict(
        name=str(group_number),
        screen_affinity=screen,
        matches=matches,
        layouts=group_config['layouts'],
        layout=group_config['layout'],
        label='',
    )

    groups.append(Group(**group_kwargs))  # type: ignore

groups.extend(scratchpads)
