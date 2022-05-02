#!/usr/bin/env bats

setup_file() { source shts.sh; }

@test "true " { shts::run; assert_success; }
