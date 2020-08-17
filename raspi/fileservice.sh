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

# needed for file management
REMOTE_FILELST=/tmp/remote_flist.txt
LOCAL_FILELST=/tmp/local_flist.txt
BOTH_FILELST=/tmp/both_flist.txt

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

####################################
# File Management
####################################

# list remote files
"${DBU}" -f "${DBU_CFG}" list "${DBU_DIR}" | cut -d' ' -f4 | grep -P '^\d{8}_\d{6}\.png' > "${REMOTE_FILELST}"

# list local files
find "${IMG_DIR}" -type f -printf "%f\n" > "${LOCAL_FILELST}"

# list the files found in both
comm -12 "${REMOTE_FILELST}" "${LOCAL_FILELST}" > "${BOTH_FILELST}"

# we can now safely remove the local files
# not very elegant, but it works
for f in $(cat "${BOTH_FILELST}") ; do 
  rmfile="${IMG_DIR}"/"$f"
  log_echo "INFO" "NOT IMPLEMENTED YET - Delete file: ${rmfile}"
  #rm -rf "${rmfile}"
done

# cleanup
rm -rf "${REMOTE_FILELST}"
rm -rf "${LOCAL_FILELST}"
rm -rf "${BOTH_FILELST}"
