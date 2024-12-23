#!/bin/bash

# crtsh -d <domain> | anew SubList1.txt; subdom <domain> | anew SubList2.txt; shodanx subdomain -d <domain> -o SubList3.txt; subfinder -silent -nc -d <domain> | anew SubList4.txt; assetfinder -subs-only <domain> | anew SubList5.txt; subdominator -nc -d <domain> | anew SubList6.txt 
# Function to display usage instructions
usage() {
    echo "Usage: $0 <Domain Name>"
    exit 1
}

# Check for -h option
if [ "$1" == "-h" ]; then
    usage
elif [ $# -eq 0 ]; then
    usage
fi

# Run the commands concurrently
crtsh -d "$domain" | anew SubList1.txt &
subdom "$domain" | anew SubList2.txt &
shodanx subdomain -d "$domain" -o SubList3.txt &
subfinder -silent -nc -d "$domain" | anew SubList4.txt &
assetfinder -subs-only "$domain" | anew SubList5.txt &
subdominator -nc -d "$domain" | anew SubList6.txt &

# Wait for all background processes to complete
wait
