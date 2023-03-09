#!/bin/bash
set -e

latestRelease="$(curl -s https://api.github.com/repos/asdf-vm/asdf/releases | jq -r ".[0].tag_name")"

$(dirname $0)/run-tests.sh ${latestRelease}