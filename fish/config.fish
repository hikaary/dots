if status is-interactive
    bind \cH backward-kill-path-component
    function ex --description "Expand or extract bundled & compressed files"
        set --local ext (echo $argv[1] | awk -F. '{print $NF}')
        switch $ext
            case tar # non-compressed, just bundled
                tar -xvf $argv[1]
            case gz
                if test (echo $argv[1] | awk -F. '{print $(NF-1)}') = tar # tar bundle compressed with gzip
                    tar -zxvf $argv[1]
                else # single gzip
                    gunzip $argv[1]
                end
            case tgz # same as tar.gz tar -zxvf $argv[1] case bz2  # tar compressed with bzip2
                tar -jxvf $argv[1]
            case rar
                unrar x $argv[1]
            case zip
                unzip $argv[1]
            case '*'
                echo "unknown extension"
        end
    end
end

function load_env --description 'Load environment variables from a .env file'
    set -l env_file_path $argv[1]
    if test -z "$env_file_path"
        set env_file_path ".env"
    end

    if test -f $env_file_path
        for line in (cat $env_file_path)
            set -l key_value (string split "=" $line)
            if count $key_value >1
                if string match -qr "^[a-zA-Z_]" -- $key_value[1]
                    set -l trimmed_value (string trim -c \'\" $key_value[2])
                    set -gx $key_value[1] $trimmed_value
                    echo "Loaded: "$key_value[1]"="$trimmed_value
                end
            end
        end
    else
        echo "The file "$env_file_path" does not exist."
    end
end

set TERM xterm-256color
set PYENV_ROOT "/home/hikary/.pyenv/"
set -gx EDITOR nvim
set FZF_ALT_C_COMMAND "fd --type d"
set FZF_DEFAULT_COMMAND "fd --type f"

alias v nvim
alias y yazi
alias zed zeditor
alias ta 'tmux attach'
alias cat gat
alias s doas
alias t bpytop
alias ch 'cd ~/'
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias hikary-drop-caches='sudo paccache -rk3; yay -Sc --aur --noconfirm'
alias hikary-update-all='export TMPFILE="$(mktemp)"; \
    sudo true; \
    rate-mirrors --save=$TMPFILE artix \
      && sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup \
      && sudo mv $TMPFILE /etc/pacman.d/mirrorlist \
      && hikary-drop-caches \
      && yay -Syyu --noconfirm'
alias l 'g --icon -no-total-size --time --size --title --owner'
alias lh 'g --icon -no-total-size --time --size --title -show-hidden --owner'

set TARGET_SESSION dev
set ZELLIJ_LAYOUTS "$HOME/.config/zellij/layout.kdl"
alias zj 'zellij --layout $ZELLIJ_LAYOUTS attach -c $TARGET_SESSION options --theme catppuccin-mocha'

bind \cq 'clear; commandline -f repaint'

# Directory abbreviations
abbr -a -g d dirs
abbr -a -g h 'cd $HOME'
abbr -a -g m micro

# User abbreviations
abbr -a -g ytmp3 'youtube-dl --extract-audio --audio-format mp3' # Convert/Download YT videos as mp3
abbr -a -g cls clear # Clear
abbr -a -g h history # Show history
abbr -a -g upd 'yay -Syu --noconfirm' # Rude way to sudo																	# Epic way to shutdown
abbr -a -g stahp 'shutdown now' # Panik - stonk man
abbr -a -g ar 'echo "awesome.restart()" | awesome-client' # Reload AwesomeWM
abbr -a -g shinei 'kill -9' # Kill ala DIO
abbr -a -g kv 'kill -9 (pgrep vlc)' # Kill zombie vlc
abbr -a -g priv 'fish --private' # Fish incognito mode
abbr -a -g sshon 'sudo systemctl start sshd.service' # Start ssh service
abbr -a -g sshoff 'sudo systemctl stop sshd.service' # Stop ssh service
abbr -a -g untar 'tar -zxvf' # Untar
abbr -a -g genpass 'openssl rand -base64 20' # Generate a random, 20-charactered password
abbr -a -g sha 'shasum -a 256' # Test checksum
abbr -a -g cn 'ping -c 5 8.8.8.8' # Ping google, checking network
abbr -a -g ipe 'curl ifconfig.co' # Get external IP address
abbr -a -g ips 'ip link show' # Get network interfaces information
abbr -a -g wloff 'rfkill block wlan' # Block wlan, killing wifi connection
abbr -a -g wlon 'rfkill unblock wlan' # Unblock wlan, start wifi connection
# Launch firefox

# Make su launch fish
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

# set fish_color_autosuggestion '#7d7d7d'
# set fish_color_command --bold brcyan
# set fish_color_error '#ff6c6b'
# set fish_color_param brwhite
# set fish_pager_color_selected_completion blue
set fish_greeting
set fzf_preview_dir_cmd g --icon -no-total-size --time --size --title --owner
set fzf_preview_file_cmd cat -n
set fzf_fd_opts --hidden --exclude=.git

if [ "$fish_key_bindings" = fish_vi_key_bindings ]
    bind -Minsert ! __history_previous_command
    bind -Minsert '$' __history_previous_command_arguments
else
    bind ! __history_previous_command
    bind '$' __history_previous_command_arguments
end

# Function for creating a backup file
# ex: backup file.txt
# result: copies file as file.txt.bak
function backup --argument filename
    cp $filename $filename.bak
end


export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring
export __GL_THREADED_OPTIMIZATIONS=0
export VISUAL="nvim"
export EDITOR=nvim

starship init fish | source
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

fish_add_path /home/hikary/.spicetify
