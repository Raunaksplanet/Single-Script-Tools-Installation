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
    echo "Usage: $0 <Domain Name>"
    exit 1
}

RED='\033[0;31m'
GREEN='\033[0;32m'


# Check if the user provided a filename argument
if [ $# -eq 0 ]; then
    usage
elif [ "$1" == "-h" ]; then
    usage
elif [ ! -f "$1" ]; then
    echo "File '$1' does not exist."
    exit 1
fi


file_path="$PWD/$1"

# Katana
echo -e "${RED}1. Katana${NC}";
katana -silent -ps -nc -jc -kf -fx -xhr -aff -jsl -ef woff,css,png,svg,jpg,ico,otf,ttf,woff2,jpeg,gif,svg -u "$file_path" -o ParamFuzz1.txt &

# Waybackurls
echo -e "${GREEN}2. WayBackUrls${NC}";
cat "$file_path" | waybackurls > ParamFuzz2.txt &

# Gau
echo -e "${RED}3. Gau${NC}";
cat "$file_path" | gau > ParamFuzz3.txt &

# GoSpider
echo -e "${GREEN}4. GoSpider${NC}";
gospider -a -w -q -c 20 -d 3 -S "$file_path" | ParamFuzz4.txt & 

# Gau
echo -e "${RED}5. GauPlus${NC}";
echo "$file_path" | gauplus -random-agent -subs -t 20 > ParamFuzz5.txt &


# Wait for all background processes to complete
wait
