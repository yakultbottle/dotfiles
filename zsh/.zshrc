# ==============================================================================
# ZSH Configuration
# ==============================================================================

# ==============================================================================
# profiler
# ==============================================================================
# zmodload zsh/zprof

# ==============================================================================
# zap plugin manager
# ==============================================================================
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "Aloxaf/fzf-tab"
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-syntax-highlighting"

# ==============================================================================
# History
# ==============================================================================
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS

# ==============================================================================
# Prompt
# ==============================================================================
# %F{...} sets the foreground color, %f resets it.
# %n is username (\u), %1~ is current directory (\W)
PROMPT='%F{114}%n%f:%F{209}%1~%f$ '

# ==============================================================================
# Editor
# ==============================================================================
export EDITOR=nvim
export VISUAL=nvim

# ==============================================================================
# Keybinds
# ==============================================================================
bindkey -e

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^P" up-line-or-beginning-search
bindkey "^N" down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up arrow
bindkey "^[[B" down-line-or-beginning-search # Down arrow

# Jump by word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# ==============================================================================
# Alias files and AOC
# ==============================================================================
if [ -f ~/.zsh_aliases ]; then
    source ~/.zsh_aliases
fi

if [ -f ~/projects/Advent-of-Code/alias ]; then
    source ~/projects/Advent-of-Code/alias
fi

# ==============================================================================
# Path and environment sourcing
# ==============================================================================
if [[ ":$PATH:" != *":/home/yakultbottle/Utils:"* ]]; then
    export PATH="$PATH:/home/yakultbottle/Utils"
fi

if [[ ":$PATH:" != *":/home/yakultbottle/.local/opt:"* ]]; then
    export PATH="$PATH:/home/yakultbottle/.local/opt"
fi

# source /home/yakultbottle/Xilinx/Vivado/2023.2/settings64.sh
. "$HOME/.cargo/env"
. "$HOME/.local/bin/env"

# ==============================================================================
# Zoxide
# ==============================================================================
eval "$(zoxide init zsh)"

autoload -Uz compinit
compinit -C

# zprof
