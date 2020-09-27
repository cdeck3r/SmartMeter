#!/bin/bash

#
# Temperature logging
#
# Measures the temperature and output as log line
#
# Author: cdeck3r
#

# this directory is the script directory
SCRIPT_DIR="$(
    cd "$(dirname "$0")" || exit
    pwd -P
)"
cd "$SCRIPT_DIR" || exit
# shellcheck disable=SC2034
SCRIPT_NAME=$0

# variables
# None

#####################################################
# Include Helper functions
#####################################################

source "${SCRIPT_DIR}/funcs.sh"

#####################################################
# Main program
#####################################################

# First things first
assert_on_raspi

# check for installed program
# Source: https://stackoverflow.com/a/677212
command -v "vcgencmd" >/dev/null 2>&1 || { echo >&2 "I require vcgencmd, but it's not installed.  Abort."; exit 1; }

# measure temp in celcius
# Source: https://linuxhint.com/raspberry_pi_temperature_monitor/
CURRENT_TEMP=$(vcgencmd measure_temp | egrep -o '[0-9]*\.[0-9]*')
# output as log
log_echo "INFO" "Temperature in celcius: ${CURRENT_TEMP}"


