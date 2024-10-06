# syntax=docker/dockerfile:1.9
FROM quay.io/jupyter/datascience-notebook@sha256:dca3998d5dcb3fa63cdaf4f7b08f5c14e61baedcaad1bdbb2ac96fb0cc6b224a

SHELL [ "/bin/bash", "-eou", "pipefail", "-c" ]

ENV JULIA_NUM_THREADS="auto"
ENV CONDA_DEFAULT_ENV="base"
ENV CONDA_JL_HOME="${CONDA_DIR}"
ENV JUPYTER_DATA_DIR="${CONDA_JL_HOME}/share/jupyter"

USER root

RUN <<EOF
apt-get update --yes
apt-get install --yes --no-install-recommends \
  neovim \
  tmux \
  zsh
apt-get clean
rm -rf /var/lib/apt/lists/*
chsh ${NB_USER} -s $(which zsh)
EOF

ADD --chown=${NB_UID}:${NB_GID} ./installer /usr/local/bin/installer

RUN <<EOF
installer --depName quarto-dev/quarto-cli --version v1.5.57 --as quarto
installer --depName rclone/rclone --version v1.68.1 --as rclone
installer --depName go-task/task --version v3.39.2 --as task
installer --depName eza-community/eza --version v0.20.1 --as eza
installer --depName direnv/direnv --version v2.34.0 --as direnv
installer --depName jqlang/jq --version jq-1.7.1 --as jq
installer --depName mikefarah/yq --version v4.44.3 --as yq
installer --depName prefix-dev/pixi --version v0.31.0 --as pixi
EOF

RUN <<EOF
conda install -n base conda-libmamba-solver
conda config --set solver libmamba
EOF

ADD --chown=${NB_UID}:${NB_GID} ./startup.jl ${JULIA_PKGDIR}/config/startup.jl
RUN julia <<EOJ
  import Pkg; Pkg.add("IJulia")
EOJ

RUN <<EOF
fix-permissions "${CONDA_DIR}"
fix-permissions "${JULIA_PKGDIR}"
fix-permissions "/home/${NB_USER}"
EOF

USER "${NB_UID}"