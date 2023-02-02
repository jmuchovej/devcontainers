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
# region Python Setup
ENV PATH="${PYENV_ROOT}/shims:${PYENV_ROOT}/bin:${PATH}"
RUN pip install pipenv; \
    curl https://pyenv.run | bash; \
    ${PYENV_ROOT}/bin/pyenv install 3.11.1; \
    chmod 2775 ${PYENV_ROOT} && chown -R abc:abc ${PYENV_ROOT};
# endregion
