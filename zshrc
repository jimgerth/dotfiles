alias c="conda"
alias f="flutter"
alias g="git"

alias ll="ls -lph"
alias la="ls -Alph"

eval "$(/opt/homebrew/bin/brew shellenv)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export PATH="$PATH:/Users/jimgerth/Developer/flutter/bin"
export PATH="$PATH:/Users/jimgerth/.gem/ruby/2.7.0/bin"
export PATH="/opt/homebrew/opt/ruby@2.7/bin:$PATH"

# Enable autocompletion, especially for git.
autoload -Uz compinit && compinit
