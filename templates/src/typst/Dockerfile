# syntax=docker/dockerfile:1.5
#! Dockerfile syntax can be retrieved from https://hub.docker.com/r/docker/dockerfile
#* Use a variant of `mcr.microsoft.com/devcontainers/rust` which is compatible with the
#*   MAJOR version of Rust used by the Typst project!
ARG VARIANT
ARG TYPST_VERSION
ARG TYPSTYLE_VERSION

#region Typst Builder Stage #############################################################
FROM mcr.microsoft.com/devcontainers/rust:${VARIANT} as typst-builder
ARG TYPST_VERSION
ENV CARGO_REGISTRIES_CRATES_IO_PROTOCOL="sparse"

RUN git clone --branch ${TYPST_VERSION} --depth 1 https://github.com/typst/typst.git /typst
WORKDIR /typst
RUN cargo update
RUN cargo build -p typst-cli --release
#endregion ##############################################################################

#region Typstyle Builder Stage ##########################################################
FROM mcr.microsoft.com/devcontainers/rust:${VARIANT} as typstyle-builder
ARG TYPSTYLE_VERSION

RUN git clone --branch ${TYPSTYLE_VERSION} --depth 1 https://github.com/Enter-tainer/typstyle/ /typstyle
WORKDIR /typstyle
RUN cargo update
RUN cargo build --release
#endregion ##############################################################################

#region Output Stage ####################################################################
FROM mcr.microsoft.com/devcontainers/rust:${VARIANT} as output

LABEL org.opencontainers.image.authors "John Muchovej <jmuchovej@users.noreply.github.com>"
LABEL org.opencontainers.image.url "https://github.com/jmuchovej/devcontainers/tree/main/src/templates/typst"
LABEL org.opencontainers.image.documentation \
    "https://github.com/jmuchovej/devcontainers/blob/main/src/templates/typst/README.md"
LABEL org.opencontainers.image.source \
    "https://github.com/jmuchovej/devcontainers"

COPY --from=typst-builder /typst/target/release/typst /usr/local/bin/typst
# TODO add support for Typestyle (directly within the container)!
# COPY --from=typstyle-builder /typst/target/release/typstyle /usr/local/bin/typstyle
#endregion ##############################################################################