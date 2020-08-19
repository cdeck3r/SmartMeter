#!/bin/bash

#
# Maintenance script 
# 
# Checks for a file on a USB thumb drive. 
# If found, returns the a non-zero exit code.
#
# Author: cdeck3r
#

# Params: none

# Exit codes
# 0: if no main
# >0: maintenance file found on USB thumb drive

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

log_echo "WARN" "Maintenance mode not yet implemented yet. Will default to: 0"

# default: we are not in maintenance mode
exit 0
