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
alias ln="ln -i"

alias mkdir="mkdir -p"

# Python
alias python="python3"
alias pip="pip3"
alias mkenv="virtualenv ./venv"
alias startenv="source ./venv/bin/activate"
alias stopenv="deactivate"

alias sqlite="sqlite3"

# Misc.
alias myip="curl ifconfig.me; echo"
alias usage="du -h -d1"
alias wttr="curl wttr.in"
alias ff="fastfetch"

if [[ $(uname) == 'darwin' ]]; then
	  alias history="history 1"

    # Use GNU sed on Mac
    alias sed="gsed"

    alias Photos="$HOME/Pictures/"
    alias Videos="$HOME/Movies/"

    alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
    export PATH=${PATH}:/usr/local/mysql-9.5.0-macos15-arm64/bin
fi

eval $(thefuck --alias)

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

eval "$(zoxide init zsh)"

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

source $HOME/.oh-my-zsh/custom/plugins/zsh-histdb/sqlite-history.zsh
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

eval "$(starship init zsh)"
