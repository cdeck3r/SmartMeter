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
# 0: if no maintenance file found -> maintenance mode is: off
# >0: maintenance file found on USB thumb drive -> maintenance mode is: on

# this directory is the script directory
SCRIPT_DIR="$(
    cd "$(dirname "$0")" || exit
    pwd -P
)"
cd "$SCRIPT_DIR" || exit
# shellcheck disable=SC2034
SCRIPT_NAME=$0

# variables
USB_DRIVES=/media/pi
MAINTENANCE_FILE=maintenance

#####################################################
# Include Helper functions
#####################################################

source "${SCRIPT_DIR}/funcs.sh"

#####################################################
# Main program
#####################################################

# First things first
assert_on_raspi

# search for MAINTENANCE_FILE; if found exit with non-zero code
FOUND_MAINTENANCE=$(find ${USB_DRIVES} -type f -name ${MAINTENANCE_FILE} | wc -l)
if [[ ${FOUND_MAINTENANCE} -ne 0 ]]; then
    log_echo "INFO" "Maintenance mode is: on"
    exit 1
fi

# default: we are not in maintenance mode
log_echo "INFO" "Maintenance mode is: off"
exit 0
