#!/bin/bash
cd $(dirname "$0")
source test-utils.sh

# Template specific tests
check "tlmgr" tlmgr version
check "latexmk" latexmk -version
check "latexmk -pdflatex" latexmk -pdflatex -version
check "latexmk -xelatex" latexmk -xelatex -version
check "latexmk -lualatex" latexmk -lualatex -version
check "latexmk -latex" latexmk -latex -version
check "texhash" texhash --version
check "chktex" chktex --version

# Report result
reportResults