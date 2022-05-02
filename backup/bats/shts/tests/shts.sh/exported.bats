#!/usr/bin/env bats

setup_file() {
  load ../helpers/helper
  FOO="$(shts::tmp foo)"; export FOO
}

@test "func_exported assert " {
  shts::run
  assert_success
}

@test "func_exported envrc " {
  shts::run
  assert_success
}

@test "func_exported shts::array " {
  shts::run
  assert_success
}

@test "func_exported assert_socket_not_exist " {
  shts::run
  assert_success
}

@test "shts:tmp foo " {
  assert_dir_exist "${FOO}"
}

@test "shts:tmp foo persists" {
  assert_dir_exist "${FOO}"
}
