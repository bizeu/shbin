#!/usr/bin/env bats

setup_file() { source shts.sh; }

@test "test " { shts::run; assert_failure; }
