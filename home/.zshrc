# Amazon Q pre block. Keep at the top of this file.
if [ "$TERM_PROGRAM" != "WarpTerminal" ]; then
	[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"
fi

# aliases
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias ls='eza --icons=auto --group-directories-first'
alias la='ls -la'
alias lt='ls -T'

# homebrew
BREW_PREFIX=$(brew --prefix)
export PATH="/opt/homebrew/bin:$PATH"

# java jdk
# export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))
# export PATH=$JAVA_HOME/bin:$PATH

# Sketchybar interactivity overloads
function brew() {
  command brew "$@"

  if [[ $* =~ "upgrade" ]] || [[ $* =~ "update" ]] || [[ $* =~ "outdated" ]]; then
    sketchybar --trigger brew_update
  fi
}

# oh my post
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
	eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/config.omp.json)"
else
	eval "$(oh-my-posh init zsh --config $BREW_PREFIX/opt/oh-my-posh/themes/catppuccin_mocha.omp.json)"
fi

# pnpm
export PNPM_HOME="/Users/frog/Library/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# zsh-fast-syntax-highlighting
source $BREW_PREFIX/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Amazon Q post block. Keep at the bottom of this file.
if [ "$TERM_PROGRAM" != "WarpTerminal" ]; then
	[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
fi
