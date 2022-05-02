#!/bin/sh
# shellcheck disable=SC2034

#
# https://git-scm.com/docs/git-sh-setup
# https://github.com/git/git/blob/master/git-sh-setup.sh
# Stuck long form:
# If not set (long converted to short if both in the spec):
#     --foo => -f (if f,foo otherwise or --foo)
#     -f => -f
#     --bar bar1 --bar=bar2 => --bar bar1 --bar bar2
#     --qux --qux=qux => --qux --qux qux
#     -C c => -C c
#     -Ee => -E e
# If set (short converted to long if both in the spec):
#     -f => --foo
#     --foo => --foo
#     --bar bar1 --bar=bar2 => --bar=bar1 --bar=bar2
#     --qux --qux=qux => --qux --qux=qux
#     -C c => -Cc
#     -Ee => -Ee

set -eu

_parsecmd="git rev-parse --parseopt --stuck-long"

# git-sh-setup: keep the `--` is an arg when is written as an argument: git-example -- argument (will have -- and --)
# (Default: 0)
: "${OPTIONS_KEEPDASHDASH=0}"; [ "${OPTIONS_KEEPDASHDASH}" -eq 0 ] || _parsecmd="${_parsecmd} --keep-dashdash"

# Stop parsing after the first non-option argument, so errors after that are not caught.
# git-parse -Ca stop --foo --bar -- a  -> --bar would not give error if not in spec.
# (Default: 0)
: "${OPTIONS_STOPATNONOPTION=0}";[ "${OPTIONS_STOPATNONOPTION}" -eq 0 ] || _parsecmd="${_parsecmd} --stop-at-non-option"

# Script Name from $0 Basename
#
SCRIPT="${0##*/}"

# Color Command from $0: 'git-example'
#
COLOR_SCRIPT="$(git green "${SCRIPT}")"

# Color Command from $0 Removing 'git-': 'example'
#
COLOR_COMMAND="$(git green "${SCRIPT##*git-}")"

# Color Git Command from $0 Splitting  git': 'git example'
#
GIT_COMMAND="$(git green "git ${COLOR_COMMAND}")"
[ "git-${SCRIPT##*git-}" = "${SCRIPT}" ] || GIT_COMMAND="${COLOR_SCRIPT}"

# GIT Top Level Directory set by top()
#
export GIT_TOP

# Parsed GIT Commit Message when --message is spec()
#
export GIT_MESSAGE

#######################################
# private spec for git-parse.sh/git-parse when not sourced
# Arguments:
#  None
#######################################
_spec() {
  cat <<EOF
${GIT_COMMAND} $(git red "-h")
${COLOR_SCRIPT} $(git red "--help")
. ${COLOR_SCRIPT}
. ${COLOR_SCRIPT}$(git green ".sh")
OPTIONS_KEEPDASHDASH=1 . ${COLOR_SCRIPT}
OPTIONS_STOPATNONOPTION=1 . ${COLOR_SCRIPT}

. ${COLOR_SCRIPT} - Parsing using stuck long option if $(git magenta spec\(\)) defined.
              Parsing $(git magenta '-C <path') if defined in the options spec $(git magenta '^C=path'), \
and change to $(git magenta '<path>')

            Globals:
              $(git magenta SCRIPT)       =>  $(git green git-foo)
              $(git magenta COMMAND)      =>  $(git green foo)
              $(git magenta GIT_COMMAND)  =>  $(git green 'git foo')

            Defaults:
              $(git magenta OPTIONS_KEEPDASHDASH)     =>  $(git blue 0)
              $(git magenta OPTIONS_STOPATNONOPTION)  =>  $(git blue 0)

            Stuck Long \$OPTIONS_SPEC:
              f,foo       $(git magenta '-f --foo --no-foo')             =>  $(git blue '-f --foo --no-foo')
              m,moo!      $(git magenta '-m --moo')                      =>  $(git blue '--moo --moo')
              b,bar=      $(git magenta '-bbar1 --bar bar2 --bar=bar3')  =>  \
$(git blue '--bar=bar1 --bar=bar2 --bar=bar3')
              q,qux?path  $(git magenta '--qux -qqux1 --qux=qux2')      =>  $(git blue '--qux --qux=qux1 --qux=qux2')
              continue!   $(git magenta '--continue')                    =>  $(git blue '--continue')
              a,abort!    $(git magenta '-a --abort')                    =>  $(git blue '--abort --abort')
              A!path      $(git magenta '-A')                            =>  $(git blue '-A')
              C=path      $(git magenta '-C c')                          =>  $(git blue '-Cc')
              E?path      $(git magenta '-E -Ee')                        =>  $(git blue '-E -Ee')

            Stuck Long Parser:
              $(git magenta 'while') $(git magenta '[') $(git red "\$#") -ne 0 $(git magenta ']'); $(git magenta "do")
                $(git magenta case) $(git blue "\"")$(git yellow "\$1")$(git blue "\"") $(git magenta in)
                  --foo) $(git red "foo")=$(git blue "\"\$((")foo+$(git blue "1))\"") $(git magenta ";;")
                  --no-foo) $(git red "foo_no")=1 $(git magenta ";;")
                  --moo) $(git red "moo")=1 $(git magenta ";;")
                  --bar=*) $(git red "bar")=$(git blue "\"\${")bar:+$(git green "\${")bar$(git green "}") \
