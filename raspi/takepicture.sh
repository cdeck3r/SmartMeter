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
command -v "$SHOT" >/dev/null 2>&1 || { echo >&2 "I require git but it's not installed.  Abort."; exit 1; }

# directory exists?
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


