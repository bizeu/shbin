#!/usr/bin/env bats

setup_file() { load ../helpers/helper; }

commit() {
  touch README.md
  git add README.md
  git -C "${SHTS_REMOTE[0]}" commit -m "test"
  git push
}

@test "shts::remote " {
  shts::array
  "${SHTS_ARRAY[@]}"
  run commit
  assert_success

  run echo "${SHTS_REMOTE[0]}"
  assert_output --regexp "$(dirname "${SHTS_REMOTE[1]}")"
  assert_output --regexp "${BATS_FILE_TMPDIR}"
  refute_output "${BATS_TOP}"
}

@test "shts::remote foo " {
  shts::array
  "${SHTS_ARRAY[@]}"
  run commit
  assert_success

  assert_equal "${SHTS_REMOTE[0]}.git" "${SHTS_REMOTE[1]}"
  run echo "${SHTS_REMOTE[0]}"
  assert_output --regexp "${BATS_FILE_TMPDIR}"
  refute_output "${BATS_TOP}"

}
