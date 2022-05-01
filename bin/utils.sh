# shellcheck shell=sh

#
# Utils Library

# parses -h, --help and help arguments if help_spec is set, or shows help spec if $? is 1
help_spec() {
  rc=$?
  case "$1" in
    -h|--help|help) help_spec="${HELP_SPEC:?}" ;;
    --desc) help_spec="${DESC_SPEC:?}" ;;
    *) return 0 ;;
  esac
  echo "${help_spec:?}"
  exit $rc
}

#
# Remove Duplicates in $PATH
path_dedup() { PATH="$(echo "${PATH}" | tr ':' '\n' | uniq | tr '\n' ':' | sed 's/:$//')"; }

# Add to $PATH if not already present
path_add() { path_in "$1"; PATH="$1:${PATH:-:${PATH}}"; }

# Add to $PATH if not already present and directory exists
path_add_exist() { [ ! -d "$1" ] || path_add "$1"; }

# Append to $PATH if not already present
path_append() { path_in "$1"; PATH="${PATH:-${PATH}:}$1"; }

# Append to $PATH if not already present and directory exists
path_append_exists() { [ ! -d "$1" ] || path_append "$1"; }

# is in $PATH?
path_in() {
  case ":${PATH}:" in
    *:"$1":*) return 0 ;;
    *) return 1 ;;
  esac
}

# cd to git repository top path and return
top_cd() {
  if top_exit="$(git rev-parse --show-toplevel)"; then
    cd "${top_exit}" || return 1
    return
  fi
  return 1
}

# cd to git repository top path and exit
top_cd_exit() { top_cd || exit; }
