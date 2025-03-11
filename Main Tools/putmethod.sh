#!/bin/bash

function check_put() {
    url=$1
    response=$(curl -X OPTIONS -s -I "$url" | grep -i "Allow:")
    
    if echo "$response" | grep -q "PUT"; then
        echo "[+] PUT method is enabled on $url"
        test_upload "$url"
    else
        echo "[-] PUT method is not enabled on $url"
    fi
}

function test_upload() {
    url=$1
    test_file="codeslayer137.txt"
    content="Testing CodeSlayer137"
    
    upload_response=$(curl -X PUT --data "$content" -s -o /dev/null -w "%{http_code}" "$url/$test_file")
    
    if [ "$upload_response" == "200" ] || [ "$upload_response" == "201" ]; then
        echo "[!] Successfully uploaded test file on $url/$test_file"
    else
        echo "[-] Failed to upload test file on $url"
    fi
}

function show_help() {
    echo "Usage: $0 [-u <URL>] | [-l <list_of_urls.txt>]"
    echo "  -u <URL>           Check a single URL for PUT method vulnerability"
    echo "  -l <list.txt>      Check multiple URLs from a file"
    echo "  -h                 Show this help message"
    exit 0
}

while getopts "u:l:h" opt; do
    case ${opt} in
        u )
            check_put "$OPTARG"
            ;;
        l )
            while IFS= read -r line; do
                check_put "$line"
            done < "$OPTARG"
            ;;
        h )
            show_help
            ;;
        * )
            show_help
            ;;
    esac
done
