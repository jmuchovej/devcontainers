# syntax=docker/dockerfile:1.9
# renovate: datasource=custom.chktex depName=chktex
ARG CHKTEX_VERSION="1.7.6"
# renovate: datasource=custom.texlive depName=texlive
ARG TEXLIVE_VERSION="2022"

ARG TEXDIR="/usr/local/texlive"
ARG TEXUSERDIR="/texlive-user"

ARG CHKTEX_MIRROR="http://download.savannah.gnu.org/releases/chktex"
ARG TEXLIVE_MIRROR="https://ftp.math.utah.edu/pub/tex/historic/systems/texlive"

ARG SCHEME="scheme-basic"
ARG DOCFILES=0
ARG SRCFILES=0

#region chktex Builder Stage ############################################################
FROM mcr.microsoft.com/devcontainers/base:jammy AS chktex-builder
ARG CHKTEX_MIRROR
ARG CHKTEX_VERSION
ENV DEBIAN_FRONTEND="noninteractive"

SHELL [ "/bin/bash", "-c" ]

WORKDIR /tmp/chktex-builder

RUN curl -qfL -o- "${CHKTEX_MIRROR}/chktex-${CHKTEX_VERSION}.tar.gz" \
    | tar xz --strip-components 1

RUN ./configure
RUN make
#endregion ##############################################################################

#region TeXLive Builder Stage ###########################################################
FROM mcr.microsoft.com/devcontainers/base:jammy AS texlive-builder
ARG TEXLIVE_VERSION
ARG TEXLIVE_MIRROR
ARG TEXDIR
ARG TEXUSERDIR
ARG SCHEME
ARG DOCFILES
ARG SRCFILES

SHELL [ "/bin/bash", "-c" ]

#! Set environment variables
ENV DEBIAN_FRONTEND="noninteractive"
ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US.UTF-8"
ENV TERM="xterm"

#* Running the following _should_ work, in principal, but Docker doesn't currently
#*   support this form of execution.
# ENV PATH ${TEXDIR}/bin/$(arch)-linux:${PATH}
#!   c.f. https://github.com/docker/docker/issues/29110
ENV PATH=${TEXDIR}/bin/aarch64-linux:${TEXDIR}/bin/x86_64-linux:${PATH}

#! Generate and set default locale
#* This is essentially a combination of the SO answer and the Locale docs on Ubuntu.
#* - https://askubuntu.com/a/89983/585721
#* - https://help.ubuntu.com/community/Locale#Changing_settings_permanently
RUN apt update -y && apt install -y --no-install-recommends locales
RUN locale-gen "${LANG}" && update-locale LANG=${LANG}

#! Move to /tmp/texlive so we can properly build and configure TeX, then clean-up
WORKDIR /tmp/texlive

#* Contents of `./profile.txt` sourced from https://tug.org/texlive/doc/install-tl.html
#* Using heredocs for `./profile.txt` -- https://stackoverflow.com/a/2954835/2714651
#* The acceptable contents of `./profile.txt` can be found here:
#*   https://tug.org/texlive/doc/install-tl.html#PROFILES
COPY <<EOF /tmp/texlive/profile.txt
selected_scheme ${SCHEME}
instopt_letter 1  # Set default page size to letter
instopt_adjustpath 0
tlpdbopt_autobackup 0
tlpdbopt_desktop_integration 0
tlpdbopt_file_assocs 0
tlpdbopt_install_docfiles ${DOCFILES}
tlpdbopt_install_srcfiles ${SRCFILES}
EOF

#* The installation process is essentially copy-paste of "tl;dr: Unix(ish)" from:
#*   https://tug.org/texlive/quickinstall.html
ENV TEXLIVE_INSTALL_NO_WELCOME=1
ENV TEXLIVE_INSTALL_NO_CONTEXT_CACHE=1

