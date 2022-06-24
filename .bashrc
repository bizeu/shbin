# shellcheck shell=sh disable=SC2046
# System-wide .profile for sh(1)
start=$SECONDS

#echo start
#echo 0: "$(( SECONDS - start ))"

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

#echo 1: "$(( SECONDS - start ))"

if [ ! "${CONFIGS-}" ]; then
  export BASH_SILENCE_DEPRECATION_WARNING=1
  export BATS_NUMBER_OF_PARALLEL_JOBS=400
  export CONFIGS="/Users/j5pu/Archive/shrc/etc/config"
  export DOCKER_COMPLETION_SHOW_CONFIG_IDS=yes
  export DOCKER_COMPLETION_SHOW_CONTAINER_IDS=yes
  export DOCKER_COMPLETION_SHOW_NODE_IDS=yes
  export DOCKER_COMPLETION_SHOW_PLUGIN_IDS=yes
  export DOCKER_COMPLETION_SHOW_SECRET_IDS=yes
  export DOCKER_COMPLETION_SHOW_SERVICE_IDS=yes
  export DOCKER_COMPLETION_SHOW_IMAGE_IDS=all
  export DIRENV_CONFIG="${CONFIGS}/direnv"
  export DOCKER_COMPLETION_SHOW_TAGS=yes
  export GIT_COMPLETION_SHOW_ALL="1"
  export GIT_COMPLETION_SHOW_ALL_COMMANDS="1"
  export HOMEBREW_BAT=1
  export HOMEBREW_CELLAR="${HOMEBREW_PREFIX}/Cellar"
  export HOMEBREW_NO_ANALYTICS=1
  export HOMEBREW_NO_ENV_HINTS=1
  export HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}/Homebrew"
  export HOMEBREW_PRY=1
  export INFOPATH="${HOMEBREW_PREFIX}/info:${INFOPATH:-}"
  export INPUTRC="${CONFIGS}/readline/inputrc"
  export JETBRAINS="${HOME}/JetBrains"
  export LESS_TERMCAP_mb=$'\e[1;32m'
  export LESS_TERMCAP_md=$'\e[1;32m'
  export LESS_TERMCAP_me=$'\e[0m'
  export LESS_TERMCAP_se=$'\e[0m'
  export LESS_TERMCAP_so=$'\e[01;33m'
  export LESS_TERMCAP_ue=$'\e[0m'
  export LESS_TERMCAP_us=$'\e[1;4;31m'
  export MANPAGER=most
  export MANPATH="${HOMEBREW_PREFIX}/share/man${MANPATH+:$MANPATH}"
  export PAGER=less
  export PROMPT_COMMAND="history -a; history -c; history -r"
  export PYTHONDONTWRITEBYTECODE=1
  # export STARSHIP_CONFIG="${CONFIGS}/starship/config.toml"
  # Stow Directory
  # https://www.gnu.org/software/stow/manual/stow.html
  #
  export STOW_DIR

  ! test -f /Users/j5pu/Archive/secrets/bin/secrets.sh || . /Users/j5pu/Archive/secrets/bin/secrets.sh

  [ ! "${BASH_VERSINFO-}" ] || [ "${BASH_VERSINFO[0]:-0}" -lt 4 ] || shopt -s inherit_errexit
fi

#echo 2: "$(( SECONDS - start ))"

if [ ! "${PS1-}" ]; then
  set -o errtrace functrace
  return 0
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

#echo 3: "$(( SECONDS - start ))"

#######################################
# rebash
# Arguments:
#  None
#######################################
rebash() { unset CONFIGS && unset -f rebash && . /etc/profile; }

# No tiene sentido exportar las funciones si no se pueden exportar las shopt, además es un lío
# depende de la version de bash... no habría solución única
if [ "${BASH_VERSINFO-}" ]; then
  # https://www.digitalocean.com/community/tutorials/how-to-use-bash-history-commands-and-expansions-on-a-linux-vps
  # CTRL+R -> history search, and CTRL+S -> history search backward
  # $ sudo (I want know completions .. CTRL+A CTRL+R CTRL+Y ... CTRL+R
  stty -ixon
  # https://zwischenzugs.com/2019/04/03/eight-obscure-bash-options-you-might-want-to-know-about/
  # a tomar por culo el extglob que jode todo
  shopt -s autocd cdable_vars checkwinsize dotglob execfail histappend nocaseglob nocasematch
  [ "${BASH_VERSINFO[0]:-0}" -lt 4 ] || shopt -s direxpand dirspell globstar progcomp_alias
  # eval "$(/Users/j5pu/binsh/backup/bats/shts/bin/envfile.sh hook)"
  # eval "$(direnv hook bash)"
  ! command -v pyenv >/dev/null || eval "$(pyenv init -)"
  #######################################
  # description
  # Arguments:
  #  None
  # Returns:
  #   $__history_prompt_rc ...
  #######################################
  history_prompt() {
    local __history_prompt_rc=$?
    history -a; history -c; history -r; hash -r
    return $__history_prompt_rc
  }
  if command -v starship >/dev/null; then
#    export starship_precmd_user_func="history_prompt"  # starship_precmd
    eval "$(starship init bash)"
    export -f _starship_set_return
  fi
  export PROMPT_COMMAND="history_prompt${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
fi

#echo 4: "$(( SECONDS - start ))"

! test -d "${HOMEBREW_PREFIX}/etc/profile.d" || for i in "${HOMEBREW_PREFIX}/etc/profile.d"/*; do
  . "${i}"
done; unset i

#echo 5: "$(( SECONDS - start ))"
! command -v compgen >/dev/null || export -f $(compgen -A function | grep -v '^_')

#echo 6: "$(( SECONDS - start ))"

#echo return
