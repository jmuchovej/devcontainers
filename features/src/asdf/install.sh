#!/usr/bin/env sh
set -e

ASDF_VERSION="${VERSION:-"latest"}"
# ASDF_DIR="${ASDF_DIR:-"/opt/asdf-vm"}"

. "$(dirname $0)/utils.sh"
install_deps

if [ "$(id -u)" -ne 0 ]; then
	echo -e "Script must be run as root."
    echo -e "Use \`sudo\`, \`su\`, or add \`USER root\` to your Dockerfile before running this script."
	exit 1
fi

if [ ! -f "${ASDF_DIR}/asdf.sh" ]; then
    git clone https://github.com/asdf-vm/asdf.git ${ASDF_DIR}
    if test "${ASDF_VERSION}" != "develop"; then
        cd ${ASDF_DIR}
        if test "${ASDF_VERSION}" = "latest"; then
            ASDF_VERSION="$(git tag --sort v:refname | tail -1)"
        fi
        git -c advice.detachedHead=false checkout ${ASDF_VERSION}
    fi

    # Ensure that's it's world-readable so non-root users can access
    chmod 755 ${ASDF_DIR}
    . ${ASDF_DIR}/asdf.sh
    asdf version
fi

cat <<'EOF' > /usr/local/bin/asdf-install-plugins.sh
#!/usr/bin/env bash
set -e

. ${ASDF_DIR}/asdf.sh

# TODO allow `/workspaces` to be dynamically set/inferred
find /workspaces -type d -path "*/.*" -prune -o -name "*.tool-version*" -print | while read ${filepath}; do
    echo -e "Setting up \`asdf\` for ${filepath}"

    # Install plugins based on `.tool-versions` contents (ignoring comments)
    grep -v "^\#" ${filepath} | cut -d " " -f 1 | xargs -n1 asdf plugin add

    # Install relevant .tool-versions at \${filepath}
    cd $(dirname ${filepath}) && asdf install
done
EOF

chmod +x /usr/local/bin/asdf-install-plugins.sh