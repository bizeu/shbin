# shellcheck shell=bash

#######################################
# source completions
# Globals:
#   COMPREPLY
# Arguments:
#   1     name of the command whose arguments are being completed
#   2     word being completed ("cur")
#   3     word preceding the word being completed or $1 when is the first word ("prev")
#######################################
_source() {
  [ "$1" = "$3" ] || return 0
  local brew i lines reply=()

  for i in .env .envrc /etc/profile /etc/bashrc /etc/bash.bashrc \
    "${HOME}/.profile" "${HOME}/.bash_profile" "${HOME}/.bashrc" \
    /usr/share/bash-completion/bash_completion \
    "$(realpath "$(git --exec-path 2>/dev/null)/../../etc/bash_completion.d/git-completion.bash")" \
    ; do
    [ ! -f "${i}" ] || reply+=("${i}")
  done

  ! hascmd brew || brew="$(brew --prefix)/etc"

  while read -r i; do
    [ -d "${i}" ] || continue
    mapfile -t lines < <(sudo find "${i}" \( -type f -o -type l \) -not \( -name "*.fish" -o -name "*.zsh" \))
    [ ! "${lines-}" ] || reply+=("${lines[@]}")
  done < <(printf '%s\n' "/etc/profile.d" "${brew}/profile.d" "${brew}/rc.d /usr/local/etc/profile.d" \
    "/usr/local/etc/rc.d" | uniq)

  while read -r i; do
    [ -d "${i}" ] || continue
    mapfile -t lines < <(sudo find "${i}" \( -type f -o -type l \) \( -name "*.sh" -o -name "*.bash" \) \
                                    -exec basename "{}" \;)
    [ ! "${lines-}" ] || reply+=("${lines[@]}")
  done < <(tr ':' '\n' <<< "${PATH}" | uniq)

  mapfile -t COMPREPLY < <(compgen -o default -o dirnames -o filenames \
                                   -W "$(sed "s|$(pwd)/||g; s|${HOME}|~|g" <<< "${reply[*]}")" -- "$2")
}

complete -F _source source
complete -F _source .
