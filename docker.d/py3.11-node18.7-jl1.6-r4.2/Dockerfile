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

# region Julia Setup
RUN source /etc/profile.d/01-ensurepath.sh; \
    curl -fsSL https://install.julialang.org | sh -s -- --yes --default-channel 1.6.7; \
# endregion

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

# region Node.js Setup
RUN curl -o- https://github.com/nvm-sh/nvm/raw/master/install.sh | NVM_DIR=${NVM_DIR} bash; \
    source ${NVM_DIR}/nvm.sh; \
    nvm install 18.7.0; \
    nvm alias default 18.7.0; 
# endregion