#!/usr/bin/env bats

setup_file() {
  load ../helpers/helper
  export HELP="check silently if command is installed, does not check functions or aliases"
}

f() { :; }

alias aliases="foo"

@test "${SHTS_TEST_BASENAME} " {
  shts::run
  assert_failure
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

@test "${SHTS_TEST_BASENAME} aliases " {
  shts::run
  assert_failure
}

@test "${SHTS_TEST_BASENAME} foo " {
  shts::run
  assert_failure
}

@test "${SHTS_TEST_BASENAME} f " {
  shts::run
  assert_failure
}

@test "${SHTS_TEST_BASENAME} ls " {
  shts::run
  assert_success
}
