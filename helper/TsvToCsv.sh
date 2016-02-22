#!/bin/bash
if [ $1 ]; then
    echo "Converting data/${1}.tsv from TSV to CSV\n"
    sed 's/\t/\,/g' ../data/${1}.tsv > ../data/${1}.csv
    echo "Result saved to data/${1}.csv\n"
    
else
    echo ERROR: Need to provide project name
fi
