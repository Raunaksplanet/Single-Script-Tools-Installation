#!/bin/bash

# Usage function
usage() {
    echo "Usage: $0 <domain>"
    echo "Example: $0 example.com"
    exit 1
}

# Check for -h or missing arguments
if [[ $# -eq 0 || $1 == "-h" ]]; then
    usage
fi

domain=$1
output_file="wayback_files.txt"

# Fetch backup-related files
echo "=========================================="
echo " Searching for backup files on Wayback Machine"
echo " Target Domain: $domain"
echo "=========================================="

result=$(curl -s "https://web.archive.org/cdx/search/cdx?url=*.$domain/*&collapse=urlkey&output=text&fl=original" | \
grep -E '\.(zip|bak|tar|tar\.gz|tgz|7z|rar|sql|db|backup|old|gz|bz2)$')

if [[ -n "$result" ]]; then
    echo -e "\n[+] Backup files found:\n"
    echo "Backup files for $domain" > "$output_file"
    echo "==========================================" >> "$output_file"

    while IFS= read -r url; do
        archive_data=$(curl -s "https://web.archive.org/cdx/search/cdx?url=$url&output=json")
        timestamp=$(echo "$archive_data" | jq -r '.[1][1]' 2>/dev/null)
        
        if [[ "$timestamp" != "null" && -n "$timestamp" ]]; then
            snapshot_link="https://web.archive.org/web/$timestamp/$url"
            echo "[*] File: $url" | tee -a "$output_file"
            echo "    ➜ Snapshot Available: $snapshot_link" | tee -a "$output_file"
        else
            echo "[*] File: $url" | tee -a "$output_file"
            echo "    ✗ No Snapshot Available" | tee -a "$output_file"
        fi
        echo "------------------------------------------" | tee -a "$output_file"
    done <<< "$result"

    echo "[✓] Results saved to $output_file"
else
    echo "[✗] No backup files found."
fi

echo "=========================================="
echo " Done!"
echo "=========================================="
