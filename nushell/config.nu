# Nushell Config File

# Environment Variables
$env.TERM = 'xterm-256color'
$env.EDITOR = 'nvim'
$env.VISUAL = 'nvim'
$env.PYTHON_KEYRING_BACKEND = 'keyring.backends.null.Keyring'
$env.__GL_THREADED_OPTIMIZATIONS = '0'

# FZF Configuration
if (which fd | length) > 0 {
    $env.FZF_ALT_C_COMMAND = "fd --type d"
    $env.FZF_DEFAULT_COMMAND = "fd --type f"
    $env.fzf_preview_dir_cmd = "ls -l --color=always"
    $env.fzf_preview_file_cmd = "cat -n"
    $env.fzf_fd_opts = "--hidden --exclude=.git"
}

# Aliases
alias v = mgraftcp --socks5 127.0.0.1:1080 nvim
alias lg = lazygit
alias ta = tmux attach
alias ld = lazydocker
alias s = sudo
alias t = bpytop
alias removepkg = doas pacman -R 
alias music = mgraftcp --socks5 127.0.0.1:1080 ncspot
alias venv-source = overlay use .venv/bin/activate.nu

def req-generate [] {
  uv pip freeze | uv pip compile - -o requirements.txt 
}

alias lh = ls -lh
alias l = ls

def ls-all [] {
  ls -a | select name type size modified
}

alias la = ls-all
alias htop = btm

def hikary-update-all [] {
    let tmpfile = (mktemp -p /tmp | str trim)  # Создаем временный файл в /tmp и убираем лишние пробелы
    rate-mirrors --save=($tmpfile) artix
    if ($tmpfile | path exists) { 
        doas mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup
        doas mv $tmpfile /etc/pacman.d/mirrorlist
        if not ($tmpfile | path exists) {  # Проверяем, что файл успешно перемещен
            aura -Ayu --noconfirm
        } else {
            echo "Ошибка: не удалось переместить временный файл"
        }
    } else {
        echo "Ошибка: временный файл не был создан"
    }
}

def extract [name:string] {
  let handlers = [ [extension command];
                   ['tar\.bz2|tbz|tbz2' 'tar xvjf']
                   ['tar\.gz|tgz'       'tar xvzf']
                   ['tar\.xz|txz'       'tar xvf']
                   ['tar\.Z'            'tar xvZf']
                   ['bz2'               'bunzip2']
                   ['deb'               'ar x']
                   ['gz'                'gunzip']
                   ['pkg'               'pkgutil --expand']
                   ['rar'               'unrar x']
                   ['tar'               'tar xvf']
                   ['xz'                'xz --decompress']
                   ['zip|war|jar|nupkg' 'unzip']
                   ['Z'                 'uncompress']
                   ['7z'                '7za x']
                 ]
  let maybe_handler = ($handlers | where $name =~ $'\.(($it.extension))$')
  if ($maybe_handler | is-empty) {
    error make { msg: "unsupported file extension" }
  } else {
    let handler = ($maybe_handler | first)
    nu -c ($handler.command + ' ' + $name)
  }
}


# Set other configuration options
$env.config =  {
    show_banner: false
    table: {
        mode: rounded
        index_mode: always
        trim: {
            methodology: wrapping
            wrapping_try_keep_words: true
            truncating_suffix: "..."
        }
    }
    history: {
        max_size: 100_000
        sync_on_enter: true
        file_format: "plaintext"
    }
    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "prefix"
        external: {
            enable: true
            max_results: 100
            completer: null
        }
    }
    filesize: {
        metric: false
        format: "auto"
    }
    use_grid_icons: true
    footer_mode: "25"
    float_precision: 2
    use_ansi_coloring: true
    edit_mode: vi
    render_right_prompt_on_last_line: true
}

# Load custom theme if exists
if ('~/.config/nushell/custom_theme.nu' | path exists) {
  source custom_theme.nu 
  $env.config = ($env.config | merge {
    color_config: $theme
  })
}

source ~/.cache/zoxide/init.nu
source ~/.cache/starship/init.nu
source ~/.cache/atuin/init.nu
source ~/.cache/carapace/init.nu


