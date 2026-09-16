alias so="source"
alias s="source"

# neovim
alias nv="nvim"
alias vim="nvim"
alias vi="nvim"
alias v="nvim"

# ls
alias ls='lsd'
alias ll='ls -l'
alias l='ls -l'
alias la='ls -la'
alias lf="l $1 | fzf"

# Safety checks
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
alias ln="ln -si"

alias mkdir="mkdir -p"

# Python
alias python="python3"
alias pip="pip3"
alias mkenv="virtualenv ./venv"
alias startenv="source ./venv/bin/activate"
alias stopenv="deactivate"

alias sqlite="sqlite3"

# Tmux
alias tls="tmux ls"
alias tkill="tmux kill-session -t 0"

# Misc.
alias myip="curl ifconfig.me; echo"
alias usage="du -h -d1"
alias wttr="curl wttr.in"
alias ff="fastfetch"
alias smh="history | fzf"

if [[ $(uname) == 'darwin' ]]; then
	  alias history="history 1"

    # Use GNU sed on Mac
    alias sed="gsed"

    alias Photos="$HOME/Pictures/"
    alias Videos="$HOME/Movies/"

    alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
    export PATH=${PATH}:/usr/local/mysql-9.5.0-macos15-arm64/bin
fi

export EDITOR="/usr/bin/nvim"

eval $(thefuck --alias)

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

eval "$(zoxide init zsh)"

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

autoload -Uz add-zsh-hook
HISTDB_TABULATE_CMD=(sed -e $'s/\x1f/\t/g')

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
chruby ruby-3.4.1

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

. "$HOME/.local/bin/env"
export PATH="$HOME/.cargo/bin:$PATH"

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
