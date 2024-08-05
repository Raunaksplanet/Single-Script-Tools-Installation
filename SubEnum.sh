#!/bin/sh
filename=$1
while read line; do
        echo "Sublist3r"
        python3 sublist3r.py -d $line -o $line.txt
        echo "Assetfinder"
        assetfinder --subs-only $line | tee -a $line.txt		
        sort -u $line.txt -o $line.txt        
        echo "Subjack"
        subjack -w $line.txt -t 1000 -o $1takeover.txt
done < $filename
#./sudomainTakeover.sh subs.txt
