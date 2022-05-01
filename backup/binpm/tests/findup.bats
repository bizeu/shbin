#!/usr/bin/env bats
# shellcheck disable=SC2001

setup() {
  load helpers/test_helper
}

setup_file() {
  FIRST_DIR="$(tmp)/4/3/2/1"; export FIRST_DIR;  mkdir -p "${FIRST_DIR}"
  FIRST_FILE="$(tmp)/4/3/2/1/first"; export FIRST_FILE;  touch "${FIRST_FILE}"
  GIT_FILE="$(tmp)/4/3/2/.git"; export GIT_FILE;  touch "${GIT_FILE}"
  GIT_FIRST="$(tmp)/4/3"; export GIT_FIRST
  GIT_FIRST_GIT="$(tmp)/4/3/.git"; export GIT_FIRST_GIT;  mkdir -p "${GIT_FIRST_GIT}"
  GIT_TOP="$(tmp)/4"; export GIT_TOP
  GIT_TOP_GIT="$(tmp)/4/.git"; export GIT_TOP_GIT;  mkdir -p "${GIT_TOP_GIT}"
}

assertoutput() {
  os="${1:-macOS}"
  bats::description "${os}"
  cmd="${cmd:-${BATS_TEST_DESCRIPTION}}"
  if [ "${os}" = 'macOS' ]; then
    run sh -c "${cmd}"
  else
    run container "${os}" "sh -c '${cmd}'"
  fi

  if [ "${ERROR-0}" -eq 1 ]; then
    assert_failure
  else
    assert_success
  fi

  if [ "${CALLBACK-}" ]; then
    $(echo "${BATS_TEST_DESCRIPTION}" | sed 's/ /::/g') "${os}"
  else
    [ ! "${EXPECTED-}" ] || assert_output "${EXPECTED[@]}"
  fi
}

cmd() {
  assertoutput
  # FIXME: Images and docker container tests
  $BATS_LOCAL || for i in ${IMAGES}; do assertoutput "${i}"; done
}

strip() { echo "${1/\/\//\/}"; }

tmp() { strip "${BATS_FILE_TMPDIR}"; }

@test "findup --version" {
  genman
  run ${BATS_TEST_DESCRIPTION}
  assert_output "${BATS_SEMVER_NEXT}"
}

@test 'findup' {
  # shellcheck disable=SC2185
  EXPECTED=( "$(find --help 2>/dev/null || find || true)" );
  ERROR=1 cmd
}

@test 'findup .' { EXPECTED=( --regexp "^${HOME}" ); cmd; }

@test "findup ${FIRST_DIR} | head -1" { EXPECTED=( "${FIRST_DIR}" ); cmd; }

@test "findup ${FIRST_DIR} | tail -1" { EXPECTED=( /var ); cmd; }

@test "findup ${FIRST_DIR} -name .git" {
  EXPECTED=( "${GIT_FILE}
${GIT_FIRST_GIT}
${GIT_TOP_GIT}" )
  cmd
}

@test "findup ${FIRST_DIR} -type d -name .git" {
  EXPECTED=( "${GIT_FIRST_GIT}
${GIT_TOP_GIT}" )
  cmd
}

@test "findup ${FIRST_DIR} -type d -name .git -exec dirname \"{}\" \\; | head -1" {
  EXPECTED=( "${GIT_FIRST}" )
  cmd
}

@test "findup ${FIRST_DIR} -type d -name .git -exec dirname \"{}\" \\; | tail -1" {
  EXPECTED=( "${GIT_TOP}" )
  cmd
}

@test "findup ${FIRST_FILE} -type f -name .git" {
  EXPECTED=( "${GIT_FILE}" )
  cmd
}

@test "findup -H ${FIRST_FILE} -type f -name .git" {
  EXPECTED=( "${GIT_FILE}" )
  cmd
}

@test "findup -L ${FIRST_FILE} -type f -name .git" {
  EXPECTED=( "${GIT_FILE}" )
  cmd
}

@test "findup -P ${FIRST_FILE} -type f -name .git" {
  EXPECTED=( "${GIT_FILE}" )
  cmd
}
