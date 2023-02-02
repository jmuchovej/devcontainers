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
# region Node.js Setup
ENV PATH="${NVM_DIR}/bin:${PATH}"
RUN curl -o- https://github.com/nvm-sh/nvm/raw/master/install.sh | bash;
RUN echo $(ls -la ${NVM_DIR});
RUN \. ${NVM_DIR}/nvm.sh;
RUN nvm install 19.5.0;
RUN nvm alias default 19.5.0;
RUN nvm use default
RUN chmod 2775 ${NVM_DIR} && chown -R abc:abc ${NVM_DIR}
# endregion
