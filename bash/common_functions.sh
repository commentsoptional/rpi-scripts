#!/usr/bin/env bash

### Author: A.A.
### Date: 20170101
### Description: common functions for use by all scripts
### Usage: sourced from othe scripts as . common_functions.sh

echo "[##I] `date` (common_functions.sh) -> Starting common function sourcing. "

###############
# ERROR CHECK
###############
function error_check {
rc=${1}
if [ $rc -ne 0 ]
then
    print "[##E] `date` (error_check) -> Process has ENDED NOT OK."
    print "[##E} `date` (error_check) -> return code: ${rc}"
    exit $rc;
fi
}

echo "[##I] `date` (common_functions.sh) -> Ending common function sourcing. "
