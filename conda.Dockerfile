# NOTE: Conda only supports x86_64
ARG VERSION=latest
FROM --platform=${TARGETPLATFORM} continuumio/miniconda3:${VERSION} as conda

# Base Dockerfile for Languages
FROM --platform=${TARGETPLATFORM} lsiodev/ubuntu:focal as base
ARG TARGETPLATFORM
ARG BUILD_DATE
ARG VERSION

LABEL MAINTAINER "John Muchovej <jmuchovej@gmail.com>"
ENV CONTAINER=jmuchovej/conda:${VERSION}

LABEL conda_version=${VERSION}
LABEL build_version="jmuchovej, v${VERSION} on ${BUILD_DATE}"

ENV PATH /opt/conda/bin:$PATH

COPY conda/ /
COPY --from=conda /opt/conda/ /opt/conda

# Switch to ZSH and add Starship to get a slightly more usable shell
RUN    chsh -s /usr/bin/zsh root \
    && curl -fsSL https://starship.rs/install.sh | bash -s -- --yes


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
RUN conda env update -n base -f /root/env.yml

# Install JupyterLab Extensions for a more useful workspace
RUN jupyter labextension install \
        jupyterlab-plotly \
        jupyterlab-tailwind-theme


EXPOSE 8888

# NOTE: Cannot be used because it causes S6 to short-circuit
# ENTRYPOINT ["/app/entrypoint"]

WORKDIR /workspace
