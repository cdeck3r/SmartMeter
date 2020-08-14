#!/bin/bash

#
# Bash script for taking pictures using the
# Raspberry Pi camera module
# 
# Source: https://projects.raspberrypi.org/en/projects/getting-started-with-picamera/3
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
SHOT=raspistill
IMG_DIR=${SCRIPT_DIR}/images
IMG_DATE=$(date '+%Y%m%d_%H%M%S')
IMG_FILE=${IMG_DIR}/${IMG_DATE}.png


#####################################################
# Helper functions
#####################################################
#
# logging on stdout
# Param #1: log level, e.g. INFO, WARN, ERROR
# Param #2: log message
log_echo () {
    LOG_LEVEL=$1
    LOG_MSG=$2
    TS=$(date '+%Y-%m-%d %H:%M:%S,%s')
    echo "$TS - $SCRIPT_NAME - $LOG_LEVEL - $LOG_MSG"
}

#####################################################
# Main program
#####################################################

# First things first

# check we are on Raspi
MACHINE=$(uname -m)
if [[ "$MACHINE" != arm* ]]; then
    log_echo "ERROR" "We are not on an arm plattform: ${MACHINE}"
    exit 1
fi 

# Source: https://stackoverflow.com/a/677212
command -v "$SHOT" >/dev/null 2>&1 || { echo >&2 "I require git but it's not installed.  Abort."; exit 1; }

if [ ! -d "${IMG_DIR}" ]; then
    log_echo "WARN" "Image dir does not exist. Create dir: ${IMG_DIR}"
    mkdir -p "${IMG_DIR}"
fi

# take the picture
"${SHOT}" -o "${IMG_FILE}"
if [ -f ${IMG_FILE} ]; then
    log_echo "INFO" "Picture successfully taken: ${IMG_FILE}"
else
    log_echo "ERROR" "Failed to take picture: ${IMG_FILE}"
fi


