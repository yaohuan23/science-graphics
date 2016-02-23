#!/bin/bash
if [ $1 ]; then
    echo "Converting data/${1}.tsv from TSV to CSV"
    sed 's/\t/\,/g' ../data/${1}.tsv > ../data/${1}.csv
    echo "Result saved to data/${1}.csv"
    
else
    echo ERROR: Need to provide project name
fi
