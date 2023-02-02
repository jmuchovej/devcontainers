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
    ${PYENV_ROOT}/bin/pyenv install 3.10.9; \
    chmod 2775 ${PYENV_ROOT} && chown -R abc:abc ${PYENV_ROOT};
# endregion

# region Julia Setup
ENV PATH="${JULIAUP_ROOT}/bin:${PATH}"
RUN curl -fsSL https://install.julialang.org \
        | sh -s -- --yes --default-channel 1.8.5; \
    rsync -av ${HOME}/.juliaup/ ${JULIAUP_ROOT}; \
    chmod 2775 ${JULIAUP_ROOT} ${JULIA_ROOT} && chown -R abc:abc ${JULIAUP_ROOT} ${JULIA_ROOT};
# endregion

# region R Setup
ENV PATH="${R_HOME}/bin:${PATH}"
RUN mkdir -p ${R_HOME}; \
    apt update -yq; \
    apt install \
        r-base=4.1.3-* \
        r-base-dev=4.1.3-* \
            r-base-core=4.1.3-* \
        r-recommended=4.1.3-* \
    ; \
    rm -rf /var/lib/apt/lists/*; \
    apt clean; \
    chmod 2775 ${R_HOME} && chown -R abc:abc ${R_HOME};
# endregion

# region Node.js Setup
ENV PATH="${NVM_DIR}/bin:${PATH}"
RUN mkdir -p ${NVM_DIR}; \
    curl -fsSL -o- https://github.com/nvm-sh/nvm/raw/master/install.sh | bash; \
    \. ${NVM_DIR}/nvm.sh; \
    nvm install 18.2.0; \
    nvm alias default 18.2.0; \
    nvm use default; \
    chmod 2775 ${NVM_DIR} && chown -R abc:abc ${NVM_DIR};
# endregion
