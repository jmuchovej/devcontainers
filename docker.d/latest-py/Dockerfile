FROM --platform=${TARGETPLATFORM} ghcr.io/jmuchovej/baseimage:metabuilder-latest
ARG TARGETPLATFORM
ARG BUILD_DATE

LABEL MAINTAINER "John Muchovej <jmuchovej@pm.me>" \
      CONTAINER "jmuchovej/baseimage:"

USER abc

RUN source /etc/profile.d/01-ensurepath.sh
# region Python Setup
RUN pipx install pipenv; \
    curl https://pyenv.run | PYENV_ROOT=${PYENV_ROOT} bash; \
    pyenv install 3.11.1 
# endregion
