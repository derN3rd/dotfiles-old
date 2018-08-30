if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
    exec xinit
fi

source ~/.dotfiles/.index

export ZSH=$HOME/.config/oh-my-zsh
DEFAULT_USER=$USER

plugins=(git copydir copyfile extract gitignore history-substring-search)
source $ZSH/oh-my-zsh.sh

PROMPT="
$HOST:%B%{$fg[cyan]%}%~%b "

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

source ~/.dotfiles/.sshAgent

export PATH=~/.local/bin:$PATH
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/extras/CUPTI/lib64 
export PATH="$PATH:$HOME/bin"

