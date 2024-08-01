#!/bin/bash

<<comment
"
This parameter enumeration script includes these tools
1. Katana
2. WayBackUrls
3. Gau
4. gauplus
5. GoSpider
"
comment

# Function to display usage instructions
usage() {
    echo "Usage: $0 <file containing domains>"
    exit 1
}

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Check if the user provided a filename argument
if [ $# -eq 0 ]; then
    usage
elif [ "$1" == "-h" ]; then
    usage
fi

URL="$1"

# Katana
echo -e "${RED}1. Katana${NC}"
katana -silent -ps -nc -jc -jsl -c 50 -ef woff,css,png,svg,jpg,ico,otf,ttf,woff2,jpeg,gif,svg -u "$URL" -o ParamFuzz1.txt 

# Waybackurls
echo -e "${GREEN}2. WayBackUrls${NC}"
cat "$URL" | waybackurls > ParamFuzz2.txt 

# Gau
echo -e "${RED}3. Gau${NC}"
cat "$URL" | gau > ParamFuzz3.txt 

# GoSpider
echo -e "${GREEN}4. GoSpider${NC}"
gospider -a -w -q -c 20 -d 3 -s "$URL" > ParamFuzz4.txt 

# GauPlus
echo -e "${RED}5. GauPlus${NC}"
echo "$URL" | gauplus -random-agent -subs -t 20 > ParamFuzz5.txt 

# Wait for all background processes to complete
wait $katana_pid
wait $waybackurls_pid
wait $gau_pid
wait $gospider_pid
wait $gauplus_pid

echo -e "${GREEN}All tools have finished running.${NC}"
