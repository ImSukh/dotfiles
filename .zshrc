# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set theme - using powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment to use hyphen-insensitive completion
# HYPHEN_INSENSITIVE="true"

# How often to auto-update (in days)
# zstyle ':omz:update' frequency 14

# Enable command auto-correction
ENABLE_CORRECTION="true"

# Display red dots whilst waiting for completion
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# History format
HIST_STAMPS="yyyy-mm-dd"

# Plugins
plugins=(
  git
  macos
  docker
  docker-compose
  npm
  node
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='code'
fi

# Custom aliases
alias zshconfig="code ~/.zshrc"
alias ohmyzsh="code ~/.oh-my-zsh"
alias ll="ls -la"
alias c="clear"
alias gs="git status"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"

# Node.js environment setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Add your custom paths here
export PATH="$HOME/.local/bin:$PATH"

# Custom functions
# Enable working directory in new terminal tabs
function precmd() {
  [[ -t 1 ]] || return
  echo -n "\033]1;${PWD##*/}\007"
  echo -n "\033]2;${PWD}\007"
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh