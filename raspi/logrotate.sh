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
LOG_DIR=${SCRIPT_DIR}/log
CONF_FILE=${SCRIPT_DIR}/logrotate.conf
STATE_FILE=${LOG_DIR}/logrotate.state
LOG_FILE=${LOG_DIR}/logrotate.log

# logfile upload
DBU=${SCRIPT_DIR}/dropbox_uploader.sh
DBU_CFG=~/.dropbox_uploader
DBU_DIR=log

#####################################################
# Include Helper functions
#####################################################

source "${SCRIPT_DIR}/funcs.sh"

#####################################################
# Main program
#####################################################

# First things first
assert_on_raspi

log_echo "INFO" "logrotate starts: ${HOME}/smartmeter/log"
/usr/sbin/logrotate -s "${STATE_FILE}" -l "${LOG_FILE}" "${CONF_FILE}"


# let's upload compressed logfiles
# skip if file already exist on dropbox
for compress_logfile in "${LOG_DIR}"/*.bz2; do
    fname=$(basename "${compress_logfile}")
    log_echo "INFO" "Upload to Dropbox: ${fname}"
    "${DBU}" -f "${DBU_CFG}" -s upload "${compress_logfile}" "${DBU_DIR}/${fname}"
done

# let's upload current logfiles
# overwrite, if exists
for logfile in "${LOG_DIR}"/*.log; do
    fname=$(basename "${logfile}")
    log_echo "INFO" "Upload to Dropbox: ${fname}"
    "${DBU}" -f "${DBU_CFG}" upload "${logfile}" "${DBU_DIR}/${fname}"
done
