#
# Some common functions
#
# Author: cdecke3r
#

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

# no args
assert_on_raspi () {
    # check we are on Raspi
    MACHINE=$(uname -m)
    if [[ "$MACHINE" != arm* ]]; then
        log_echo "ERROR" "We are not on an arm plattform: ${MACHINE}"
        exit 1
    fi 
}

#
# Sleep routines
# 

# Computes the now epoch timestamp mod a given number of seconds
# Ex. given 3600 as parameter, it computes the now timestamp modulo 3600
# and yields the number of seconds within the current hour.
#
# Param #1: seconds
now_sec_modulo () {
    local SECS=$1
    echo $(( $(date +%s) % $SECS ))
}

sec_in_current_quarter () {
    echo $(now_sec_modulo 900)
}

sec_until_next_quarter () {
    echo $(( 900 - $(sec_in_current_quarter) ))
}
