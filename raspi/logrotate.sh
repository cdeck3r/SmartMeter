#!/bin/bash

#
# lograte script 
# 
# Manages logfiles of the SmartMeter camera software 
#
# Author: cdeck3r
#

# Params: none

# Exit codes: none

# this directory is the script directory
SCRIPT_DIR="$(
    cd "$(dirname "$0")" || exit
    pwd -P
)"
cd "$SCRIPT_DIR" || exit
# shellcheck disable=SC2034
SCRIPT_NAME=$0

# variables
# none

#####################################################
# Include Helper functions
#####################################################

source "${SCRIPT_DIR}/funcs.sh"

#####################################################
# Main program
#####################################################

# First things first
assert_on_raspi

log_echo "WARN" "lograte not implemented yet."
exit 0
