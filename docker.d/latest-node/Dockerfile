FROM --platform=${TARGETPLATFORM} ghcr.io/jmuchovej/baseimage:metabuilder-latest
ARG TARGETPLATFORM
ARG BUILD_DATE

LABEL MAINTAINER "John Muchovej <jmuchovej@pm.me>" \
      CONTAINER "jmuchovej/baseimage:"

ENV PYENV_ROOT="/usr/local/pyenv"
ENV NVM_DIR="/usr/local/nvm"
ENV R_HOME="/usr/local/R"
ENV JULIAUP_ROOT="/usr/local/juliaup"
ENV JULIA_ROOT="/usr/local/julia"
ENV JULIA_DEPOT_PATH="${JULIA_ROOT}:${JULIA_DEPOT_PATH}"
ENV PATH="/usr/local/bin:${PATH}"
# region Node.js Setup
ENV PATH="${NVM_DIR}/bin:${PATH}"
RUN mkdir -p ${NVM_DIR}; \
    curl -fsSL -o- https://github.com/nvm-sh/nvm/raw/master/install.sh | bash; \
    \. ${NVM_DIR}/nvm.sh; \
    nvm install 19.6.0; \
    nvm alias default 19.6.0; \
    nvm use default; \
    chmod 2775 ${NVM_DIR} && chown -R abc:abc ${NVM_DIR}; \
    npm install -g pnpm
# endregion
