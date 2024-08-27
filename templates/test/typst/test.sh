#!/bin/bash
cd $(dirname "$0")
source test-utils.sh

# Template specific tests
check "typst" typst --version
# TODO add tests to check compilation works

# Report result
reportResults
