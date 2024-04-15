from libqtile.config import DropDown, Group, Match, ScratchPad

from .layouts import layouts
from .variables import Variables

scratchpads = [
    ScratchPad(
        "ScratchTerm",
        [
            DropDown(
                "main_app",
                Variables.terminal,
                height=0.5,
                width=0.35,
                x=0.62,
                y=0.25,
                on_focus_lost_hide=False,
            ),
        ],
    ),
    ScratchPad(
        "ScratchAudio",
        [
            DropDown(
                "main_app",
                Variables.terminal + " -e pulsemixer",
                height=0.5,
                width=0.35,
                x=0.05,
                y=0.25,
            ),
        ],
    ),
    ScratchPad(
        "ScratchPlayer",
        [
            DropDown(
                "main_app",
                Variables.terminal + " -e spt",
                height=0.8,
                width=0.4,
                x=0.55,
                y=0.05,
            ),
        ],
    ),
    ScratchPad(
        "ScratchTG",
        [
            DropDown(
                "main_app",
                "telegram-desktop",
                height=0.8,
                width=0.25,
                x=0.1,
                y=0.1,
                on_focus_lost_hide=False,
            ),
        ],
    ),
    ScratchPad(
        "ScratchKeePass",
        [
            DropDown(
                "main_app",
                "keepassxc",
                height=0.8,
                width=0.3,
                x=0.6,
                y=0.1,
                on_focus_lost_hide=False,
            ),
        ],
    ),
    ScratchPad(
        "ScratchVPN",
        [
            DropDown(
                "main_app",
                "hiddify",
                height=0.4,
                width=0.2,
                x=0.79,
                y=0.01,
                on_focus_lost_hide=True,
            ),
        ],
    ),
]


groups_config: dict[int, dict] = {
    1: {"screen": 1, "layouts": layouts, "layout": "monadtall"},
    2: {"screen": 1, "layouts": layouts, "layout": "monadtall"},
    3: {"screen": 2, "layouts": layouts, "layout": "max"},
    4: {"screen": 0, "layouts": layouts, "layout": "monadtall"},
    5: {"screen": 1, "layouts": layouts, "layout": "max"},
    6: {"screen": 1, "layouts": layouts, "layout": "monadtall"},
    7: {"screen": 1, "layouts": layouts, "layout": "monadtall"},
    8: {"screen": 0, "layouts": layouts, "layout": "monadtall"},
    9: {"screen": 0, "layouts": layouts, "layout": "monadtall"},
    0: {"screen": 0, "layouts": layouts, "layout": "monadtall"},
}


def get_screen_number(group_config: dict) -> int:
    screen_number = group_config["screen"]
    if Variables.monitors > screen_number:
        return screen_number
    return 0


groups: list[Group | ScratchPad] = []
for group_number, group_config in groups_config.items():
    screen = get_screen_number(group_config)

    matches = [Match(title=wm_class) for wm_class in Variables.app_groups[group_number]]

    if not group_number:
        matches.append(Match(title="Easy Effects"))

    group_kwargs = dict(
        name=str(group_number),
        screen_affinity=screen,
        matches=matches,
        layouts=group_config["layouts"],
        layout=group_config["layout"],
        label="",
    )

    groups.append(Group(**group_kwargs))  # type: ignore

groups.extend(scratchpads)
