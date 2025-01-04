#!/bin/bash

SCRIPT_NAME=`basename -s .sh $0`
SCRIPT_ROOT="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
PROJECT_ROOT="${SCRIPT_ROOT}/.."
verible-verilog-ls --flagfile="${PROJECT_ROOT}/verible.flags"
