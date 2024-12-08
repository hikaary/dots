#!/bin/zsh

alias v='mgraftcp --socks5 127.0.0.1:2080 nvim'
alias zed='mgraftcp --socks5 127.0.0.1:2080 zeditor'
alias restart-foot='pkill -f "foot-server" && riverctl spawn "foot --server"'
alias px='proxychains4 -q'
alias proxy='mgraftcp --socks5 127.0.0.1:2080'
alias kvnt_db_test='rainfrog --url $(cat ~/creds/kvant_test_db_url)'
alias kvnt_db_email='rainfrog --url $(cat ~/creds/kvant_email_db_url)'
alias lg='gitu'
alias ta='tmux attach'
alias ..='cd ..'
alias ld='oxker'
alias s='sudo'
alias cd='z'
alias music='mgraftcp --socks5 127.0.0.1:2080 spotify_player'
alias vs='source .venv/bin/activate'
alias l='eza -lah --icons=auto --hyperlink'
alias tree='eza --tree --level=2 --icons'
alias csv-view='csvlens'
alias parse_dir="repomix --ignore '*.lock,docs/*,.git/*,.idea/*,.vscode/*,__pycache__'"
