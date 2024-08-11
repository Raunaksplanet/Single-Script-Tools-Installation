#!/bin/bash

# Function to display usage instructions
usage() {
    echo "Usage: $0 <file containing domains>"
    exit 1
}

# Check if the user provided a filename argument
if [ $# -eq 0 ]; then
    usage
elif [ "$1" == "-h" ]; then
    usage
fi

URL="$1"

katana -silent -ps -nc -jc -jsl -c 50 -ef woff,css,png,svg,jpg,ico,otf,ttf,woff2,jpeg,gif,svg -u "$URL" | anew ParamFuzz1.txt &
sleep 3

while IFS= read -r url; do
  echo "$url" | waybackurls | anew ParamFuzz2.txt 
done < "$URL_FILE"
sleep 3

echo "$URL" | gau | anew ParamFuzz3.txt &
sleep 3

gospider -a -w -q -c 50 -s "$URL" | anew ParamFuzz4.txt &

# Wait for all background processes to complete
wait
