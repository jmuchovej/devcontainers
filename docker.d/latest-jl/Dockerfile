FROM --platform=${TARGETPLATFORM} ghcr.io/jmuchovej/baseimage:metabuilder-latest
ARG TARGETPLATFORM
ARG BUILD_DATE

LABEL MAINTAINER "John Muchovej <jmuchovej@pm.me>" \
      CONTAINER "jmuchovej/baseimage:"

USER abc

RUN source /etc/profile.d/01-ensurepath.sh
# region Julia Setup
RUN source /etc/profile.d/01-ensurepath.sh; \
    curl -fsSL https://install.julialang.org | sh -s -- --yes --default-channel 1.8.5; \
# endregion
