#!/bin/sh

#
# Posix Utils Library

#######################################
# has alias, command or function
# Arguments:
#   1   alias, command or function name
#######################################
has() { command -v "$1" >/dev/null; }

#######################################
# remove duplicates from $PATH
# Globals:
#   PATH
# Arguments:
#  None
#######################################
path_dedup() { PATH="$(echo "${PATH}" | tr ':' '\n' | uniq | tr '\n' ':' | sed 's/:$//')"; }

#######################################
# add to $PATH if not already present
# Globals:
#   PATH
# Arguments:
#   1   path to add
#######################################
path_add() { path_in "$1"; PATH="$1:${PATH:-:${PATH}}"; }

#######################################
# add to $PATH if not already present and directory exists
# Arguments:
#   1   path to add
#######################################
path_add_exist() { [ ! -d "$1" ] || path_add "$1"; }

#######################################
# append to $PATH if not already present
# Globals:
#   PATH
# Arguments:
#   1   path to append
#######################################
path_append() { path_in "$1"; PATH="${PATH:-${PATH}:}$1"; }

#######################################
# append to $PATH if not already present and directory exists
# Arguments:
#   1   path to append
#######################################
path_append_exists() { [ ! -d "$1" ] || path_append "$1"; }

#######################################
# is path in $PATH
# Globals:
#   PATH
# Arguments:
#   1   path to check
# Returns:
#   1 if in path, 0 if not
#######################################
path_in() {
  case ":${PATH}:" in
    *:"$1":*) return 0 ;;
    *) return 1 ;;
  esac
}

#######################################
# change to git repository top path
# Arguments:
#  None
# Returns:
#   1 if not git repository
#######################################
top_cd() {
  # Git Repository Top Path if Exists
  #
  TOP_CD=""
  if TOP_CD="$(git rev-parse --show-toplevel)"; then
    cd "${TOP_CD}" || return 1
    return
  fi
  return 1
}

#######################################
# change to git repository top path and exit if not git repository
# Arguments:
#  None
# Returns:
#   1 if not git repository (exit)
#######################################
top_cd_exit() { top_cd || exit; }
