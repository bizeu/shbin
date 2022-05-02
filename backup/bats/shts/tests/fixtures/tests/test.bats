#!/usr/bin/env bats

setup_file() { source shts.sh; }

@test "false " { shts::run; assert_failure; }
