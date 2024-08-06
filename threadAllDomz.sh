#!/bin/bash

# Function to display usage instructions
usage() {
    echo "Usage: $0 <Domain Name or File with Domains>"
    exit 1
}

# Function to limit the number of concurrent jobs
limit_jobs() {
    local max_jobs=5  # Set the maximum number of concurrent jobs
    while [ "$(jobs -r | wc -l)" -ge "$max_jobs" ]; do
        sleep 1
    done
}

# Function to process a single domain
process_domain() {
    local domain=$1
    echo "Processing domain: $domain"

    crtsh -d "$domain" | anew SubList1.txt &
    assetfinder "$domain" | anew SubList2.txt &
    subdom "$domain" | anew SubList3.txt &
    subfinder -silent -nc -d "$domain" | anew SubList4.txt &
    shodansubgo -d "$domain" -s lT9OgIZTFollTgxugbEmriGCWWCQGF5k | anew SubList5.txt &        
    shodanx subdomain -d "$domain" -o SubList6.txt &
    
    # Wait for the jobs to finish
    wait
}

# Check for -h option
if [ "$1" == "-h" ]; then
    usage
elif [ $# -eq 0 ]; then
    usage
fi

# Check if input is a file
if [ -f "$1" ]; then
    while IFS= read -r domain; do
        limit_jobs  # Ensure job limit is respected
        process_domain "$domain" &
    done < "$1"
    wait # Wait for all background processes to complete
else
    # If input is a single domain
    process_domain "$1"
fi
