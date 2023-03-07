# syntax=docker/dockerfile:1.5
#! Dockerfile syntax can be retrieved from https://hub.docker.com/r/docker/dockerfile

FROM --platform=${TARGETARCH} docker.io/library/buildpack-deps:kinetic-scm as chktex-builder
ARG VARIANT="kinetic"
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG CHKTEX_VERSION=1.7.6
ARG CHKTEX_MIRROR="http://download.savannah.gnu.org/releases/chktex"

WORKDIR /tmp/chktex-builder
ENV DEBIANT_FRONTEND noninteractive

RUN <<-EOF
apt update -y
apt install -y --no-install-recommends \
    g++ \
    make
EOF

RUN curl -fL -o- ${CHKTEX_MIRROR}/chktex-${CHKTEX_VERSION}.tar.gz | tar xz --strip-components 1

RUN <<EOF
./configure
make
EOF

#* Use the `kinetic` variant of `buildpack-deps` as the base image, since it includes 
#*   common tools, libraries, and programming languages like `git`, `gcc`, `openssl`, 
#*   `python`, `node`, `julia`, and `R`.
FROM --platform=${TARGETPLATFORM} docker.io/library/buildpack-deps:kinetic-scm
ARG VARIANT="kinetic"
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH

LABEL org.opencontainers.image.authors "John Muchovej <latex-devcontainer.tro05@simplelogin.com>"
LABEL org.opencontainers.image.url \
    "https://github.com/jmuchovej/containers/"
LABEL org.opencontainers.image.documentation \
    "https://github.com/jmuchovej/containers/blob/main/latex/README.md"
LABEL org.opencontainers.image.source \
    "https://github.com/jmuchovej/containers/tree/main/latex"

ARG SCHEME="scheme-basic"
ARG DOCFILES=0
ARG SRCFILES=0
ARG TEXLIVE_VERSION=2022
ARG TEXLIVE_MIRROR="https://mirror.ctan.org/systems/texlive/tlnet"
ARG DEBIAN_FRONTEND="noninteractive"

#! Set environment variables
ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US.UTF-8"
ENV TERM="xterm"
ENV TEXDIR="/usr/local/texlive"
ENV TEXUSERDIR="/texlive-user"

#* Running the following _should_ work, in principal, but Docker doesn't currently
#*   support this form of execution.
# ENV PATH ${TEXDIR}/bin/$(arch)-linux:${PATH}
#!   c.f. https://github.com/docker/docker/issues/29110
ENV PATH ${TEXDIR}/bin/aarch64-linux:${TEXDIR}/bin/x86_64-linux:${PATH}

#! Install base packages that users might need later on
RUN <<EOF
set -e
apt update -y
apt install -y --no-install-recommends \
    fontconfig vim neovim python3-pygments ttf-mscorefonts-installer
apt clean autoclean
apt autoremove -y
rm -rf /var/lib/apt/lists/*
EOF

#! Generate and set default locale
#* This is essentially a combination of the SO answer and the Locale docs on Ubuntu.
#* - https://askubuntu.com/a/89983/585721
#* - https://help.ubuntu.com/community/Locale#Changing_settings_permanently
RUN <<EOF
set -e
apt update -y
apt install -y --no-install-recommends locales
locale-gen ${LANG}
update-locale LANG=${LANG}
apt clean autoclean
apt autoremove -y
rm -rf /var/lib/apt/lists/*
EOF

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
RUN <<EOF
set -e
wget -qO- "${TEXLIVE_MIRROR}/install-tl-unx.tar.gz" | tar xz --strip-components=1
export TEXLIVE_INSTALL_NO_CONTEXT_CACHE=1
export TEXLIVE_INSTALL_NO_WELCOME=1
./install-tl -profile /tmp/texlive/profile.txt \
    -no-interaction -texdir ${TEXDIR} -texuserdir ${TEXUSERDIR}
cd /tmp
rm -rf /tmp/texlive ${TEXDIR}/*.log
EOF

#! Install `latexindent` dependencies
RUN <<EOF
set -e
apt update -y
apt install -y --no-install-recommends cpanminus make gcc libc6-dev
cpanm -n -q Log::Log4perl
cpanm -n -q XString
cpanm -n -q Log::Dispatch::File
cpanm -n -q YAML::Tiny
cpanm -n -q File::HomeDir
cpanm -n -q Unicode::GCString
apt remove -y cpanminus make gcc libc6-dev
apt clean autoclean
apt autoremove -y
rm -rf /var/lib/{apt,dpkg,cache,log}/
EOF

#! Update the TexLive package manager and minimal packages
RUN <<EOF
set -e
tlmgr update --self --all
tlmgr install latexmk latexindent
tlmgr update --all
texhash
EOF

COPY --from=chktex-builder /tmp/chktex-builder/chktex /usr/local/bin/chktex

#! Check that the following commands work and have the right permissions
RUN <<EOF
set -e
tlmgr version
latexmk -version
texhash --version
chktex --version
EOF

WORKDIR /workspace