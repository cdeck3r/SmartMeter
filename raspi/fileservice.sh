#!/bin/bash

#
# Bash script for uploading pictures to Dropbox
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
DBU=${SCRIPT_DIR}/dropbox_uploader.sh
DBU_CFG=~/.dropbox_uploader
IMG_DIR=${SCRIPT_DIR}/images
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
# directory exists?
if [ ! -d "${IMG_DIR}" ]; then
    log_echo "ERROR" "Abort. Image dir does not exist: ${IMG_DIR}"
    exit 1
fi

# let's upload 
# skip if file already exist on dropbox
for img_file in "${IMG_DIR}"/*.png; do
    fname=$(basename "${img_file}")
    "${DBU}" -f "${DBU_CFG}" -s upload "$img_file" "${DBU_DIR}/${fname}"
done

