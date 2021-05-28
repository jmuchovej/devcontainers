#!/usr/bin/env zsh

source /opt/conda/etc/profile.d/conda.sh

conda activate base

# Creates semi-customized shell to allow for friendlier CLI
eval "$(starship init zsh)"

alias julia="\julia -t auto -i --color=yes"
