# bashsupport disable=GrazieInspection
# shellcheck shell=sh

foo() { echo function "${1}"; }
alias foo="foo"
