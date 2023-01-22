FROM --platform=${TARGETPLATFORM} ghcr.io/jmuchovej/baseimage:metabuilder-latest
ARG TARGETPLATFORM
ARG BUILD_DATE

LABEL MAINTAINER "John Muchovej <jmuchovej@pm.me>" \
      CONTAINER "jmuchovej/baseimage:"

USER abc

RUN source /etc/profile.d/01-ensurepath.sh
# region Node.js Setup
RUN curl -o- https://github.com/nvm-sh/nvm/raw/master/install.sh | NVM_DIR=${NVM_DIR} bash; \
    source ${NVM_DIR}/nvm.sh; \
    nvm install 19.4.0; \
    nvm alias default 19.4.0; 
# endregion
