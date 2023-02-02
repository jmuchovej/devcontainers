FROM --platform=${TARGETPLATFORM} ghcr.io/jmuchovej/baseimage:metabuilder-latest
ARG TARGETPLATFORM
ARG BUILD_DATE

LABEL MAINTAINER "John Muchovej <jmuchovej@pm.me>" \
      CONTAINER "jmuchovej/baseimage:"

ENV PYENV_ROOT="/usr/local/pyenv"
ENV NVM_DIR="/usr/local/nvm"
ENV R_HOME="/usr/local/R"
ENV JULIAUP_ROOT="/usr/local/juliaup"
ENV JULIA_DEPOT_PATH="/usr/local/julia:${JULIA_DEPOT_PATH}"
ENV PATH="/usr/local/bin:${PATH}"
# region Julia Setup
ENV PATH="${JULIAUP_ROOT}/bin:${PATH}"
RUN curl -fsSL https://install.julialang.org \
        | sh -s -- --yes --default-channel 1.8.5;
RUN rsync -av ${HOME}/.juliaup/ ${JULIAUP_ROOT};
RUN chmod 2775 ${JULIAUP_ROOT} ${JULIA_DEPOT_PATH} && chown -R abc:abc ${JULIAUP_ROOT} ${JULIA_DEPOT_PATH}
# endregion
