#!/usr/bin/env bats

setup_file() { load ../helpers/helper; }

@test "${SHTS_TEST_BASENAME} " {
  shts::run
  assert_failure
  assert_line "checks if first argument in any of the following arguments, no arguments is help"
}

@test "${SHTS_TEST_BASENAME} --help " {
  shts::run
  assert_failure
}

@test "${SHTS_TEST_BASENAME} --help foo bar" {
  shts::run
  assert_failure
}

@test "${SHTS_TEST_BASENAME} array \"\${arguments[@]}\" " {
  arguments=(array with arguments)
  assert "${SHTS_TEST_BASENAME}" array "${arguments[@]}"
}
