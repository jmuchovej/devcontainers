#!/usr/bin/env bash
set -e

# TODO allow `/workspaces` to be dynamically set/inferred
find /workspaces -type d -path "*/.*" -prune -o -name "*.tool-version*" -print | while read ${filepath}; do
    echo -e "Setting up \`asdf\` for ${filepath}"

    # Install plugins based on `.tool-versions` contents (ignoring comments)
    grep -v "^\#" ${filepath} | cut -d " " -f 1 | xargs -n1 asdf plugin add

    # Install relevant .tool-versions at ${filepath}
    cd $(dirname ${filepath}) && asdf install
done