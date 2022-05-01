#!/usr/bin/env bats
# shellcheck disable=SC2086,SC2153,SC2001

setup() {
  load helpers/test_helper
  . system.sh
  RUBY_GEMS="${HOMEBREW_LIB}/ruby/gems"
  GEMS_VERSION="$(find "${RUBY_GEMS}" -type d -mindepth 1 -maxdepth 1 -exec basename "{}" \;)"
  test_repo_name=repo
  cp -r "${BATS_TOP_TESTS}/${test_repo_name}" "${BATS_TEST_TMPDIR}"
  export REPO_TEST_TMPDIR="${BATS_TEST_TMPDIR}/${test_repo_name}"
  git -C "${REPO_TEST_TMPDIR}" init --quiet
  export GEMS_VERSION RUBY_GEMS
}

setup_file() {
  RUBY_OPT="$(brew --prefix ruby)"
  RUBY_VERSION="$("${RUBY_OPT}/bin/ruby" --version | awk -F '[ p]' '{ print $2 }')"
  export RUBY_OPT RUBY_VERSION
}

assertoutput() {
  os="${1:-macOS}"
  bats::description "${os}"
  sh='sh'
  [ "${os}" = 'macOS' ] || { add="'"; sh="container ${os} ${sh}"; }
  # run sh -c "'${cmd} ${*}'"  # macOS
  # run container "${os}" "sh -c '${cmd} ${*}'"  # image
  run ${sh} -c "${add:-}${BATS_TEST_DESCRIPTION}${add:-}"

  if [ "${ERROR-}" ]; then
    assert_failure
  else
    assert_success
  fi

  if [ "${CALLBACK-}" ]; then
    $(echo "${BATS_TEST_DESCRIPTION}" | sed 's/ /::/g') "${os}"
  else
    [ ! "${EXPECTED-}" ] || assert_output "${EXPECTED}"
  fi
}

cmd() {
  assertoutput
  # FIXME: Images and docker container tests
  { $BATS_LOCAL || [ "${1:-}" = 'local' ]; } || for i in ${IMAGES}; do assertoutput "${i}"; done
}

repo() {
  load helpers/test_helper
  test_repo_name=repo
  cp -r "${BATS_TOP_TESTS}/${test_repo_name}" "${BATS_TEST_TMPDIR}"
  REPO_TEST_TMPDIR="$(cd "${BATS_TEST_TMPDIR}/${test_repo_name}" || exit 1; pwd)"; export REPO_TEST_TMPDIR
  git -C "${REPO_TEST_TMPDIR}" init --quiet
}

@test "colon --version" {
  genman
  run ${BATS_TEST_DESCRIPTION}
  assert_output "${BATS_SEMVER_NEXT}"
}

