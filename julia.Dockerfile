ARG VERSION
ARG CONDA_VERSION

FROM --platform=${TARGETPLATFORM} julia:${VERSION} as julia

# Copy Julia and Setup for Probmods.jl Container ------------------------------
FROM --platform=${TARGETPLATFORM} jmuchovej/conda:${CONDA_VERSION} as custom-julia
ARG TARGETPLATFORM
ARG CONDA_VERSION
ARG BUILD_DATE
ARG VERSION

LABEL maintainer "John Muchovej <jmuchovej@gmail.com>"
LABEL julia_version=${VERSION}
LABEL build_version="jmuchovej, v${VERSION} on ${BUILD_DATE} using conda v${CONDA_VERSION}"

ENV CONTAINER=jmuchovej/conda:${VERSION}

ENV JUlIA_VERSION ${VERSION}
ENV JULIA_BINDIR /usr/local/julia/bin
ENV JULIA_DEPOT_PATH /root/.julia
ENV JULIA_LOAD_PATH "@base:@:@stdlib"

ENV PATH ${JULIA_BINDIR}:${PATH}

COPY --from=julia /usr/local/julia/ /usr/local/julia/
ADD julia/ /

# Install dependencies from `Project.toml`
RUN julia -O3 /app/install.jl
