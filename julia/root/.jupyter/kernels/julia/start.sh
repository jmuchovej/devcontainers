#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Missing the connection file as first parameter"
    exit 1
fi

# This thing should be a full path by Jupyter
connection_file=$1

# Get the port number out
# Here we assume the local machine has JQ installed
CONTROL_PORT=$(jq '.control_port' < $connection_file)
SHELL_PORT=$(jq '.shell_port' < $connection_file)
STDIN_PORT=$(jq '.stdin_port' < $connection_file)
HB_PORT=$(jq '.hb_port' < $connection_file)
IOPUB_PORT=$(jq '.iopub_port' < $connection_file)

echo control ${CONTROL_PORT}
echo shell ${SHELL_PORT}
echo stdin ${STDIN_PORT}
echo hb ${HB_PORT}
echo iopub ${IOPUB_PORT}

sed -i.bu 's;127.0.0.1;0.0.0.0;' "${connection_file}"

cat $connection_file

/app/kernel ${connection_file}