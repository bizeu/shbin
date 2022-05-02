#!/usr/bin/env bats

setup_file() { load ../helpers/helper; }

@test "\$SHTS_* " {
  for i in SHTS_BASENAME SHTS_PATH SHTS_TEST_BASENAME SHTS_TOP; do
    assert [ -n "${!i}" ]
  done
}

@test "\$SHTS_* directories " { assert_dir_exist "${SHTS_TOP}"; }

@test "\$SHTS_TOP " { assert_equal "${SHTS_TOP}" "$(git rev-parse --show-toplevel)"; }

@test "\$SHTS_BASENAME " { assert_equal "${SHTS_BASENAME}" "$(basename "${SHTS_TOP}")"; }
