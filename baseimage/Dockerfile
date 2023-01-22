FROM --platform=${TARGETPLATFORM} ghcr.io/linuxserver/baseimage-ubuntu:jammy
ARG TARGETPLATFORM
ARG BUILD_DATE
ARG VERSION
ARG PYTHON
ARG JULIA
ARG NODE
ARG R

LABEL MAINTAINER "John Muchovej <jmuchovej@pm.me>"
ENV CONTAINER="jmuchovej/baseimage:${VERSION}"

COPY . /

# region Package installation & Directory setup
USER root
RUN apt update; \
    apt install -y \
        ca-certificates \
        curl \
        direnv \
        fontconfig \
        fonts-firacode \
        git \
        gotop \
        htop \
        jq \
        less \
        neovim \
        python3 \
        tmux \
        unzip \
        unzip \
        vim \
        wget \
        yq \
        zip \
        zsh \
    ; \
    curl -fsSL https://starship.rs/install.sh | sh -s -- --yes; \
    rm -rf /var/lib/apt/lists/*; \
    apt clean; \
    fc-cache -f -v;

RUN mkdir -p /workspace; \
    chown -R abc:abc /workspace; \
    chmod g+rws /workspace;
# endregion

USER abc

RUN source /etc/profile.d/01-ensurepath.sh; \
    python3 -m pip install --user pipx; \
    pipx install pre-commit;