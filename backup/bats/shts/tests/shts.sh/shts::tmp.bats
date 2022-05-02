#!/usr/bin/env bats

setup_file() { load ../helpers/helper; }

@test "shts::tmp " {
  shts::run
  assert_output "${BATS_FILE_TMPDIR}"
}

@test "shts::tmp foo " {
  shts::run
  assert_output "${BATS_FILE_TMPDIR}/foo"
}
