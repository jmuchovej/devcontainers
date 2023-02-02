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
# region Python Setup
ENV PATH="${PYENV_ROOT}/shims:${PYENV_ROOT}/bin:${PATH}"
RUN pip install pipenv;
RUN curl https://pyenv.run | bash;
RUN ${PYENV_ROOT}/bin/pyenv install 3.11.1 
RUN chmod 2775 ${PYENV_ROOT} && chown -R abc:abc ${PYENV_ROOT}
# endregion

# region Julia Setup
ENV PATH="${JULIAUP_ROOT}/bin:${PATH}"
RUN curl -fsSL https://install.julialang.org \
        | sh -s -- --yes --default-channel 1.6.7;
RUN rsync -av ${HOME}/.juliaup/ ${JULIAUP_ROOT};
RUN chmod 2775 ${JULIAUP_ROOT} ${JULIA_DEPOT_PATH} && chown -R abc:abc ${JULIAUP_ROOT} ${JULIA_DEPOT_PATH}
# endregion

# region R Setup
ENV PATH="${R_HOME}/bin:${PATH}"
RUN apt update -yq;
RUN apt install \
        r-base=4.2.2-* \
        r-base-dev=4.2.2-* \
            r-base-core=4.2.2-* \
        r-recommended=4.2.2-* \
    ;
RUN rm -rf /var/lib/apt/lists/*;
RUN apt clean;
RUN chmod 2775 ${R_HOME} && chown -R abc:abc ${R_HOME}
# endregion

# region Node.js Setup
ENV PATH="${NVM_DIR}/bin:${PATH}"
RUN curl -o- https://github.com/nvm-sh/nvm/raw/master/install.sh | bash;
RUN echo $(ls -la ${NVM_DIR});
RUN \. ${NVM_DIR}/nvm.sh;
RUN nvm install 18.7.0;
RUN nvm alias default 18.7.0;
RUN nvm use default
RUN chmod 2775 ${NVM_DIR} && chown -R abc:abc ${NVM_DIR}
# endregion