# .zshrc - Zsh configuration file

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE

# General zsh options
setopt AUTO_CD              # cd by typing directory name if it's not a command
setopt CORRECT_ALL          # autocorrect commands
setopt AUTO_LIST            # automatically list choices on ambiguous completion
setopt AUTO_MENU            # automatically use menu completion
setopt ALWAYS_TO_END        # move cursor to end if word had one match
setopt COMPLETE_IN_WORD     # allow completion from within a word/phrase
setopt PROMPT_SUBST         # enable parameter expansion in prompts

# Key bindings (emacs style)
bindkey -e

# Enable completion system
autoload -Uz compinit
compinit

# Completion styling
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Simple prompt (customize as needed)
PROMPT='%F{blue}%~%f %F{green}❯%f '
RPROMPT='%F{yellow}%D{%H:%M}%f'

# Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
alias gb='git branch'
alias gco='git checkout'
alias gd='git diff'

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# System aliases
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ps='ps aux'
alias top='htop'
alias ls='exa'
alias cat='bat'

# Arch Linux specific aliases
alias pacman='sudo pacman'
alias pac='sudo pacman -S'         # Install package
alias pacu='sudo pacman -Syu'      # Update system
alias pacr='sudo pacman -R'        # Remove package
alias pacrs='sudo pacman -Rs'      # Remove package with dependencies
alias pacq='pacman -Q'             # Query installed packages
alias pacqs='pacman -Qs'           # Search installed packages
alias pacss='pacman -Ss'           # Search repositories
alias pacsi='pacman -Si'           # Show package info
alias pacqi='pacman -Qi'           # Show installed package info
alias paccache='sudo paccache -r'  # Clear package cache
alias orphans='sudo pacman -Rns $(pacman -Qtdq)' # Remove orphaned packages

# AUR helper aliases (uncomment if you use yay or paru)
# alias y='yay'
alias ys='yay -S'
# alias yss='yay -Ss'
# alias yyu='yay -Syu'

# Safety aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Functions
# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract various archive types
extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Quick find function
ff() {
    find . -type f -name "*$1*"
}

# Environment variables
#export EDITOR=lvim
#export VISUAL=lvim
# Change as a your preferences
export EDITOR=vim
export VISUAL=vim
export PAGER=less
export LESS='-R'

# Add local bin to PATH if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Load additional configurations if they exist
[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases
[ -f ~/.zsh_local ] && source ~/.zsh_local

# Plugin management (uncomment if you want to use Oh My Zsh)
# export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="robbyrussell"
# plugins=(git colored-man-pages command-not-found)
# source $ZSH/oh-my-zsh.sh

# Load syntax highlighting if available (Arch Linux paths)
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Load autosuggestions if available (Arch Linux paths)
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi