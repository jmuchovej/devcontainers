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
# region R Setup
ENV PATH="${R_HOME}/bin:${PATH}"
RUN mkdir -p ${R_HOME}; \
    apt update -yq; \
    apt install \
        r-base=4.2.2-* \
        r-base-dev=4.2.2-* \
            r-base-core=4.2.2-* \
        r-recommended=4.2.2-* \
    ; \
    rm -rf /var/lib/apt/lists/*; \
    apt clean; \
    chmod 2775 ${R_HOME} && chown -R abc:abc ${R_HOME};
# endregion
