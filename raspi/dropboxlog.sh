#!/bin/bash

#
# Computes the consumed space for SmartMeter's images
# on Dropbox
#
# Author: cdeck3r
#

# Params: none

# Exit codes
# 1: pre-cond not fulfilled
# 2: network or host problem

# this directory is the script directory
SCRIPT_DIR="$(
    cd "$(dirname "$0")" || exit
    pwd -P
)"
cd "$SCRIPT_DIR" || exit
# shellcheck disable=SC2034
SCRIPT_NAME=$0

# variables
# variables
DBU=${SCRIPT_DIR}/dropbox_uploader.sh
DBU_CFG=~/.dropbox_uploader
DBU_DIR=images

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
command -v "curl" >/dev/null 2>&1 || { echo >&2 "I require curl but it's not installed.  Abort."; exit 1; }

# check connection to dropbox.com
curl -L dropbox.com >/dev/null 2>&1 && { log_echo "INFO" "Website dropbox.com is reachable."; } || { log_echo "ERROR" "Error retrieving dropbox.com.  Abort."; exit 2; }

# Dropbox Uploader exists?
if [ ! -f "${DBU}" ]; then
    log_echo "ERROR" "Abort. Dropbox Uploader not found: ${DBU}"
    exit 1
fi
# Dropbox Uploader executable?
if [ ! -x "${DBU}" ]; then
    log_echo "WARN" "Dropbox Upload not executable. Will make executable: ${DBU}"
    chmod u+x "${DBU}"
fi


# list files, parse sizes and add each up to sum 
# source of awk script: https://stackoverflow.com/a/22630224
DB_SPACE=$("${DBU}" -f "${DBU_CFG}" list "${DBU_DIR}" | cut -d' ' -f3 | grep -P '^\d+' | awk '{ sum += $1; } END { print sum; }')
# output as log line
log_echo "INFO" "Total size of images on Dropbox [bytes]: ${DB_SPACE}"
