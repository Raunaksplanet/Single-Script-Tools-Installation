#!/bin/bash

# Function to display usage instructions
usage() {
    echo "Usage: $0 <Domain Name>"
    exit 1
}

# Check if the user provided a filename argument
if [ $# -eq 0 ]; then
    usage
elif [ "$1" == "-h" ]; then
    usage
elif [ ! -f "$1" ]; then
    echo "File '$1' does not exist."
    exit 1
fi

# Input file from argument
input_file="$1"


#  cat httpx-result.txt | grep -oP '\[\d{3}\]' | sort -u
# Array of status codes to search for
status_codes=("200" "204" "301" "302" "303" "400" "401" "403" "404" "500" "502" "503")

# Loop through each status code and grep results to separate files
for code in "${status_codes[@]}"; do
    cat "$1" | grep "$code" > "$code.txt"
done

echo "Extraction completed."
