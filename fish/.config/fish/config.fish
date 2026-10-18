#aliases 
alias so="source"
alias nv="nvim"
alias nano="nvim"
alias ls="lsd"
alias l="lsd -l"
alias la="lsd -la"
alias python="python3"
alias pip="pip3"

# colors
set fish_color_command green
set fish_color_error red
set fish_color_qoute yellow
set fish_color_user blue 
set fish_color_host blue 
set fish_color_cwd green 

set -x THEFUCK_OVERRIDDEN_ALIASES 'gsed,git'

fish_add_path $HOME/.local/bin

fish_add_path $HOME/.opencode/bin

set -gx EDITOR nvim

# set -gx PATH $PATH /Users/dion/.opencode/bin:$PATH

if status is-interactive
    set -g fish_greeting

    abbr --add gs 'git status'
    abbr --add gc 'git commit'
    abbr --add gp 'git push'
end

zoxide init fish | source
thefuck --alias | source
