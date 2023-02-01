FROM --platform=${TARGETPLATFORM} ghcr.io/linuxserver/baseimage-ubuntu:jammy
ARG TARGETPLATFORM
ARG TARGETARCH
ARG BUILD_DATE
ARG VERSION
ARG PYTHON
ARG JULIA
ARG NODE
ARG R

LABEL MAINTAINER "John Muchovej <mail@jmuchovej.com>"
ENV CONTAINER="jmuchovej/baseimage:${VERSION}"

COPY . /

ENV PYENV_ROOT="/usr/local/pyenv"
ENV NVM_DIR="/usr/local/nvm"
ENV R_HOME="/usr/local/R"
ENV JULIAUP_ROOT="/usr/local/juliaup"
ENV JULIA_DEPOT_PATH="/usr/local/julia:${JULIA_DEPOT_PATH}"
ENV PATH="/usr/local/bin:${PATH}"

# region Package installation & Directory setup
USER root
# NB: Can't install `yq` and `gotop` from upstream repositories
RUN apt update; \
    apt install -y \
        ca-certificates \
        curl \
        direnv \
        fontconfig \
        fonts-firacode \
        git \
        htop \
        jq \
        less \
        neovim \
        # pipx \
        python3 \
        python3-venv \
        python3-pip \
        rsync \
        tmux \
        unzip \
        unzip \
        vim \
        wget \
        zip \
        zsh \
    ; \
    curl -fsSL https://starship.rs/install.sh | sh -s -- --yes; \
    rm -rf /var/lib/apt/lists/*; \
    apt clean; \
    fc-cache -f -v; \
    python3 -m pip install pipx; \
    python3 -m pip install pre-commit;

RUN mkdir -p /workspace; \
    chown -R abc:abc /workspace; \
    chmod g+rws /workspace; \
    usermod -m -d /home/abc -s /bin/zsh abc; \
    chmod -R 2775 /home/abc; \
    chown -R abc:abc /home/abc;
# endregion

RUN mkdir -p \ 
        ${PYENV_ROOT} ${NVM_DIR} ${R_HOME} ${JULIAUP_ROOT} ${JULIA_DEPOT_PATH}; \
    chmod 2775 \
        ${PYENV_ROOT} ${NVM_DIR} ${R_HOME} ${JULIAUP_ROOT} ${JULIA_DEPOT_PATH}; \
    chown -R abc:abc \
        ${PYENV_ROOT} ${NVM_DIR} ${R_HOME} ${JULIAUP_ROOT} ${JULIA_DEPOT_PATH};
