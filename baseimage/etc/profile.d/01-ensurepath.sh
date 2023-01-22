export NVM_DIR="${HOME}/.local/opt/nvm"
export PYENV_ROOT="${HOME}/.local/opt/pyenv"
# export JULIAUP_ROOT="${HOME}/.local/opt/juliaup"
export JULIAUP_ROOT="${HOME}/.julia/bin"

PATH="/usr/local/bin:${PATH}"
PATH="${HOME}/.julia/bin:${PATH}"
PATH="${HOME}/.local/opt/nvm:${PATH}"
PATH="${HOME}/.local/opt/pyenv/bin:${PATH}"
PATH="${HOME}/.local/opt/pyenv/shims:${PATH}"
PATH="${HOME}/.local/bin:${PATH}"
export PATH

eval "$(pyenv init -)"
eval "$(starship init $(basename ${SHELL}))"