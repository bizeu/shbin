# shellcheck disable=SC2046
# System-wide .profile for sh(1)

export HOMEBREW_PREFIX="/usr/local"

# This is to keep $PATH from binsh.app first, $PATH is not set
case ":${PATH}:" in
  *:/usr/local/bin:*) : ;;
  *)
    export PATH="${HOMEBREW_PREFIX}/bin:/usr/bin:/bin:/usr/sbin:/sbin"
    ! command -v pyenv >/dev/null || eval "$(pyenv init --path)"
    sudo chsh -s "${HOMEBREW_PREFIX}/bin/bash" j5pu &>/dev/null
    sudo chsh -s "${HOMEBREW_PREFIX}/bin/bash" root &>/dev/null
    ;;
esac

if [ ! "${CONFIGS-}" ]; then
  export BASH_SILENCE_DEPRECATION_WARNING=1
  export CONFIGS="/Users/j5pu/shrc/etc/config"
  export HOMEBREW_CELLAR="${HOMEBREW_PREFIX}/Cellar"
  export HOMEBREW_NO_ANALYTICS=1
  export HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}/Homebrew"
  export MANPATH="${HOMEBREW_PREFIX}/share/man${MANPATH+:$MANPATH}:"
  export INFOPATH="${HOMEBREW_PREFIX}/info:${INFOPATH:-}"
  export DIRENV_CONFIG="${CONFIGS}/direnv"
  export GIT_COMPLETION_SHOW_ALL="1"
  export GIT_COMPLETION_SHOW_ALL_COMMANDS="1"
  export JETBRAINS="${HOME}/JetBrains"
  export LESS_TERMCAP_mb=$'\e[1;32m'
  export LESS_TERMCAP_md=$'\e[1;32m'
  export LESS_TERMCAP_me=$'\e[0m'
  export LESS_TERMCAP_se=$'\e[0m'
  export LESS_TERMCAP_so=$'\e[01;33m'
  export LESS_TERMCAP_ue=$'\e[0m'
  export LESS_TERMCAP_us=$'\e[1;4;31m'
  export HOMEBREW_BAT=1
  export HOMEBREW_NO_ENV_HINTS=1
  export INPUTRC="${CONFIGS}/readline/inputrc"
  export PAGER=less
  export PROMPT_COMMAND="history -a; history -c; history -r"
  export PYCHARM_CONFIG="${JETBRAINS}/config/PyCharm"
  export PYCHARM_PROPERTIES="${PYCHARM_CONFIG}/.properties"; launchctl setenv PYCHARM_PROPERTIES "${PYCHARM_PROPERTIES}"
  export PYCHARM_VM_OPTIONS="${PYCHARM_CONFIG}/.vmoptions"; launchctl setenv PYCHARM_VM_OPTIONS "${PYCHARM_VM_OPTIONS}"
  export PYTHONDONTWRITEBYTECODE=1
  export STARSHIP_CONFIG="${CONFIGS}/starship/config.toml"
  # Stow Directory
  # https://www.gnu.org/software/stow/manual/stow.html
  #
  export STOW_DIR

  ! test -f /Users/j5pu/secrets/bin/secrets.sh || . /Users/j5pu/secrets/bin/secrets.sh
  [ ! "${BASH_VERSINFO-}" ] || [ "${BASH_VERSINFO[0]:-0}" ] || shopt -s inherit_errexit
fi

[ "${PS1-}" ] || return 0

if ! alias l >/dev/null 2>&1; then
  alias l='ls -lah'
  alias la='ls -lAh'
  alias ll='ls -lh'
  alias ls='ls -G'
  alias lsa='ls -lah'
  alias allow='direnv allow'
  alias reload='direnv reload'
  ! command -v grc >/dev/null || GRC_ALIASES=true . "${HOMEBREW_PREFIX}/etc/grc.sh"
fi

! command -v rebash >/dev/null || return 0

#######################################
# rebash
# Arguments:
#  None
#######################################
rebash() { unset CONFIGS && unset -f rebash && . /etc/profile; }

set -o errtrace

if [ "${BASH_VERSINFO-}" ]; then
  shopt -s checkwinsize execfail histappend
  [ "${BASH_VERSINFO[0]:-0}" -lt 4 ] || shopt -s direxpand
  # eval "$(/Users/j5pu/binsh/backup/bats/shts/bin/envfile.sh hook)"
  # eval "$(direnv hook bash)"
  ! command -v pyenv >/dev/null || eval "$(pyenv init -)"
  ! command -v starship >/dev/null || eval "$(starship init bash)"
fi

! test -d "${HOMEBREW_PREFIX}/etc/profile.d" || for i in "${HOMEBREW_PREFIX}/etc/profile.d"/*; do
  . "${i}"
done; unset i

! command -v compgen >/dev/null || export -f $(compgen -A function)