# System-wide .profile for sh(1)

[ "${__etc_profile_sourced:-0}" -eq 0 ] || return 0
__etc_profile_sourced=1

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

eval "$(brew shellenv)"
sudo chsh -s "${HOMEBREW_PREFIX}/bin/bash" j5pu &>/dev/null
sudo chsh -s "${HOMEBREW_PREFIX}/bin/bash" root &>/dev/null
export HOMEBREW_NO_ENV_HINTS=1
! test -f /Users/j5pu/secrets/bin/secrets.sh || . /Users/j5pu/secrets/bin/secrets.sh

[ "${PS1-}" ] || return 0
alias ltedit="/Users/j5pu/JetBrains/Applications/PyCharm.app/Contents/bin/ltedit.sh"
export DIRENV_CONFIG="/Users/j5pu/shrc/etc/config/direnv"
export GIT_COMPLETION_SHOW_ALL="1" 
export GIT_COMPLETION_SHOW_ALL_COMMANDS="1"
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'
export HOMEBREW_BAT=1
export INPUTRC="/Users/j5pu/shenv/src/shenv/etc/config/readline/inputrc"
export PAGER=less
export PROMPT_COMMAND="history -a; history -c; history -r"
export PYTHONDONTWRITEBYTECODE=1
export STARSHIP_CONFIG="/Users/j5pu/shrc/etc/config/starship/config.toml"

alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias ls='ls -G'
alias lsa='ls -lah'

set -o errtrace
shopt -s checkwinsize direxpand execfail histappend
shopt -s inherit_errexit

for i in "${HOMEBREW_PREFIX}/etc/profile.d"/*; do
  . "${i}"
done; unset i
. "${HOMEBREW_PREFIX}/etc/grc.sh"

eval "$(/Users/j5pu/shts/bin/envfile.sh hook)"
# eval "$(direnv hook bash)" 
# eval "$(cat /Users/j5pu/shts/bin/direnv.sh)"
alias allow='direnv allow' && alias reload='direnv reload'
eval "$(pyenv init -)"
eval "$(pyenv init --path)"
eval "$(starship init bash)"

#######################################
# rebash
# Arguments:
#  None
#######################################
rebash() { __etc_profile_sourced=0 . /etc/profile; }
