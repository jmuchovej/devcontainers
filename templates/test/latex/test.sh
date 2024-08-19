#!/bin/bash
cd $(dirname "$0")
source test-utils.sh

# Template specific tests
check "tlmgr" tlmgr version
check "latexmk" latexmk -version
check "texhash" texhash --version
check "chktex" chktex --version

# Report result
reportResults