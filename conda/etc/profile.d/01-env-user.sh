export SHELL=$(cat /etc/passwd | grep $(whoami) | cut -d ":" -f 7)

export JP_LSP_VIRTUAL_DIR="/tmp/lsp-docs"
mkdir -p ${JP_LSP_VIRTUAL_DIR}