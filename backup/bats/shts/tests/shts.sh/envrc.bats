#!/usr/bin/env bats

setup_file() { load ../helpers/helper; }

@test "\$PATH " {
  run echo "${PATH}"
  assert_output --regexp ".*${SHTS_TOP}/bin:.*"
}

@test "\$PROJECT_DIR " {
  assert_equal "${PROJECT_DIR}" "${SHTS_TOP}"
}

@test "envrc " {
  shts::run
  while read -r var; do
    assert [ -n "${!var}" ]
    run declare -p "${var}"
    assert_output --regexp "declare -x ${var}="
  done < <(awk -F '=' '/=/ { print $1 }' "${SHTS_TOP}/.env")
}
