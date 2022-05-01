#!/usr/bin/env bats

setup_file() { load ../helpers/helper; }

@test "func_exported foo " {
  shts::run
  assert_failure
  assert_line --partial "foo: function not exported"
}

@test "func_exported setup_file " {
  shts::run
  assert_failure
  assert_line --partial "setup_file: function not exported"
}

@test "func_exported valid " {
  valid() { :; }; export -f valid

  shts::run
  assert_success
}
