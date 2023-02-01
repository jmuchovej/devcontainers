export NVM_DIR="/usr/local/nvm"
export PYENV_ROOT="/usr/local/pyenv"
export JULIAUP_ROOT="/usr/local/juliaup"
export JULIA_DEPOT_PATH="/usr/local/julia:${JULIA_DEPOT_PATH}"
export R_HOME="/usr/local/R"

PATH="/usr/local/bin:${PATH}"
PATH="${R_HOME}/bin:${PATH}"
PATH="${JULIAUP_ROOT}/bin:${PATH}"
PATH="${NVM_DIR}:${PATH}"
PATH="${PYENV_ROOT}/bin:${PATH}"
PATH="${PYENV_ROOT}/shims:${PATH}"
PATH="${HOME}/.local/bin:${PATH}"
export PATH

[ -d ${PYENV_ROOT} ] && eval "$(pyenv init -)"
eval "$(starship init $(basename ${SHELL}))"