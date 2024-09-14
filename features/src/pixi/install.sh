#!/bin/sh
set -e

if [ "$(id -u)" -ne 0 ]; then
    err 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

PIXI_HOME=/usr/local
PIXI_VERSION="${VERSION:-"latest"}"
[ "${PIXI_VERSION}" != "latest" ] && PIXI_VERSION="${PIXI_VERSION}"

curl -fsSL https://pixi.sh/install.sh | \
    PIXI_VERSION="${PIXI_VERSION}" PIXI_HOME="${PIXI_HOME}" bash

if [ -f "/etc/bash.bashrc" ]; then
echo <<-EOF | tee -a /etc/bash.bashrc
# From: jmuchovej/features/pixi
eval "$(pixi completion --shell bash)"
EOF
fi

if [ -f "/etc/zsh/zshrc" ]; then
echo <<-EOF | tee -a /etc/zsh/zshrc
# From: jmuchovej/features/pixi
eval "$(pixi completion --shell zsh)"
EOF
fi
