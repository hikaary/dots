# ===== Environment Variables =====
set -gx TERM xterm-256color
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PYTHON_KEYRING_BACKEND keyring.backends.null.Keyring
set -gx __GL_THREADED_OPTIMIZATIONS 0

# ===== FZF Configuration =====
if command -q fd
    set -gx FZF_ALT_C_COMMAND "fd --type d"
    set -gx FZF_DEFAULT_COMMAND "fd --type f"
    set -gx fzf_preview_dir_cmd "g --icon -no-total-size --time --size --title --owner"
    set -gx fzf_preview_file_cmd "cat -n"
    set -gx fzf_fd_opts "--hidden --exclude=.git"
end

# ===== Aliases =====
alias v nvim
alias lg lazygit
alias ta 'tmux attach'
alias ld lazydocker
alias s doas
alias t bpytop
alias ch 'cd ~'
alias .. 'cd ..'
alias ... 'cd ../..'
alias .3 'cd ../../..'
alias .4 'cd ../../../..'
alias .5 'cd ../../../../..'

if command -q g
    alias l 'g --icon -no-total-size --time --size --title --owner'
    alias lh 'g --icon -no-total-size --time --size --title -show-hidden --owner'
else
    alias l 'ls -lh'
    alias lh 'ls -lhA'
end

alias hikary-drop-caches='sudo paccache -rk3; yay -Sc --aur --noconfirm'
alias x='xxh +s fish'

function hikary-update-all
    set -l TMPFILE (mktemp)
    sudo true
    rate-mirrors --save=$TMPFILE artix \
    && sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup \
    && sudo mv $TMPFILE /etc/pacman.d/mirrorlist \
    && hikary-drop-caches \
    && yay -Syyu --noconfirm
end

# ===== Abbreviations =====
if status --is-interactive
    abbr -a -g d dirs
    abbr -a -g h 'cd $HOME'
    abbr -a -g m micro
    abbr -a -g ytmp3 'youtube-dl --extract-audio --audio-format mp3'
    abbr -a -g cls clear
    abbr -a -g h history
    abbr -a -g upd 'yay -Syu --noconfirm'
    abbr -a -g stahp 'shutdown now'
    abbr -a -g ar 'echo "awesome.restart()" | awesome-client'
    abbr -a -g shinei 'kill -9'
    abbr -a -g kv 'kill -9 (pgrep vlc)'
    abbr -a -g priv 'fish --private'
    abbr -a -g sshon 'sudo systemctl start sshd.service'
    abbr -a -g sshoff 'sudo systemctl stop sshd.service'
    abbr -a -g untar 'tar -zxvf'
    abbr -a -g genpass 'openssl rand -base64 20'
    abbr -a -g sha 'shasum -a 256'
    abbr -a -g cn 'ping -c 5 8.8.8.8'
    abbr -a -g ipe 'curl ifconfig.co'
    abbr -a -g ips 'ip link show'
    abbr -a -g wloff 'rfkill block wlan'
    abbr -a -g wlon 'rfkill unblock wlan'
end

# ===== Key Bindings =====
bind \cH backward-kill-path-component
bind \cq 'clear; commandline -f repaint'

# Vi mode key bindings
if [ "$fish_key_bindings" = fish_vi_key_bindings ]
    bind -Minsert ! __history_previous_command
    bind -Minsert '$' __history_previous_command_arguments
else
    bind ! __history_previous_command
    bind '$' __history_previous_command_arguments
end

# ===== Functions =====
function ex --description "Expand or extract bundled & compressed files"
    set --local ext (echo $argv[1] | awk -F. '{print $NF}')
    switch $ext
        case tar  # non-compressed, just bundled
            tar -xvf $argv[1]
        case gz
            if test (echo $argv[1] | awk -F. '{print $(NF-1)}') = tar  # tar bundle compressed with gzip
                tar -zxvf $argv[1]
            else  # single gzip
                gunzip $argv[1]
            end
        case tgz  # same as tar.gz
            tar -zxvf $argv[1]
        case bz2  # tar compressed with bzip2
            tar -jxvf $argv[1]
        case rar
            unrar x $argv[1]
        case zip
            unzip $argv[1]
        case 7z
            7zz x $argv[1]
        case '*'
            echo "unknown extension"
    end
end

function load_env --description 'Load environment variables from a .env file'
    set -l env_file_path $argv[1]
    test -z "$env_file_path"; and set env_file_path ".env"

    if test -f $env_file_path
        for line in (cat $env_file_path)
            set -l key_value (string split "=" $line)
            if test (count $key_value) -gt 1
                if string match -qr "^[a-zA-Z_]" -- $key_value[1]
                    set -l trimmed_value (string trim -c \'\" $key_value[2])
                    set -gx $key_value[1] $trimmed_value
                    echo "Loaded: $key_value[1]=$trimmed_value"
                end
            end
        end
    else
        echo "The file $env_file_path does not exist."
    end
end

function su
    command su --shell=/usr/bin/fish $argv
end

function __history_previous_command
    switch (commandline -t)
        case "!"
            commandline -t $history[1]
            commandline -f repaint
        case "*"
            commandline -i !
    end
end

function __history_previous_command_arguments
    switch (commandline -t)
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end

function backup --argument filename
    cp $filename $filename.bak
end

# ===== Startup Commands =====
set fish_greeting  # Disable greeting

# Check if starship is installed before running it
if command -q starship
    starship init fish | source
end

# Set up D-Bus only if it's installed
if command -q dbus-launch
    set dbus_data (dbus-launch --sh-syntax)
    for line in $dbus_data
        set line (string replace 'export ' '' $line)
        set line (string trim -c ';' $line)
        set line (string replace "'" '' $line)
        set line (string replace "'" '' $line)
        set -l key (echo $line | cut -d'=' -f1)
        set -l value (echo $line | cut -d'=' -f2- | string trim -c ';')
        if not test $value = DBUS_SESSION_BUS_ADDRESS
            set -gx $key $value
        end
    end
end

# Set PYENV_ROOT only if pyenv is installed
if command -q pyenv
    set -gx PYENV_ROOT $HOME/.pyenv
    fish_add_path $PYENV_ROOT/bin
    pyenv init - | source
end
