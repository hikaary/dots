# Переменные окружения
export TERM='xterm-256color'
export PATH="/home/hikary/.bun/bin:$PATH"
export EDITOR='nvim'
export VISUAL='nvim'
export PYTHON_KEYRING_BACKEND='keyring.backends.null.Keyring'
export __GL_THREADED_OPTIMIZATIONS='0'

# Настройка FZF
if command -v fd > /dev/null; then
    export FZF_ALT_C_COMMAND="fd --type d"
    export FZF_DEFAULT_COMMAND="fd --type f"
    export FZF_PREVIEW_DIR_CMD="ls -l --color=always"
    export FZF_PREVIEW_FILE_CMD="cat -n"
    export FZF_FD_OPTS="--hidden --exclude=.git"
fi

# Привязка горячей клавиши к функции
bindkey '^[ [1;5D' vi-cmd-mode

# Алиасы
alias v='mgraftcp --socks5 127.0.0.1:1080 nvim'
alias proxy='mgraftcp --socks5 127.0.0.1:1080'
alias lg='lazygit'
alias ta='tmux attach'
alias ..='cd ..'
alias ld='lazydocker'
alias s='sudo'
alias t='bpytop'
alias music='mgraftcp --socks5 127.0.0.1:1080 ncspot'
alias venv-source='source .venv/bin/activate'
alias doom='~/.config/emacs/bin/doom'
alias doomscript='~/.config/emacs/bin/doomscript'
alias l='exa -lah --icons'
alias tree='exa --tree --level=2 --icons'
alias htop='btm'

# Функции
req-generate() {
    uv pip freeze | uv pip compile - -o requirements.txt
}

hikary-update-all() {
    tmpfile=$(mktemp -p /tmp/)
    rate-mirrors --save="$tmpfile" artix

    if [ -e "$tmpfile" ]; then
        doas mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup
        doas mv "$tmpfile" /etc/pacman.d/mirrorlist
        if [ ! -e "$tmpfile" ]; then
            aura -Ayu --noconfirm
        else
            echo "Ошибка: не удалось переместить временный файл"
        fi
    else
        echo "Ошибка: временный файл не был создан"
    fi
}

extract() {
    if [ -z "$1" ]; then
        echo "Usage: extract <file>"
        return 1
    fi

    local file="$1"

    if [ ! -f "$file" ]; then
        echo "'$file' is not a valid file"
        return 1
    fi

    case "$file" in
        *.tar.bz2|*.tbz|*.tbz2) tar xvjf "$file" ;;
        *.tar.gz|*.tgz) tar xvzf "$file" ;;
        *.tar.xz|*.txz) tar xvf "$file" ;;
        *.tar.Z) tar xvZf "$file" ;;
        *.bz2) bunzip2 "$file" ;;
        *.deb) ar x "$file" ;;
        *.gz) gunzip "$file" ;;
        *.pkg) pkgutil --expand "$file" ;;
        *.rar) unrar x "$file" ;;
        *.tar) tar xvf "$file" ;;
        *.xz) xz --decompress "$file" ;;
        *.zip|*.war|*.jar|*.nupkg) unzip "$file" ;;
        *.Z) uncompress "$file" ;;
        *.7z) 7za x "$file" ;;
        *) echo "unsupported file extension"; return 1 ;;
    esac
}

# История
HISTFILE="$HOME/.local/share/zsh/history"
HISTSIZE=100000
SAVEHIST=100000
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

# Создание директории для хранения истории, если она не существует
mkdir -p "$(dirname "$HISTFILE")"

# Автодополнение
autoload -Uz compinit
compinit

# Prompt
autoload -Uz promptinit
promptinit

# Установка Zinit в ~/.local/share
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    echo "Installing Zinit..."
    mkdir -p "$HOME/.local/share/zinit" && chmod g-rwX "$HOME/.local/share/zinit"
    git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

# Установка плагинов через Zinit

# Подсветка синтаксиса
zinit light zsh-users/zsh-syntax-highlighting

# Автодополнения
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

# Улучшенный Tab-комплит
zinit light Aloxaf/fzf-tab

# История
zinit light zsh-users/zsh-history-substring-search

# Автозакрытие скобочек и тд
zinit light hlissner/zsh-autopair

# Навигация
zinit light changyuheng/zsh-interactive-cd

# Тема
zinit light sindresorhus/pure

# Vim-mode
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode
