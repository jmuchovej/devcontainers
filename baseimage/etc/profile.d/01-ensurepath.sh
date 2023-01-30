export NVM_DIR="/usr/local/nvm"
export PYENV_ROOT="/usr/local/pyenv"
# export JULIAUP_ROOT="${HOME}/.local/opt/juliaup"
export JULIAUP_ROOT="/usr/local/juliaup"

PATH="/usr/local/bin:${PATH}"
PATH="${HOME}/.julia/bin:${PATH}"
PATH="${NVM_DIR}:${PATH}"
PATH="${PYENV_ROOT}/bin:${PATH}"
PATH="${PYENV_ROOT}/shims:${PATH}"
PATH="${HOME}/.local/bin:${PATH}"
export PATH

[ -d ${PYENV_ROOT} ] && eval "$(pyenv init -)"
eval "$(starship init $(basename ${SHELL}))"