#!/usr/bin/env bats

@test "${BATS_TEST_DIRNAME}/../fixtures/shebang/true.shts" {
  source "$(brew --prefix)/lib/bats-assert/src/assert.bash"
  PATH="$(git rev-parse --show-toplevel)/bin:${PATH}" run "${BATS_TEST_DESCRIPTION}"
  assert_success
  assert_output --partial true
  assert_output --partial SHTS_GATHER
  assert_output --partial SHTS_OUTPUT
  assert_output --partial SHTS_TEST_DIR
}
