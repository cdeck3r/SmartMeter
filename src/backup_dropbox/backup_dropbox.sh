#!/bin/bash

#
# Backup images from Dropbox
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
DBU=${SCRIPT_DIR}/dropbox_uploader.sh
DBU_CFG=/SmartMeterRepo/.dropbox_uploader # File is not part of the Repo
IMG_DIR=/SmartMeterRepo/images
DBU_DIR=images

# needed for file management
REMOTE_FILELST=/tmp/remote_flist.txt
LOCAL_FILELST=/tmp/local_flist.txt
BOTH_FILELST=/tmp/both_flist.txt

#####################################################
# Include Helper functions
#####################################################

source "${SCRIPT_DIR}/funcs.sh"

cleanup() {
    # cleanup
    rm -rf "${REMOTE_FILELST}"
    rm -rf "${LOCAL_FILELST}"
    rm -rf "${BOTH_FILELST}"
}

#####################################################
# Main program
#####################################################

# first things first
assert_in_docker

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
# directory exists?
if [ ! -d "${IMG_DIR}" ]; then
    log_echo "ERROR" "Abort. Image dir does not exist: ${IMG_DIR}"
    exit 1
fi

# download all image list
log_echo "INFO" "Download image list: ${REMOTE_FILELST}"
"${DBU}" -f "${DBU_CFG}" list "${DBU_DIR}" | sed 's/\s\s*/ /g' | cut -d' ' -f3,4 | grep -P '^\d+\s\d{8}_\d{6}\.png' | sort > "${REMOTE_FILELST}"

# test number of files on Dropbox
remote_flist_count=$(cat "${REMOTE_FILELST}" | wc -l)
if [ "$remote_flist_count" -eq 0 ]; then
    log_echo "INFO" "No files found on Dropbox. Stop."
    cleanup
    exit 0
fi

# download all images  
for img_file in $(cat "${REMOTE_FILELST}" | cut -d' ' -f2); do
    log_echo "INFO" "Download from Dropbox: ${img_file}"
    "${DBU}" -f "${DBU_CFG}" download "${DBU_DIR}/${img_file}" "${IMG_DIR}/${img_file}"
done

####################################
# File Management
####################################

# we have downloaded the remote list previously
# ${REMOTE_FILELST}

# list local files
find "${IMG_DIR}" -type f -printf "%s %f\n" | sort > "${LOCAL_FILELST}"

# list the files found in both
comm -12 "${REMOTE_FILELST}" "${LOCAL_FILELST}" > "${BOTH_FILELST}"

# test number of common files 
both_flist_count=$(cat "${BOTH_FILELST}" | wc -l)
if [ "$both_flist_count" -eq 0 ]; then
    log_echo "INFO" "No files to delete found. Stop."
    cleanup
    exit 0
fi

# we can now safely remove the remote files
for f in $(cat "${BOTH_FILELST}" | cut -d' ' -f2) ; do 
  rmfile="${DBU_DIR}"/"$f"
  log_echo "INFO" "Delete file on Dropbox: ${rmfile}"
  "${DBU}" -f "${DBU_CFG}" delete "${rmfile}"
done

# cleanup
cleanup