RUN <<-EOF
path="$([ "$(date +%Y)" != "${TEXLIVE_VERSION}" ] && echo "${TEXLIVE_VERSION}/tlnet-final" || echo "${TEXLIVE_VERSION}")"
curl -qfL -o- "${TEXLIVE_MIRROR}/${path}/install-tl-unx.tar.gz" \
  | tar xz --strip-components=1

#! This prevents the `COPY --from=texlive-builder ...` directives from failing.
mkdir -p "${TEXDIR}" "${TEXUSERDIR}"
EOF

RUN <<-EOF
path="$([ "$(date +%Y)" != "${TEXLIVE_VERSION}" ] && echo "${TEXLIVE_VERSION}/tlnet-final" || echo "${TEXLIVE_VERSION}")"
./install-tl --no-interaction --texdir ${TEXDIR} --texuserdir ${TEXUSERDIR} \
    -profile /tmp/texlive/profile.txt \
    -repository "${TEXLIVE_MIRROR}/${path}"
EOF
#endregion ##############################################################################

#region Output Stage ####################################################################
FROM mcr.microsoft.com/devcontainers/base:jammy AS output
ENV DEBIAN_FRONTEND="noninteractive"
ARG TEXDIR
ARG TEXUSERDIR
ARG TEXLIVE_VERSION
ARG CHKTEX_VERSION
LABEL org.opencontainers.image.source="https://github.com/jmuchovej/devcontainers"
LABEL org.opencontainers.image.authors="John Muchovej <jmuchovej@pm.me>"
LABEL org.opencontainers.image.url="https://github.com/jmuchovej/devcontainers/tree/main/src/templates/latex"
LABEL org.opencontainers.image.documentation="https://github.com/jmuchovej/devcontainers/tree/main/src/templates/latex/README.md"
LABEL org.opencontainers.image.title="LaTeX Devcontainer with TexLive ${TEXLIVE_VERSION} & chktex ${CHKTEX_VERSION}"

#! Set environment variables
ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US.UTF-8"
ENV TERM="xterm"

#* Running the following _should_ work, in principal, but Docker doesn't currently
#*   support this form of execution.
# ENV PATH ${TEXDIR}/bin/$(arch)-linux:${PATH}
#!   c.f. https://github.com/docker/docker/issues/29110
ENV PATH=${TEXDIR}/bin/aarch64-linux:${TEXDIR}/bin/x86_64-linux:${PATH}

SHELL [ "/bin/bash", "-c" ]

COPY --from=chktex-builder /tmp/chktex-builder/chktex /usr/local/bin/chktex
COPY --from=texlive-builder "${TEXDIR}" "${TEXDIR}"
COPY --from=texlive-builder "${TEXUSERDIR}" "${TEXUSERDIR}"

#! Install base packages that users might need later on
RUN <<EOF
set -e
apt update -y
apt install -y --no-install-recommends \
    fontconfig vim neovim python3-pygments ttf-mscorefonts-installer \
    locales
apt clean autoclean
apt autoremove -y
rm -rf /var/lib/apt/lists/*
locale-gen "${LANG}" && update-locale LANG=${LANG}
EOF

#! Install `latexindent` and `latexmk` dependencies
RUN <<EOF
apt update -y
apt install -y --no-install-recommends cpanminus
cpanm -n -q Log::Log4perl XString Log::Dispatch::File YAML::Tiny File::HomeDir Unicode::GCString
apt autoclean
apt autoremove -y
rm -rf /var/lib/{apt,dpkg,cache,log}/
EOF

#! Update the TexLive package manager and minimal packages
RUN <<EOF
tlmgr update --self --all
tlmgr install latexmk latexindent
tlmgr update --all
texhash
EOF

#! Check that the following commands work and have the right permissions
# TODO just pull this out into a devcontainer test?
# RUN tlmgr version
# RUN latexmk -version
# RUN texhash --version
# RUN chktex --version

WORKDIR /workspace
#endregion ##############################################################################