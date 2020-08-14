#!/bin/bash

#
# Creates reports for all pipelines
#
# Author: cdeck3r
#

# this directory is the script directory
SCRIPT_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd $SCRIPT_DIR
SCRIPT_NAME=$0


for f in $(ls *.snakefile)
do
    PIPELINE_NAME="${f%.*}"
    PIPELINE_REPORT=${f}.html
    PIPELINE_GRAPH=${f}.png
    # create the report 
    snakemake ${PIPELINE_NAME} --report ${PIPELINE_REPORT}
    snakemake ${PIPELINE_NAME} --rulegraph | dot -Tpng > ${PIPELINE_GRAPH}
    
done