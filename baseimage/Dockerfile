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
        python3-pip \
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
    fc-cache -f -v;

RUN mkdir -p /workspace; \
    chown -R abc:abc /workspace; \
    chmod g+rws /workspace; \
    mkdir -p /home/abc; \
    usermod -m -d /home/abc abc;
# endregion

USER abc

RUN HOME="/home/abc" . /etc/profile.d/01-ensurepath.sh; \
    python3 -m pip install --user pipx; \
    pipx install pre-commit;