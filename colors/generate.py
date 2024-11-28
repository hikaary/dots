from pathlib import Path

import tomli


def load_colors(config_path):
    with open(config_path, 'rb') as f:
        return tomli.load(f)


def generate_waybar(colors):
    return '\n'.join(
        f'@define-color {name} {value};'
        for name, value in colors['colors'].items()
    )


def generate_rofi(colors):
    return f"""* {{
    bg-col: {colors['colors']['base']};
    bg-col-light: {colors['colors']['base']};
    border-col: {colors['colors']['base']};
    selected-col: {colors['colors']['base']};
    blue: {colors['colors']['blue']};
    fg-col: {colors['colors']['text']};
    fg-col2: {colors['colors']['red']};
    grey: {colors['colors']['overlay0']};

    width: 600;
    font: "JetBrainsMono Nerd Font 14";
}}

element-text, element-icon , mode-switcher {{
    background-color: inherit;
    text-color: inherit;
}}"""


def generate_fsh(colors):
    return f"""[base]
default          = {colors['colors']['text']}
unknown-token    = {colors['colors']['red']},bold
commandseparator = {colors['colors']['teal']}
redirection      = {colors['colors']['teal']}
here-string-tri  = {colors['colors']['subtext1']}
here-string-text = {colors['colors']['subtext1']}
here-string-var  = {colors['colors']['subtext1']}
comment          = {colors['colors']['overlay0']}
correct-subtle   = {colors['colors']['lavender']}
incorrect-subtle = {colors['colors']['maroon']}
subtle-bg        = none
secondary        =
recursive-base   = {colors['colors']['text']}

[command-point]
reserved-word     = {colors['colors']['mauve']}
subcommand        = {colors['colors']['sapphire']}
alias             = {colors['colors']['blue']}
suffix-alias      = {colors['colors']['blue']}
global-alias      = {colors['colors']['blue']}
builtin           = {colors['colors']['mauve']}
function          = {colors['colors']['blue']}
command           = {colors['colors']['blue']}
precommand        = {colors['colors']['mauve']}
hashed-command    = {colors['colors']['blue']}"""


def main():
    config_dir = Path.home() / '.config'
    colors = load_colors(config_dir / 'colors/mocha.toml')

    generators = {
        'waybar/mocha.css': generate_waybar,
        'rofi/mocha.rasi': generate_rofi,
    }

    for path, generator in generators.items():
        full_path = config_dir / path
        full_path.parent.mkdir(parents=True, exist_ok=True)
        with open(full_path, 'w') as f:
            f.write(generator(colors))
        print(f'Generated {path}')


if __name__ == '__main__':
    main()
