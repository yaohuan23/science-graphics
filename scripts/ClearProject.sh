#!/bin/bash
if [ $1 ]; then
    echo Clearing project ${1}
    rm ../figures/${1}*.pdf
    rm ../results/${1}*.csv
else
    echo ERROR: Need to provide project name
fi
