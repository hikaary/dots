# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Переменные окружения
export TERM='xterm-256color'
export PATH="$HOME/.bun/bin:$HOME/.cargo/bin:$PATH"
export EDITOR='nvim'
export VISUAL='nvim'
export OPENAI_API_KEY="$(cat ~/credentials/openai_token)"
export CLAUDE_API_KEY="$(cat ~/credentials/claude_token)"
export GENIE_LANGUAGE="ru"
export RUST_BACKTRACE='full'
export PYTHON_KEYRING_BACKEND='keyring.backends.null.Keyring'
export __GL_THREADED_OPTIMIZATIONS='0'

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

# Установка режима клавиатуры (эмаксовский)
bindkey -e

# Привязки клавиш
bindkey '\e[1;5C' forward-word      # Ctrl+Right Arrow
bindkey '\e[1;5D' backward-word     # Ctrl+Left Arrow

# Автодополнение
autoload -Uz compinit
compinit

# Prompt
autoload -Uz promptinit
promptinit

# Настройка FZF
if command -v fd > /dev/null; then
    export FZF_ALT_C_COMMAND="fd --type d"
    export FZF_DEFAULT_COMMAND="fd --type f"
    export FZF_PREVIEW_DIR_CMD="ls -l --color=always"
    export FZF_PREVIEW_FILE_CMD="cat -n"
    export FZF_FD_OPTS="--hidden --exclude=.git"
fi

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
hikary-update-all() {
    tmpfile=$(mktemp -p /tmp/)
    rate-mirrors --save="$tmpfile" artix

    if [ -e "$tmpfile" ]; then
        doas mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup
        doas mv "$tmpfile" /etc/pacman.d/mirrorlist
        if [ $? -eq 0 ]; then
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

# Zinit
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    echo "Installing Zinit..."
    mkdir -p "$HOME/.local/share/zinit" && chmod g-rwX "$HOME/.local/share/zinit"
    git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
source ~/.config/zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh

# Zinit плагины
zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-history-substring-search
zinit light hlissner/zsh-autopair

# Настройка fzf-tab
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi"
zstyle ':fzf-tab:*' fzf-command fzf
zstyle ':fzf-tab:*' fzf-preview 'bat --color=always --style=numbers --line-range=:500 {}'
zstyle ':fzf-tab:*' fzf-pad 4

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

auto_activate_venv() {
  if [[ -d .venv ]]; then
    if [[ ! -n "${VIRTUAL_ENV}" ]]; then
      echo "Activating virtual environment..."
      source .venv/bin/activate
    fi
  else
    if [[ -n "${VIRTUAL_ENV}" ]]; then
      if [[ "${VIRTUAL_ENV}" == *"$(pwd)/.venv"* ]]; then
        echo "Deactivating virtual environment..."
        deactivate
      fi
    fi
  fi
}

# Добавляем функцию в хук изменения директории
autoload -Uz add-zsh-hook
add-zsh-hook chpwd auto_activate_venv

# Выполняем проверку при запуске оболочки
auto_activate_venv
