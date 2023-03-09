#!/usr/bin/env bash

echoerr() {
  echo >&2 -e "\033[0;31m$1\033[0m"
}

install_debian_packages() {
  export DEBIAN_FRONTEND=noninteractive

  local package_list="\
    ca-certificates \
    curl \
    git \
    jq
  "
  rm -rf /var/lib/apt/lists/*
  apt-get update -y
  apt-get install -y --no-install-recommends ${package_list}

  apt-get clean -y
  rm -rf /var/lib/apt/lists/*
}

install_redhat_packages() {
  local package_list="\
    ca-certificates \
    jq
  "

  # rockylinux:9 installs 'curl-minimal' which clashes with 'curl'
  # Install 'curl' for every OS except this rockylinux:9
  if [[ "${ID}" = "rocky" ]] && [[ "${VERSION}" != *"9."* ]]; then
      package_list="${package_list} curl"
  fi

  # Install git if not already installed (may be more recent than distro version)
  if ! type git > /dev/null 2>&1; then
      package_list="${package_list} git"
  fi

  local install_cmd=dnf
  if ! type dnf > /dev/null 2>&1; then
      install_cmd=yum
  fi
  ${install_cmd} -y install ${package_list}
}

install_alpine_packages() {
  apk update
  apk add --no-cache \
    ca-certificates \
    curl \
    jq

  # Install git if not already installed (may be more recent than distro version)
  if ! type git > /dev/null 2>&1; then
      apk add --no-cache git
  fi
}

# Pulled from https://github.com/devcontainers/features/blob/5d6f1ae9b93ca3e2ddb9c71c642e4e9204426e3c/src/common-utils/main.sh#L293-L305
# Bring in ID, ID_LIKE, VERSION_ID, VERSION_CODENAME
. /etc/os-release
# Get an adjusted ID independent of distro variants
if [ "${ID}" = "debian" ] || [ "${ID_LIKE}" = "debian" ]; then
    ADJUSTED_ID="debian"
elif [[ "${ID}" = "rhel" || "${ID}" = "fedora" || "${ID}" = "mariner" || "${ID_LIKE}" = *"rhel"* || "${ID_LIKE}" = *"fedora"* || "${ID_LIKE}" = *"mariner"* ]]; then
    ADJUSTED_ID="rhel"
elif [ "${ID}" = "alpine" ]; then
    ADJUSTED_ID="alpine"
else
    echo "Linux distro ${ID} not supported."
    exit 1
fi

install_deps() {
  case "${ADJUSTED_ID}" in
    "debian")
        install_debian_packages
        ;;
    "rhel")
        install_redhat_packages
        ;;
    "alpine")
        install_alpine_packages
        ;;
  esac
}