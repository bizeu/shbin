#!/usr/bin/env bats
# shellcheck disable=SC2001

setup() {
  load helpers/test_helper
}

assertoutput() {
  os="${1:-macOS}"
  bats::description "${os}"
  if [ "${os}" = 'macOS' ]; then
    run sh -c "${cmd}"
  else
    run container "${os}" "sh -c '${cmd}'"
  fi

  if [ "${ERROR-}" ]; then
    assert_failure
  else
    assert_success
  fi

  if [ "${CALLBACK-}" ]; then
    $(echo "${BATS_TEST_DESCRIPTION}" | sed 's/ /::/g; s/-//g') "${os}"
  else
    [ ! "${EXPECTED-}" ] || assert_output "${EXPECTED}"
  fi
}

cmd() {
  assertoutput
  $BATS_LOCAL || for i in ${IMAGES}; do assertoutput "${i}"; done
}

tmp() { REAL_TMP="/tmp/${1}"; mkdir "${REAL_TMP}"; echo "${REAL_TMP}"; }

@test "real --version" {
  genman
  run ${BATS_TEST_DESCRIPTION}
  assert_output "${BATS_SEMVER_NEXT}"
}

@test 'real' { EXPECTED='/'; cmd="cd / && ${BATS_TEST_DESCRIPTION}"; cmd; }

@test 'real bin' { EXPECTED='/bin'; cmd="cd / && ${BATS_TEST_DESCRIPTION}"; cmd; }
@test 'real --dirname bin' { EXPECTED='/'; cmd="cd / && ${BATS_TEST_DESCRIPTION}"; cmd; }
real::resolved::bin() {
  case "${1}" in
    *alpine*|bash*|bats*|busybox*|debian*|macOS|nix*|python*|zsh*) assert_output /bin ;;
    *) assert_output /usr/bin ;;
  esac
}
@test 'real --resolved bin' { CALLBACK=1; cmd="cd / && ${BATS_TEST_DESCRIPTION}"; cmd; }

@test 'real tmp' { unset CALLBACK; EXPECTED='/tmp'; cmd="cd / && ${BATS_TEST_DESCRIPTION}"; cmd; }

real::resolved::tmp() {
  case "${1}" in macOS) assert_output /private/tmp ;; *) assert_output /tmp ;; esac
}
@test 'real --resolved tmp' { CALLBACK=1; cmd="cd / && ${BATS_TEST_DESCRIPTION}"; cmd; }

real::P::tmp() {
  real::resolved::tmp "${1}"
}
@test 'real -P tmp' { CALLBACK=1; cmd="cd / && ${BATS_TEST_DESCRIPTION}"; cmd; }

@test 'real file' { unset CALLBACK; EXPECTED='/tmp/file'; cmd="cd /tmp && ${BATS_TEST_DESCRIPTION}"; cmd; }

real::resolved() {
  case "${1}" in macOS) assert_output /private/tmp/file;; *) assert_output /tmp/file;; esac
}
@test 'real --resolved' { CALLBACK=1; cmd="${BATS_TEST_DESCRIPTION} /tmp/file"; cmd; }

real::fail::file() {
  assert_line --regexp 'x.*Directory or File not Found.*$'
}
@test 'real --fail file' { CALLBACK=1; ERROR=1; cmd="cd /tmp && ${BATS_TEST_DESCRIPTION}"; cmd; }
real::fail::resolved() {
  real::fail::file
}
@test 'real --fail --resolved' { CALLBACK=1; ERROR=1; cmd="${BATS_TEST_DESCRIPTION} /tmp/file"; cmd; }

real::fail::quiet::file() {
  assert_output ''
}
@test 'real --fail --quiet file' { CALLBACK=1; ERROR=1; cmd="cd /tmp && ${BATS_TEST_DESCRIPTION}"; cmd; }
real::fail::resolved::quiet() {
  assert_output ''
}
@test 'real --fail --resolved --quiet' { CALLBACK=1; ERROR=1; cmd="${BATS_TEST_DESCRIPTION} /tmp/file"; cmd; }

real::tmp::dir::file() {
  assert_line --regexp 'x.*Directory not Found.*$'
}
@test 'real tmp dir file' { CALLBACK=1; ERROR=1; unset EXPECTED; cmd='cd /tmp && real dir/file'; cmd; }
real::resolved::tmp::dir::file() {
  real::tmp::dir::file
}
@test 'real resolved tmp dir file' { CALLBACK=1; ERROR=1; cmd='real --resolved /tmp/dir/file'; cmd; }

real::quiet::tmp::dir::file() {
  assert_output ''
}
@test 'real quiet tmp dir file' { CALLBACK=1; ERROR=1; unset EXPECTED; cmd='cd /tmp && real --quiet dir/file'; cmd; }
real::resolved::quiet::tmp::dir::file() {
  assert_output ''
}
@test 'real resolved quiet tmp dir file' { CALLBACK=1; ERROR=1; cmd='real --resolved --quiet /tmp/dir/file'; cmd; }

real::resolved::tmp::d3::f2() {
  f="${tmp}/d1/f1";
  case "${1}" in macOS)
    assert_output "/private${f}" ;;
    *) assert_output "${f}" ;;
  esac
}
@test 'real resolved tmp d3 f2' {
  CALLBACK=1
  tmp="$(tmp 1)"
  cmd="real-create ${tmp} && cd ${tmp} && real --resolved d3/f2 && real-rm ${tmp}"
  cmd
}
real::resolved::tmp::d2::f2() {
  real::resolved::tmp::d3::f2 "${1}"
}
@test 'real resolved tmp d2 f2' {
  CALLBACK=1
  tmp="$(tmp 2)"
  cmd="real-create ${tmp} && cd ${tmp} && real --resolved d2/f2 && real-rm ${tmp}"
  cmd
}
real::resolved::tmp::d2::f1() {
  real::resolved::tmp::d3::f2 "${1}"
}
@test 'real resolved tmp d2 f1' {
  CALLBACK=1
  tmp="$(tmp 3)"
  cmd="real-create ${tmp} && cd ${tmp} && real --resolved d2/f1 && real-rm ${tmp}"
  cmd
}
real::resolved::tmp::d1::f2() {
  real::resolved::tmp::d3::f2 "${1}"
}
@test 'real resolved tmp d1 f2' {
  CALLBACK=1
  tmp="$(tmp 4)"
  cmd="real-create ${tmp} && cd ${tmp} && real --resolved d1/f2 && real-rm ${tmp}"
  cmd
}
