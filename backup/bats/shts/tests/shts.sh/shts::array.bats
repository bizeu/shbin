#!/usr/bin/env bats

setup_file() { load ../helpers/helper; }

@test "shts::array " {
  shts::run
  assert_equal "$(printf '%s ' "${SHTS_ARRAY[@]}")" "${BATS_TEST_DESCRIPTION}"
}

@test "shts::array foo boo " {
  shts::array
  assert_equal "${#SHTS_ARRAY[@]}" 3
}

@test "shts::array 1 2 3 " {
  shts::array
  assert_equal "${#SHTS_ARRAY[@]}" 4
}

@test "shts::array '1 2' 3 4 5 " {
  shts::array
  export SHTS_ARRAY
  run declare -p SHTS_ARRAY
  assert_output - <<EOF
declare -ax SHTS_ARRAY=([0]="shts::array" [1]="1 2" [2]="3" [3]="4" [4]="5")
EOF
}

@test "shts::array \"1 2 3\" 4 5 6 " {
  shts::array
  export SHTS_ARRAY
  run declare -p SHTS_ARRAY
  assert_output - <<EOF
declare -ax SHTS_ARRAY=([0]="shts::array" [1]="1 2 3" [2]="4" [3]="5" [4]="6")
EOF
}
