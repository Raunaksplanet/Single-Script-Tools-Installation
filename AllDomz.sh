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
crtsh -d $1 | tee 1.txt
assetfinder $1 | tee 2.txt &
subdom $1 | tee 3.txt &
subfinder -d $1 | tee 4.txt &
shodansubgo -d $1 -s lT9OgIZTFollTgxugbEmriGCWWCQGF5k | tee 5.txt &        
shodanx subdomain -d $1 -o 6.txt &

# Wait for all background processes to complete
wait
