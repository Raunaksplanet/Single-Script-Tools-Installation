#!/bin/bash

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
crtsh -d $1 | anew SubList1.txt
assetfinder $1 | anew SubList2.txt &
subdom $1 | anew SubList3.txt &
subfinder -silent -nc -d $1 | anew SubList4.txt &
shodansubgo -d $1 -s lT9OgIZTFollTgxugbEmriGCWWCQGF5k | anew SubList5.txt &        
shodanx subdomain -d $1 -o SubList6.txt &

# Wait for all background processes to complete
wait