@test "colon --base" {
  EXPECTED="PATH='/usr/sbin:/usr/bin:/sbin:/bin'; export PATH
MANPATH='/usr/share/man:'; export MANPATH
INFOPATH='/usr/share/info'; export INFOPATH"
  cmd
}
@test "colon --init" {
  EXPECTED="TOP='${BATS_TOP}'
BINPM='${BATS_TOP}'; export BINPM
PATH='${BATS_TOP_TESTS}/bin:${BATS_TOP}/bin:/usr/local/sbin:/usr/local/bin:\
${RUBY_GEMS}/${GEMS_VERSION}/bin:${RUBY_OPT}/bin:\
${CLT}/usr/bin:/usr/sbin:/usr/bin:/sbin:/bin:${PYCHARM}:\
${PYCHARM_CONTENTS}/MacOS:/usr/local/MacGPG2/bin'; export PATH
MANPAGER='most'; export MANPAGER
MANPATH='${BATS_TOP}/share/man:/usr/local/share/man:${RUBY_OPT}/share/man:\
${CLT}/usr/share/man:/usr/share/man:'; export MANPATH
INFOPATH='/usr/local/share/info:/usr/share/info'; export INFOPATH"
  cmd local
}
@test "colon" {
  eval "$(colon --init)"
  PATH="/usr/foo:${PATH}:/bar"
  EXPECTED="PATH='${BATS_TOP_TESTS}/bin:${BATS_TOP}/bin:/usr/local/sbin:/usr/local/bin:\
${RUBY_GEMS}/${GEMS_VERSION}/bin:${RUBY_OPT}/bin:\
${CLT}/usr/bin:/usr/sbin:/usr/bin:/sbin:/bin:${PYCHARM}:\
${PYCHARM_CONTENTS}/MacOS:/usr/local/MacGPG2/bin'; export PATH
MANPAGER='most'; export MANPAGER
MANPATH='${BATS_TOP}/share/man:/usr/local/share/man:${RUBY_OPT}/share/man:\
${CLT}/usr/share/man:/usr/share/man:'; export MANPATH
INFOPATH='/usr/local/share/info:/usr/share/info'; export INFOPATH"
  cmd local
}
@test "colon --init -P" {
  EXPECTED="TOP='${BATS_TOP}'
BINPM='${BATS_TOP}'; export BINPM
PATH='${BATS_TOP_TESTS}/bin:${BATS_TOP}/bin:/usr/local/sbin:/usr/local/bin:\
${RUBY_GEMS}/${GEMS_VERSION}/bin:\
${HOMEBREW_CELLAR}/ruby/${RUBY_VERSION}/bin:\
${CLT}/usr/bin:/usr/sbin:/usr/bin:/sbin:/bin:${PYCHARM}:\
${PYCHARM_CONTENTS}/MacOS:/usr/local/MacGPG2/bin'; export PATH
MANPAGER='most'; export MANPAGER
MANPATH='${BATS_TOP}/share/man:/usr/local/share/man:\
${HOMEBREW_CELLAR}/ruby/${RUBY_VERSION}/share/man:\
${CLT}/usr/share/man:/usr/share/man:'; export MANPATH
INFOPATH='/usr/local/share/info:/usr/share/info'; export INFOPATH"
  cmd local
}
@test "colon --init --physical" {
  EXPECTED="TOP='${BATS_TOP}'
BINPM='${BATS_TOP}'; export BINPM
PATH='${BATS_TOP_TESTS}/bin:${BATS_TOP}/bin:/usr/local/sbin:/usr/local/bin:\
${RUBY_GEMS}/${GEMS_VERSION}/bin:\
${HOMEBREW_CELLAR}/ruby/${RUBY_VERSION}/bin:\
${CLT}/usr/bin:/usr/sbin:/usr/bin:/sbin:/bin:${PYCHARM}:\
${PYCHARM_CONTENTS}/MacOS:/usr/local/MacGPG2/bin'; export PATH
MANPAGER='most'; export MANPAGER
MANPATH='${BATS_TOP}/share/man:/usr/local/share/man:\
${HOMEBREW_CELLAR}/ruby/${RUBY_VERSION}/share/man:\
${CLT}/usr/share/man:/usr/share/man:'; export MANPATH
INFOPATH='/usr/local/share/info:/usr/share/info'; export INFOPATH"
  cmd local
}
@test "colon --bins" {
  EXPECTED="TOP='${BATS_TOP}'
BINPM='${BATS_TOP}'; export BINPM
PATH='${BATS_TOP_TESTS}/bin:${BATS_TOP}/bin:/usr/local/sbin:/usr/local/bin:\
${RUBY_GEMS}/${GEMS_VERSION}/bin:${RUBY_OPT}/bin:\
${CLT}/usr/bin:/usr/sbin:/usr/bin:/sbin:/bin:\
${PYCHARM}:${PYCHARM_CONTENTS}/MacOS:/usr/local/MacGPG2/bin'; export PATH
MANPAGER='most'; export MANPAGER
MANPATH='${BATS_TOP}/share/man:/usr/local/share/man:${RUBY_OPT}/share/man:\
${CLT}/usr/share/man:/usr/share/man:'; export MANPATH
INFOPATH='/usr/local/share/info:/usr/share/info'; export INFOPATH"
  eval "$(colon --init)"
  cmd local
}
@test "colon --bins ${HOME}" {
  EXPECTED="PATH='${HOME}:${BATS_TOP_TESTS}/bin:${BATS_TOP}/bin:/usr/local/sbin:/usr/local/bin:\
${RUBY_GEMS}/${GEMS_VERSION}/bin:${RUBY_OPT}/bin:\
${CLT}/usr/bin:/usr/sbin:/usr/bin:/sbin:/bin:\
${PYCHARM}:${PYCHARM_CONTENTS}/MacOS:/usr/local/MacGPG2/bin'; export PATH
MANPAGER='most'; export MANPAGER
MANPATH='${BATS_TOP}/share/man:/usr/local/share/man:${RUBY_OPT}/share/man:\
${CLT}/usr/share/man:/usr/share/man:'; export MANPATH
INFOPATH='/usr/local/share/info:/usr/share/info'; export INFOPATH"
  eval "$(colon --init)"
  cmd local
}
@test "colon --bins /tmp" {
  EXPECTED="PATH='/tmp:${BATS_TOP_TESTS}/bin:${BATS_TOP}/bin:/usr/local/sbin:/usr/local/bin:\
${RUBY_GEMS}/${GEMS_VERSION}/bin:${RUBY_OPT}/bin:\
${CLT}/usr/bin:/usr/sbin:/usr/bin:/sbin:/bin:\
${PYCHARM}:${PYCHARM_CONTENTS}/MacOS:/usr/local/MacGPG2/bin'; export PATH
MANPAGER='most'; export MANPAGER
MANPATH='${BATS_TOP}/share/man:/usr/local/share/man:${RUBY_OPT}/share/man:\
${CLT}/usr/share/man:/usr/share/man:'; export MANPATH
INFOPATH='/usr/local/share/info:/usr/share/info'; export INFOPATH"
  eval "$(colon --init)"
  cmd local
}
@test "colon --bins /" {
  EXPECTED="PATH='/:${BATS_TOP_TESTS}/bin:${BATS_TOP}/bin:/usr/local/sbin:/usr/local/bin:\
${RUBY_GEMS}/${GEMS_VERSION}/bin:${RUBY_OPT}/bin:\
${CLT}/usr/bin:/usr/sbin:/usr/bin:/sbin:/bin:\
${PYCHARM}:${PYCHARM_CONTENTS}/MacOS:/usr/local/MacGPG2/bin'; export PATH
MANPAGER='most'; export MANPAGER
MANPATH='${BATS_TOP}/share/man:/usr/local/share/man:${RUBY_OPT}/share/man:\
${CLT}/usr/share/man:/usr/share/man:'; export MANPATH
INFOPATH='/usr/local/share/info:/usr/share/info'; export INFOPATH"
  eval "$(colon --init)"
  cmd local
}
@test "colon --bins /usr" {
  EXPECTED="PATH='/usr:${BATS_TOP_TESTS}/bin:${BATS_TOP}/bin:/usr/local/sbin:/usr/local/bin:\
${RUBY_GEMS}/${GEMS_VERSION}/bin:${RUBY_OPT}/bin:\
${CLT}/usr/bin:/usr/sbin:/usr/bin:/sbin:/bin:\
${PYCHARM}:${PYCHARM_CONTENTS}/MacOS:/usr/local/MacGPG2/bin'; export PATH
MANPAGER='most'; export MANPAGER
MANPATH='${BATS_TOP}/share/man:/usr/local/share/man:${RUBY_OPT}/share/man:\
${CLT}/usr/share/man:/usr/share/man:'; export MANPATH
INFOPATH='/usr/local/share/info:/usr/share/info'; export INFOPATH"
  eval "$(colon --init)"
  cmd local
}
@test "colon --bins repo" {
  repo
  EXPECTED="TOP='${REPO_TEST_TMPDIR}'
REPO='${REPO_TEST_TMPDIR}'; export REPO
PATH='${REPO_TEST_TMPDIR}/bin:\
${BATS_TOP_TESTS}/bin:${BATS_TOP}/bin:/usr/local/sbin:/usr/local/bin:\
${RUBY_GEMS}/${GEMS_VERSION}/bin:${RUBY_OPT}/bin:\
${CLT}/usr/bin:/usr/sbin:/usr/bin:/sbin:/bin:\
${PYCHARM}:${PYCHARM_CONTENTS}/MacOS:/usr/local/MacGPG2/bin'; export PATH
MANPAGER='most'; export MANPAGER
MANPATH='${REPO_TEST_TMPDIR}/share/man:${BATS_TOP}/share/man:/usr/local/share/man:${RUBY_OPT}/share/man:\
${CLT}/usr/share/man:/usr/share/man:'; export MANPATH
INFOPATH='/usr/local/share/info:/usr/share/info'; export INFOPATH"
  eval "$(colon --init)"
  run colon --bins "${REPO_TEST_TMPDIR}/bin"
  assert_success
  assert_output "${EXPECTED}"
}
@test "colon --bins $0 -P" {
  EXPECTED="PATH='${BATS_LIBEXEC}:\
${BATS_TOP_TESTS}/bin:${BATS_TOP}/bin:/usr/local/sbin:/usr/local/bin:\
${RUBY_GEMS}/${GEMS_VERSION}/bin:\
${HOMEBREW_CELLAR}/ruby/${RUBY_VERSION}/bin:\
${CLT}/usr/bin:/usr/sbin:/usr/bin:/sbin:/bin:\
${PYCHARM}:${PYCHARM_CONTENTS}/MacOS:/usr/local/MacGPG2/bin'; export PATH
MANPAGER='most'; export MANPAGER
MANPATH='${BATS_TOP}/share/man:/usr/local/share/man:\
${HOMEBREW_CELLAR}/ruby/${RUBY_VERSION}/share/man:\
${CLT}/usr/share/man:/usr/share/man:'; export MANPATH
INFOPATH='/usr/local/share/info:/usr/share/info'; export INFOPATH"
  eval "$(colon --init -P)"
  cmd local
}
@test "colon /bin" {
  EXPECTED="/bin"
  cmd
}
@test "colon . /usr/bin" {
  cd "${BATS_TOP_TESTS}"
  EXPECTED="${BATS_TOP_TESTS}:/usr/bin"
  cmd local
}
@test "colon --append . /usr/bin" {
  cd "${BATS_TOP_TESTS}"
  EXPECTED="/usr/bin:${BATS_TOP_TESTS}"
  cmd local
}
@test "colon ${HOME} /usr/bin" {
  cd "${HOME}"
  EXPECTED="${HOME}:/usr/bin"
  cmd
}
@test "colon --append /bin" {
  EXPECTED="/bin"
  cmd
}
@test "colon /bin --export" {
  EXPECTED="PATH='/bin'; export PATH"
  cmd
}
@test "colon --append /bin --export" {
  EXPECTED="PATH='/bin'; export PATH"
  cmd
}
@test "colon /bin /usr/bin" {
  EXPECTED="/bin:/usr/bin"
  cmd
}
@test "colon --append /bin /usr/bin" {
  EXPECTED="/usr/bin:/bin"
  cmd
}
@test "colon /bin /usr/bin --export" {
  EXPECTED="PATH='/bin:/usr/bin'; export PATH"
  cmd
}
@test "colon --append /bin /usr/bin --export" {
  EXPECTED="PATH='/usr/bin:/bin'; export PATH"
  cmd
}
@test "colon /bin /usr/bin --export=" {
  EXPECTED="PATH='/bin:/usr/bin'; export PATH"
  cmd
}
@test "colon --append /bin /usr/bin --export=" {
  EXPECTED="PATH='/usr/bin:/bin'; export PATH"
  cmd
}
@test "colon /usr/share/man --export=MANPATH" {
  EXPECTED="MANPAGER='most'; export MANPAGER
MANPATH='/usr/share/man:'; export MANPATH"
  cmd
}
@test "colon --append /usr/share/man --export=MANPATH" {
  EXPECTED="MANPAGER='most'; export MANPAGER
MANPATH='/usr/share/man:'; export MANPATH"
  cmd
}
@test "colon /usr/share/man /bin/share --export=MANPATH" {
  EXPECTED="MANPAGER='most'; export MANPAGER
MANPATH='/usr/share/man:/bin/share:'; export MANPATH"
  cmd
}
@test "colon --append /usr/share/man /bin/share --export=MANPATH" {
  EXPECTED="MANPAGER='most'; export MANPAGER
MANPATH='/bin/share:/usr/share/man:'; export MANPATH"
  cmd
}
@test "colon --append /usr/share/fake --export=INFOPATH" {
  EXPECTED=''
  cmd
}
@test "colon --remove /bin" {
  EXPECTED=''
  cmd
}
@test "colon --remove /bin --export" {
  EXPECTED=''
  cmd
}
@test "colon --remove /bin /usr/bin" {
  EXPECTED='/usr/bin'
  cmd
}
@test "colon --remove /bin /usr/bin --export" {
  EXPECTED="PATH='/usr/bin'; export PATH"
  cmd
}
@test "colon --remove /bin /usr/bin:/bin" {
  EXPECTED='/usr/bin'
  cmd
}
@test "colon --remove /bin /bin:/usr/bin:/bin" {
  EXPECTED='/usr/bin'
  cmd
}
@test "colon --remove /bin /bin:/usr/bin:/bin:/usr/local/bin:/bin" {
  EXPECTED='/usr/bin:/usr/local/bin'
  cmd
}
