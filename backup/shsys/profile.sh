#!/bin/sh
# shellcheck disable=SC3044,SC2046

#
# System-wide .profile for sh(1)

: "${__PROFILE_D_SOURCED=0}"; export __PROFILE_D_SOURCED
: "${__RC_D_SOURCED=0}"; export __RC_D_SOURCED

if test $__PROFILE_D_SOURCED -eq 0; then
  __PROFILE_D_SOURCED=1

  export GIT_COMPLETION_SHOW_ALL="1"
  export GIT_COMPLETION_SHOW_ALL_COMMANDS="1"
  export HOMEBREW_BAT=1
  export HOMEBREW_NO_ENV_HINTS=1
  export LESS_TERMCAP_mb='\e[1;32m'
  export LESS_TERMCAP_md='\e[1;32m'
  export LESS_TERMCAP_me='\e[0m'
  export LESS_TERMCAP_se='\e[0m'
  export LESS_TERMCAP_so='\e[01;33m'
  export LESS_TERMCAP_ue='\e[0m'
  export LESS_TERMCAP_us='\e[1;4;31m'
  export PAGER=less
  export PYTHONDONTWRITEBYTECODE=1
  SUDO="$(command -v sudo)"; export SUDO

  has() { command -v "$1" >/dev/null; }
  rebash() { . /etc/profile; }

  i="$(command -v bash)"
  [ ! "${i-}" ] || [ "${SHELL-}" = "$(command -v bash)" ] || [ "${USER}" = "root" ] \
    || { ${SUDO} chsh -s "${i}" "${USER}" 2>/dev/null; ${SUDO} chsh -s "${i}" root 2>/dev/null; }

  i="unset BASH_ENV; export ENV=\"$(command -v "profile.sh")\"; . \"\${ENV}\"; export BASH_ENV=\"\${ENV}\""
  grep -q "^${i}$" /etc/profile || echo "${i}" | ${SUDO} tee /etc/profile

  dirs="/py /Users/Shared/py /opt /home/linuxbrew/.linuxbrew/bin/brew /usr/local \
/Library/Developer/CommandLineTools/usr /usr /"

  unset INFOPATH MANPATH PATH
  for i in ${dirs}; do
    if test -d "${i}"; then
      [ ! "${i}" != "/" ] || i=""
      ! test -d "${i}/bin" || PATH="${i}/bin${PATH:+:${PATH}}"
      ! test -d "${i}/sbin" || PATH="${i}/sbin${PATH:+:${PATH}}"
      ! test -d "${i}/share/man" || MANPATH="${i}/share/man${MANPATH:+:${MANPATH}}"
      ! test -d "${i}/share/info" || { INFOPATH="${i}/share/info${INFOPATH:+:${INFOPATH}}"; export INFOPATH; }
      ! test -d "${i}/etc" || etc="${i}/etc${etc:+ ${etc}}"
    fi
  done
  [ ! "${MANPATH-}" ] || export MANPATH="${MANPATH:+${MANPATH}:}"
  export PATH

  ! has autoload || has bashcompinit || { autoload -U +X bashcompinit && bashcompinit; }

  for i in ${etc}; do
    dir="${i}/profile.d"
    if test -d "${dir}"; then
      if test -n "$(find "${dir}" \( -type f -o -type l \) -name ".sh" -print -quit)"; then
        for j in "${dir}"/*.sh; do
          . "${j}" || return
        done
      fi
    fi
  done

  [ ! "${GH_TOKEN-}" ] || has secrets.sh >/dev/null || . secrets.sh
fi
unset i j dir dirs

! has shell.sh || . shell.sh

{ { [ "${PS1-}" ] || echo $- | command grep -q i; } && test $__RC_D_SOURCED -eq 0; } || return 0
__RC_D_SOURCED=1

has _init_completion || ! test -f /usr/share/bash-completion/bash_completion \
  || . /usr/share/bash-completion/bash_completion

for i in ${etc}; do
  dir="${i}/bash_completion.d"
  if test -d "${dir}" && has complete && has _init_completion \
    && test -n "$(find "${dir}" \( -type f -o -type l \) -print -quit)"; then
    if ! complete -p | grep -q "$(find "${dir}" -type f -o -type l -print0 -quit | xargs grep "^complete -F ")"; then
      for j in "${dir}"/*; do
        . "${j}" || return
      done
    fi
  fi

  ! has git || ! has complete || has __git_complete \
    || . "$(git --exec-path)/../../etc/bash_completion.d/git-completion.bash"

  dir="${i}/rc.d"
  if test -d "${dir}"; then
    if test -n "$(find "${dir}" \( -type f -o -type l \) -name ".sh" -print -quit)"; then
      for j in "${dir}"/*.sh; do
        . "${j}" || return
      done
    fi
  fi
done

! has declare || ! has compgen || declare -fx $(compgen -A function)

unset i j dir etc
