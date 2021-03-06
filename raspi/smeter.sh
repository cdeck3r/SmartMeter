#!/bin/bash

#
# Central script controlling the Smart Meter camera system
# 
# Author: cdeck3r
#
# It consists of the following steps:
# 1. check maintenance mode
# 2. take picture
# 3. upload files to dropbox
# 4. shutdown
#
# We assume all scripts are in the SCRIPT_DIR

# Params: none
# Exit codes: 
# 0: all ok
# 1: if script could not be started

# this directory is the script directory
SCRIPT_DIR="$(
    cd "$(dirname "$0")" || exit
    pwd -P
)"
cd "$SCRIPT_DIR" || exit
# shellcheck disable=SC2034
SCRIPT_NAME=$0

# variables
LOG_DIR="${SCRIPT_DIR}"/log
IMG_DIR="${SCRIPT_DIR}"/images

#####################################################
# Include Helper functions
#####################################################
source "${SCRIPT_DIR}/funcs.sh"

# source: https://www.raspberrypi.org/forums/viewtopic.php?f=29&t=162539#p1051587
# Note: This will also switch off the ethernet adapter
light_off () {
    echo '1-1' | sudo tee /sys/bus/usb/drivers/usb/unbind
}

light_on () {
    echo '1-1' | sudo tee /sys/bus/usb/drivers/usb/bind
}

#####################################################
# Main program
#####################################################

# First things first
assert_on_raspi

# create necessary directories
mkdir -p "${IMG_DIR}"
mkdir -p "${LOG_DIR}"

# here we go
log_echo "INFO" "SmartMeter camera system starts."

# check maintenance mode
if [ -x "${SCRIPT_DIR}"/maintenance.sh ]; then 
    "${SCRIPT_DIR}"/maintenance.sh
    MAINTENANCE_MODE=$?
else
    log_echo "ERROR" "Could not start script: ${SCRIPT_DIR}/maintenance.sh"
    exit 1
fi

# iterate three times at 0, 15, 30 min
for (( c=1; c<=3; c++ ))
do
    # take picture
    light_on
    if [ -x "${SCRIPT_DIR}"/takepicture.sh ]; then 
        "${SCRIPT_DIR}"/takepicture.sh
    else
        log_echo "ERROR" "Could not start script: ${SCRIPT_DIR}/takepicture.sh"
        exit 1
    fi
    light_off

    # upload to dropbox    
    "${SCRIPT_DIR}"/fileservice.sh
    # retry, if network problem
    if [[ $? -eq 2 ]]; then
        log_echo "WARN" "Network problem. Retry in 60 seconds."
        sleep 60
        "${SCRIPT_DIR}"/fileservice.sh
        if [[ $? -ne 0 ]]; then
            log_echo "ERROR" "Re-occuring network problem. No further retry."
        fi
    fi

    # log space on dropbox
    "${SCRIPT_DIR}"/dropboxlog.sh
    
    # log temperature
    "${SCRIPT_DIR}"/templog.sh
    
    # sleep until next iteration
    if [[ $c -le 2 ]]; then
        SECS=$(sec_until_next_quarter)
        log_echo "INFO" "Iteration $c done. Wait $SECS for next iteration."
        sleep $SECS
    fi
done

# handle logs using logrotate
if [ -x "${SCRIPT_DIR}"/logrotate.sh ]; then 
    "${SCRIPT_DIR}"/logrotate.sh
else
    log_echo "ERROR" "Could not start script: ${SCRIPT_DIR}/logrotate.sh"
    exit 1
fi

# shutdown
if [[ ${MAINTENANCE_MODE} -eq 0 ]]; then
    log_echo "INFO" "SmartMeter camera system shuts down."
    #sudo shutdown -h now
    exit 0
fi
log_echo "INFO" "SmartMeter camera system ends in maintenance mode: ${MAINTENANCE_MODE}"
