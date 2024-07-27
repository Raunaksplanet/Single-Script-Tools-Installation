#!/bin/bash

# Check if the user provided a domain name argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <Domain Name>"
    exit 1
fi

# Run the commands concurrently
crtsh -d $1 | tee 1.txt &
assetfinder $1 | tee 2.txt &
subdom $1 | tee 3.txt &
subfinder -d $1 | tee 4.txt &
shodansubgo -d $1 -s lT9OgIZTFollTgxugbEmriGCWWCQGF5k | tee 5.txt &

# Wait for all background processes to complete
wait
