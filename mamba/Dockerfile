ARG CONDA_VERSION
ARG CONDA_BUILD_N
# This formulation is based on how condaforge/mambaforge labels their Docker images
FROM --platform=${TARGETPLATFORM} condaforge/mambaforge:${CONDA_VERSION}-${CONDA_BUILD_N} as mamba

# Base Dockerfile for Languages
FROM --platform=${TARGETPLATFORM} lsiodev/ubuntu:focal as base
ARG TARGETPLATFORM
ARG BUILD_DATE
ARG VERSION
ARG BUILD_N

LABEL MAINTAINER "John Muchovej <john@muchovej.com>"
ENV CONTAINER=jmuchovej/mamba:${VERSION}

LABEL conda_version=${VERSION}
LABEL build_version="jmuchovej, v${VERSION} on ${BUILD_DATE}"

ENV PATH /opt/conda/bin:$PATH

COPY . /
COPY --from=mamba /opt/conda/ /opt/conda

# Switch to ZSH and add Starship to get a slightly more usable shell
RUN    chsh -s /usr/bin/zsh root \
    && curl -fsSL https://starship.rs/install.sh | sh -s -- --yes

# Dependencies needed for `conda` to work
RUN apt-get update && \
    apt-get install -y \
        curl \
        ca-certificates \
        fonts-firacode \
        fontconfig \
        git \
        libglib2.0-0 \
        libsm6 \
        libxext6 \
        libxrender1 \
        mercurial \
        subversion \
        unzip \
        wget \
        zip \
        zsh \
    && apt-get clean \
    && fc-cache -f -v

# Install NodeJS for JupyterLab Extensions
RUN mamba env update -n base -f /root/env.yml

# Install JupyterLab Extensions for a more useful workspace
RUN jupyter labextension install \
        jupyterlab-plotly \
        jupyterlab-tailwind-theme

EXPOSE 8888

# NOTE: Cannot be used because it causes S6 to short-circuit
# ENTRYPOINT ["/app/entrypoint"]

WORKDIR /workspace
