#!/usr/bin/env bats

setup_file() {
  load ../helpers/helper
  export HELP="bats testing wrapper and helper functions when \"${SHTS_TEST_BASENAME/.sh/}.sh\" sourced"
}

teardown_file() {
  if [ "${SHTS_TEST_BASENAME}" = "${SHTS_TEST_BASENAME/.sh/}" ]; then
    for i in SHTS_GATHER SHTS_OUTPUT; do
      ! test -d "${!i}" || rm -rf "${!i}"
    done
  fi
}

equal() {
  test -d "$1" || file="$1"
  # shellcheck disable=SC2001
  assert_equal "$(sed 's|^.*--print-output-on-failure ||g' <<< "${output}"| tr ' ' '\n' | sort)" \
    "${file:-$(find "$1" \( -type f -o -type l \) \( -name "*.bats" -o -name "*.shts" \) | sort)}"
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

@test "${SHTS_TEST_BASENAME} commands " {
  shts::run
  assert_success
  assert_output - <<EOF
--help
-h
commands
functions
help
list
EOF
}

@test "${SHTS_TEST_BASENAME} functions " {
  shts::run
  assert_success
  assert_line assert
  assert_line envrc
  assert_line shts::array
}

@test "${SHTS_TEST_BASENAME} list " {
  shts::run
  assert_success
  assert_line --regexp "${BATS_TEST_FILENAME/$(pwd)\//}"
}

@test "${SHTS_TEST_BASENAME} --dry-run --one " {
  run ${SHTS_TEST_BASENAME} --dry-run
  assert_line --partial "--jobs ${BATS_NUMBER_OF_PARALLEL_JOBS:-1}"

  # shellcheck disable=SC2030
  export BATS_NUMBER_OF_PARALLEL_JOBS=5
  run ${SHTS_TEST_BASENAME} --dry-run
  assert_success
  assert_line --partial "--jobs 5"

  shts::run
  assert_success
  assert_line --partial "--jobs 1"
}

@test "${SHTS_TEST_BASENAME} --dry-run " {
  shts::run
  assert_success
  equal "${SHTS_TOP}/tests"
  assert_line --partial "SHTS_TEST_DIR=${SHTS_TOP}"
}

@test "${SHTS_TEST_BASENAME} --dry-run tests " {
  shts::run
  assert_success
  equal "${SHTS_TOP}/${SHTS_ARRAY[2]}"
  assert_line --partial "SHTS_TEST_DIR=${SHTS_TOP}/${SHTS_ARRAY[2]}"
}

@test "${SHTS_TEST_BASENAME} tests/fixtures --dry-run" {
  shts::run
  assert_success
  equal "${SHTS_TOP}/${SHTS_ARRAY[1]}"
  assert_line --partial "SHTS_TEST_DIR=${SHTS_TOP}/${SHTS_ARRAY[1]}"
}

@test "${SHTS_TEST_BASENAME} tests/fixtures/tests/test.bats --dry-run" {
  shts::run
  assert_success
  equal "${SHTS_TOP}/${SHTS_ARRAY[1]}"
  assert_line --partial "SHTS_TEST_DIR=${SHTS_TOP}/$(dirname "${SHTS_ARRAY[1]}")"
}

@test "sh -c 'cd tests/fixtures/${SHTS_TEST_BASENAME} && ${SHTS_TEST_BASENAME} --dry-run' " {
  shts::run
  assert_success
  equal "${SHTS_TOP}/tests/fixtures/${SHTS_TEST_BASENAME}/test.bats"
  assert_line --partial "SHTS_TEST_DIR=${SHTS_TOP}/tests/fixtures/${SHTS_TEST_BASENAME}"
}

@test "${SHTS_TEST_BASENAME} --verbose --dry-run tests/fixtures " {
  shts::run
  assert_success
  assert_line --partial "--print-output-on-failure --gather-test-outputs-in \
${SHTS_TOP}/.${SHTS_TEST_BASENAME/.sh/}/test \
--no-tempdir-cleanup --output ${SHTS_TOP}/.${SHTS_TEST_BASENAME/.sh/}/output --show-output-of-passing-tests \
--timing --trace --verbose-run"
}

@test "${SHTS_TEST_BASENAME} tests/fixtures --verbose " {
  [ "${SHTS_TEST_BASENAME}" = "${SHTS_TEST_BASENAME/.sh/}" ] || skip "output is removed in teardown_file"
  shts::run
  assert_success
  assert_line "# \$\$ run \"\${SHTS_ARRAY[@]}\""
  [ ! "${SHTS_OUTPUT-}" ] || assert_dir_exist "${SHTS_OUTPUT}"
}

@test "${SHTS_TEST_BASENAME} tests/fixtures/tests/test.bats " {
  shts::run
  assert_success
}

@test "sh -c 'cd tests/fixtures/${SHTS_TEST_BASENAME} && ${SHTS_TEST_BASENAME}' " {
  shts::run
  assert_success
}

@test "${SHTS_TEST_BASENAME} $(shts::tmp tmp) " {
  shts::run
  assert_failure
  assert_output --regexp "${SHTS_TEST_BASENAME/.sh/}: .*/tmp: no .bats or .shts tests found in directory"
}

@test "git init " {
  repo="$(shts::tmp "${SHTS_TEST_BASENAME}/git_init")"
  cd "${repo}"
  shts::run
  run "${SHTS_TEST_BASENAME}"
  assert_failure
  assert_output "${SHTS_TEST_BASENAME/.sh/}: $(pwd -P)/{__tests__,test,tests}: no .bats or .shts test found"
}

@test "mkdir src; touch 'test.bats' " {
  repo="$(shts::tmp "${SHTS_TEST_BASENAME}/touch_test.bats")"
  cd "${repo}"
  git init
  shts::run
  run "${SHTS_TEST_BASENAME}"
  assert_failure
  assert_output "${SHTS_TEST_BASENAME/.sh/}: $(pwd -P)/{__tests__,test,tests}: no .bats or .shts test found"
}

@test "mkdir test " {
  repo="$(shts::tmp "${SHTS_TEST_BASENAME}/mkdir_test")"
  cd "${repo}"
  git init
  shts::run
  touch test/test.bats
  run "${SHTS_TEST_BASENAME}"
  assert_success
  assert_output "1..0"
}

@test "mkdir __tests__ " {
  repo="$(shts::tmp "${SHTS_TEST_BASENAME}/mkdir__test__")"
  cd "${repo}"
  git init
  shts::run
  touch __tests__/test.bats
  run "${SHTS_TEST_BASENAME}"
  assert_success
  assert_output "1..0"
}

@test "sh -c 'cd $(shts::tmp tmp1) && ${SHTS_TEST_BASENAME}' " {
  shts::run
  assert_failure
  assert_output --regexp "${SHTS_TEST_BASENAME/.sh/}:.*/tmp1: not a git repository \(or any of the parent directories\)"
}

@test "${SHTS_TEST_BASENAME} foo " {
  shts::run
  assert_failure
  assert_line "${HELP}"
  assert_line "${SHTS_TEST_BASENAME/.sh/}: foo: no such file, directory or invalid command"
}
