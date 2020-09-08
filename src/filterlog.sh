#!/bin/bash

#
# Removes noise from raspi logfile and keeps log lines only
# 
# Author: cdeck3r
#

# Params: none

# Exit codes
# none

# this directory is the script directory
SCRIPT_DIR="$(
    cd "$(dirname "$0")" || exit
    pwd -P
)"
cd "$SCRIPT_DIR" || exit
# shellcheck disable=SC2034
SCRIPT_NAME=$0

# variables
LOG_DIR="${SCRIPT_DIR}"
LOG_FILES="smartmeter.log-*.bz2"


#####################################################
# Include Helper functions
#####################################################

# ...

#####################################################
# Main program
#####################################################

for logfile in $(find "${LOG_DIR}" -type f -name "${LOG_FILES}")
do
    # filter log
    # 1. replace repeated blanks by single blanks
    # 2. replace ; by .
    # 3. cut only interesting fields separated by blanks
    # 4. filter only lines starting with date format
    # 5. replace the first 4 occurances of blanks by ; as new field separator 
    bzcat "${logfile}" | tr -s '[:blank:]' | tr ';' '.' | cut -d' ' -f1,2,4,6,8- | grep -P '^\d{4}-\d{2}-\d{2}' | sed 's/\s/;/' | sed 's/\s/;/' | sed 's/\s/;/' | sed 's/\s/;/'
done


