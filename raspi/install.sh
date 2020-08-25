#!/bin/bash

#
# Script for installing SmartMeter Camera Software
#
# Author: cdeck3r
#

# variables
REPO_ZIP=https://github.com/cdeck3r/SmartMeter/archive/master.zip
INSTALL_DIR=${HOME}/smartmeter

# check for installed program
# Source: https://stackoverflow.com/a/677212
command -v "curl" >/dev/null 2>&1 || { echo >&2 "I require curl but it's not installed.  Abort."; exit 1; }

# create install dir
mkdir -p "${INSTALL_DIR}"

# Download repo and extract raspi directory into install directory
curl -L "${REPO_ZIP}" --output /tmp/smartmeter.zip
unzip /tmp/smartmeter.zip 'SmartMeter-master/raspi/*' -d /tmp
mv /tmp/SmartMeter-master/raspi/* "${INSTALL_DIR}"

# adapt the executable flags
chmod u+x "${INSTALL_DIR}"/*.sh

# cleanup
rm -rf /tmp/smartmeter.zip
rm -rf /tmp/SmartMeter-master
