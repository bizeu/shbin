#!/usr/bin/env bash

#
# Bash Utils Library

[ "${BASH_VERSION-}" ] || return 0 2>/dev/null || exit 0

#######################################
# export file or files functions
# Arguments:
#  None
#######################################
export_filefuncs() {
  # shellcheck disable=SC2046
  export -f $(filefuncs "$@")
}
