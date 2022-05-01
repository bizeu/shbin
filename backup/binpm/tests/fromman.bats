#!/usr/bin/env bats
# shellcheck disable=SC2086

setup() {
  load helpers/test_helper
}

setup_file() {
  load helpers/test_helper
  genman
  test_repo_name=repo
  cp -r "${BATS_TOP_TESTS}/${test_repo_name}" "${BATS_FILE_TMPDIR}"
  export REPO_TEST_TMPDIR="${BATS_FILE_TMPDIR}/${test_repo_name}"
  git -C "${REPO_TEST_TMPDIR}" init --quiet
}

paths() {
  PATH="${REPO_TEST_TMPDIR}/bin:${PATH}"; export PATH
  MANPATH="${REPO_TEST_TMPDIR}/share/man${MANPATH:+:${MANPATH}}"; export MANPATH
}

desc() {
  assert genman "${REPO_TEST_TMPDIR}/bin"
  eval "$(colon --bins "${REPO_TEST_TMPDIR}")"
  . repo_test.sh
  run "${BATS_TEST_DESCRIPTION}" --desc
  assert_success
  assert_output "$(head -1 "${REPO_TEST_TMPDIR}/input/${BATS_TEST_DESCRIPTION}.desc")"
}

success() {
  run sh -c "fromman ${2:-git} --${BATS_TEST_DESCRIPTION}"
  assert_success
  assert_output "${1}"
}

@test "fromman --version" {
  genman
  run ${BATS_TEST_DESCRIPTION}
  assert_output "${BATS_SEMVER_NEXT}"
}

@test "fromman" {
  assert ${BATS_TEST_DESCRIPTION}
}

@test "fromman foo --bar" {
  assert ${BATS_TEST_DESCRIPTION}
}

@test "fromman foo" {
  assert ${BATS_TEST_DESCRIPTION}
}

@test "fromman foo --help" {
  run ${BATS_TEST_DESCRIPTION}
  assert_failure
  assert_output --regexp 'Man Page Not Found'
}

@test "fromman git --desc" {
  run ${BATS_TEST_DESCRIPTION}
  assert_failure
  assert_output 'the stupid content tracker'
}

@test "fromman bash --synopsis" {
  run ${BATS_TEST_DESCRIPTION}
  assert_failure
  assert_output 'bash [options] [command_string | file]'
}

@test "fromman git --version" {
  run ${BATS_TEST_DESCRIPTION}
  assert_failure
}

@test "fromman git --help" {
  run ${BATS_TEST_DESCRIPTION}
  assert_failure
  assert_line --regexp 'git - the stupid content tracker'
}

@test "fromman --desc" {
  run ${BATS_TEST_DESCRIPTION}
  assert_line 'show description, help, repository, version or subsections (SYNOPSYS, etc.) from man page'
}

@test "repo_test" {
  desc
}

@test "repo_test.sh" {
  desc
}

@test "repo_test_function_a" {
  desc
}

@test "repo_test_main" {
  desc
}