$(git blue "}\${")$(git yellow 1)#$(git yellow "--bar=")$(git blue "}\"") $(git magenta ";;")
                  --qux) $(git red "qux")=true $(git magenta ";;")
                  --qux=*) $(git red "qux_values")=$(git blue "\"\${")qux_values:+$(git green "\${")\
qux_values$(git green "}") $(git blue "}\${")$(git yellow 1)#$(git yellow "--qux=")$(git blue "}\"") \
$(git magenta ";;")
                  --continue) $(git red "continue")=1 $(git magenta ";;")
                  --abort) $(git red "abort")=1 $(git magenta ";;")
                  -A) $(git red "A")=1 $(git magenta ";;")
                  -C*) $(git red "C")=$(git blue "\"\${")$(git yellow 1)#$(git yellow "-C")$(git blue "}\"") \
      $(git magenta ";;")
                  -E) $(git red "E")=true $(git magenta ";;")
                  -E*) $(git red "E_value")=$(git blue "\"\${")E_value:+$(git green "\${")E_value$(git green "}") \
$(git blue "}\${")$(git yellow 1)#$(git yellow "-E")$(git blue "}\"") $(git magenta ";;")
                  --) $(git cyan 'shift'); $(git cyan 'break') $(git magenta ";;")
                $(git magenta 'esac')
                $(git cyan 'shift')
              $(git magenta 'done')

              $(git green "\$") git-parse @1 -f --foo --no-foo --moo @2 -bbar1 --bar bar2 --bar=bar3 @3 \
--qux -qqux1 --qux=qux2 @4 -A -C c -E -Ee @5 --continue @6 -a --abort -- DASH
              $(git blue "A=1 C=c E=true E_value=e abort=1 bar='bar1 bar2 bar3' continue=1 foo=2 foo_no=1 moo=1 \
qux=true qux_values='qux1 qux2'")
              $(git blue "\$@=@1 @2 @3 @4 @5 @6 DASH")

            Helper Functions:
              $(git magenta 'invalid()')   =>  $(git blue 'show invalid argument/option value message and exit')
              $(git magenta 'required()')  =>  $(git blue 'show argument required message and exit')
--
h,help    Show help and exit.
EOF
}

#######################################
# change to git top directory and sets $GIT_TOP
# Globals
#  TOP
# Arguments:
#  None
#######################################
top() {
  GIT_TOP="$(git rev-parse --show-toplevel 2>/dev/null)"
  [ -d "${GIT_TOP}" ] || {
    >&2 echo "Not a git repository (or any of the parent directories): ${GIT_TOP:-${PWD}}"
    exit 1
  }
  cd "${GIT_TOP}"
}

#######################################
# show invalid argument/option value message and exit
# Arguments:
#  [<value>]       invalid argument value, i.e: 'foo'
#  [<argument>]    argument name, i.e: "<remote>"
#######################################
invalid() {
  git red "$1"
  echo "invalid argument/option value for ${2}"
  "$0" -h
}

#######################################
# show argument required message and exit
# Arguments:
#  [<name>]       argument name, i.e: "<submodule name>'
#######################################
required() {
  git red "$1"
  echo "argument requires a value"
  "$0" -h
}

case "${0##*/}" in
  git-parse*) _spec=_spec ;;
  *) ! type spec | grep -q "is a shell function" || _spec=spec ;;
esac

if [ "${_spec-}" ]; then
  eval "$($_spec | ${_parsecmd} -- "$@" || echo exit $?)"

  #######################################
  # change to directory in -C option if specified on the spec (C=path) and removes from parsed arguments.
  # Arguments:
  #  None
  #######################################
  if $_spec | grep -q "^C=path"; then
    for arg; do
      shift
      case "${arg}" in
        -C*) cd "${arg#-C}" ;;
        *) set -- "$@" "${arg}" ;;
      esac
    done
    unset arg
  fi

  #######################################
  # parses commit message options if specified on the spec (feat!) and sets global variable $GIT_MESSAGE with message
  # Globals:
  #   GIT_MESSAGE
  # Arguments:
  #  None
  # Examples:
  #   git-message --feat => feat: M ....
  #   git-message --feat! => feat!: M ....
  #   git-message --feat= => feat!: M ....
  #   git-message --feat="commit message" => feat: commit message
  #   git-message --feat --message="commit message" => feat: commit message
  #   git-message => auto: M ....
  #   git-message --message="commit message" => commit message
  # Version:
  #   --fix          => Patch
  #   --feat         => Minor
  #   --fix!|--feat! => Major
  #######################################
#  if $_spec | grep -q "^feat\!" && [ ! "${GIT_MESSAGE-}" ]; then
#    for arg; do
#      shift
#      case "${arg}" in
#        --feat|--feat!|--fix|--fix!) prefix="${arg#--}: " ;;
#        --feat=*) prefix="feat: "; message="${arg#--feat=}" ;;
#        --feat!=*) prefix="feat!: "; message="${arg#--feat!=}" ;;
#        --fix=*) prefix="fix: "; message="${arg#--fix=}" ;;
#        --fix!=*) prefix="fix!: "; message="${arg#--fix!=}" ;;
#        --message=*) message="${arg#--message=}" ;;
#        *) set -- "$@" "${arg}" ;;
#      esac
#    done
#    { [ "${prefix-}" ] || [ "${message-}" ]; } || prefix="auto: "
#    export GIT_MESSAGE="${prefix-}${message:-$(git diff --name-status -r)}"
#    unset arg message prefix
#  fi
fi

unset _parsecmd _spec
