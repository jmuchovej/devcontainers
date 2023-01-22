FROM --platform=${TARGETPLATFORM} ghcr.io/jmuchovej/baseimage:metabuilder-latest
ARG TARGETPLATFORM
ARG BUILD_DATE

LABEL MAINTAINER "John Muchovej <jmuchovej@pm.me>" \
      CONTAINER "jmuchovej/baseimage:"

USER abc

RUN source /etc/profile.d/01-ensurepath.sh
# region R Setup
RUN apt install \
        r-base=4.2.2-* \
        r-base-dev=4.2.2-* \
            r-base-core=4.2.2-* \
        r-recommended=4.2.2-* \
    ; \
    rm -rf /var/lib/apt/lists/*; \
    apt clean; \
# endregion
