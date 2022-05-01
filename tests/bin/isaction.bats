#!/usr/bin/env bats

setup_file() {
  load ../helpers/helper
  export HELP="is GitHub Actions is running the workflow?"
}

@test "${SHTS_TEST_BASENAME} " {
  shts::run
  if [ "${GITHUB_RUN_ID-}" ]; then
    assert_success
  else
    assert_failure
  fi
}

@test "${SHTS_TEST_BASENAME} -h " {
  shts::run
  assert_success
  assert_line "${HELP}"
}

@test "${SHTS_TEST_BASENAME} --help " {
  shts::run
  assert_success
  assert_line "${HELP}"
}

@test "${SHTS_TEST_BASENAME} help " {
  shts::run
  assert_success
  assert_line "${HELP}"
}

@test "${SHTS_TEST_BASENAME} foo " {
  shts::run
  assert_failure
  assert_line "${HELP}"
  assert_line "${SHTS_TEST_BASENAME}: foo: invalid option/argument"
}
