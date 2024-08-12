mkdir ~/.cache/zoxide
zoxide init nushell
  | str replace --all "-- $rest" "-- ...$rest" 
  | str replace "--interactive -- $rest" "--interactive -- ...$rest" 
  | save -f ~/.cache/zoxide/init.nu

mkdir ~/.cache/starship
starship init nu 
    | str replace "term size -c" "term size" 
    | str replace --all "let-env " "$env." 
    | save -f ~/.cache/starship/init.nu

mkdir ~/.cache/atuin
atuin init nu --disable-up-arrow 
    | save -f ~/.cache/atuin/init.nu

mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
