#!/bin/bash

# Function to display general usage instructions
usage() {
    echo "Usage: Combined All My Mini Scripts Into Single Script
    -a        Domain To IP's
    -b        CIDR To IP's
    -c        CIDR To Domain
    -d        HTTPX To Specific Status Code Text File
    -e        Download Directory Listing Enabled Website
    -f        Show all the cname from the provided file
    -g        Mass Port Scan
    -h        Alien Url's
    -i        Virus Total
    -j        AllDomz
    -k        AllUrls
    -l        Domains to status codes"
    exit 1
}

# --------------------------------------------------------------------------------

# Function to display usage instructions for -a
usage_domain_to_ips() {
    echo "Usage for -a:
    Example: $0 -a <Domain File>"
    exit 1
}

# --------------------------------------------------------------------------------

# Function to display usage instructions for -b
usage_cidr_to_ips() {
    echo "Usage for -b:
    Example: $0 -b <CIDR File>"
    exit 1
}

# --------------------------------------------------------------------------------

# Function to display usage instructions for -C
usage_cidr_to_domain() {
    echo "Usage for -c:
    Example: $0 -c <CIDR File>"
    exit 1
}

# --------------------------------------------------------------------------------

# Function to display usage instructions for -d
usage_httpx_status_code() {
    echo "Usage for -d:
    Example: $0 -d <httpx_output File>"
    exit 1
}

# --------------------------------------------------------------------------------

# Function to display usage instructions for -e
usage_directory_listing() {
    echo "Usage for -e:
    Example: $0 -e <Main URL>"
    exit 1
}

# --------------------------------------------------------------------------------

# Function to display usage instructions for -f
usage_mass_cname() {
    echo "Usage for -f:
    Example: $0 -f <File contain sub-domains>"
    exit 1
}

# --------------------------------------------------------------------------------

# Function to display usage instructions for -g
usage_mass_Port_Scan() {
    echo "Usage for -g:
    Example: $0 -g <File contain sub-domains>"
    exit 1
}

# --------------------------------------------------------------------------------

# Function to display usage instructions for -h
usage_mass_alien_url() {
    echo "Usage for -h:
    Example: $0 -h <domain> or <file>"
    exit 1
}

# --------------------------------------------------------------------------------

# Function to display usage instructions for -i
usage_virus_total() {
    echo "Usage for -i:
    Example: $0 -i <domain> or <file>"
    exit 1
}

# --------------------------------------------------------------------------------

# Function to display usage instructions for -i
usage_AllDomz() {
    echo "Usage for -j:
    Example: $0 -j <domain> or <file>"
    exit 1
}

# --------------------------------------------------------------------------------

# Function to display usage instructions for -i
usage_AllUrls() {
    echo "Usage for -k:
    Example: $0 -k <domain> or <file>"
    exit 1
}

# --------------------------------------------------------------------------------

# Function to display usage instructions for -i
usage_cleanUrls() {
    echo "Usage for -l:
    Example: $0 -l <domain> or <file>"
    exit 1
}

# --------------------------------------------------------------------------------

# Function for Domain To IP's
domain_to_ips() {
    if [ "$1" == "-h" ]; then
        usage_domain_to_ips
        return
    elif [ -z "$1" ]; then
        usage_domain_to_ips
        return
    fi
    
    input_file="$1"
    output_file="DomToIP.txt"

    # Empty the output file if it already exists
    > "$output_file"

    # Process each domain in the input file
    while IFS=$'\r' read -r line; do
        # Print the domain name to both the terminal and the output file
        echo "$line" | tee -a "$output_file"
        
        # Get the IP addresses for the current domain
        ip_addresses=$(host "$line" | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sort -u)
        
        # Print each IP address on a new line to both the terminal and the output file
        while IFS= read -r ip; do
            echo "$ip" | tee -a "$output_file"
        done <<< "$ip_addresses"
    
        # Print a blank line after each domain's IP addresses to both the terminal and the output file
        echo | tee -a "$output_file"
    done < "$input_file"

    echo "IP addresses have been saved to $output_file"
}

# --------------------------------------------------------------------------------

# Function for CIDR To IP's
cidr_to_ips() {
    if [ "$1" == "-h" ]; then
        usage_cidr_to_ips
    elif [ -z "$1" ]; then
        usage_cidr_to_ips
    fi
    
    if ! command -v prips &> /dev/null; then
        echo "prips could not be found. Please install prips to proceed."
        exit 1
    fi

    # Input file containing CIDR ranges
    CIDR_FILE=$1

    # Check if the input file exists
    if [ ! -f "$CIDR_FILE" ]; then
        echo "File not found: $CIDR_FILE"
        exit 1
    fi

    # Read the CIDR file line by line
    while IFS= read -r cidr; do
        # Skip empty lines and comments
        if [[ -z "$cidr" || "$cidr" =~ ^# ]]; then
            continue
        fi

    # Perform reverse DNS lookup using prips and hakrevdns
    prips "$cidr" | tee -a AllIPs.txt
    done < "$CIDR_FILE"
}

# --------------------------------------------------------------------------------

# Function for CIDR To Domain
cidr_to_domain() {
    if [ "$1" == "-h" ]; then
        usage_cidr_to_domain
    elif [ -z "$1" ]; then
        usage_cidr_to_domain
    fi
    
    if ! command -v prips &> /dev/null; then
        echo "prips could not be found. Please install prips to proceed."
        exit 1
    fi

    if ! command -v hakrevdns &> /dev/null; then
        echo "hakrevdns could not be found. Please install hakrevdns to proceed."
        exit 1
    fi

    # Input file containing CIDR ranges
    CIDR_FILE=$1

    # Check if the input file exists
    if [ ! -f "$CIDR_FILE" ]; then
        echo "File not found: $CIDR_FILE"
        exit 1
    fi

    # Read the CIDR file line by line
    while IFS= read -r cidr; do
        # Skip empty lines and comments
        if [[ -z "$cidr" || "$cidr" =~ ^# ]]; then
            continue
        fi

    # Perform reverse DNS lookup using prips and hakrevdns
    prips "$cidr" | hakrevdns -d -t 500 -U | anew Reversed-DNS-Subdomains.txt
    done < "$CIDR_FILE"
}

# --------------------------------------------------------------------------------

# Function for HTTPX To Specific Status Code Text File
httpx_status_code() {
    if [ "$1" == "-h" ]; then
        usage_httpx_status_code
    elif [ -z "$1" ]; then
        usage_httpx_status_code
    fi
    
    input_file="$1"

    # Extract unique status codes from the file using regex and store them in the status_codes array
    status_codes=($(grep -oP '\[\d{3}\]' "$input_file" | sort -u | tr -d '[]'))

    # Loop through each status code and grep results to separate files
    for code in "${status_codes[@]}"; do
        grep "$code" "$input_file" > "${code}.txt"
    done

    echo "Extraction completed."
}

# --------------------------------------------------------------------------------

# Function for Downloading  Directory Listing Enabled website Content
directory_listing() {
    if [ "$1" == "-h" ]; then
        usage_directory_listing
    elif [ -z "$1" ]; then
        usage_directory_listing
    fi
    
    # URL of the directory listing
    URL="$1"

    # Create an output directory
    OUTPUT_DIR="downloaded_files"
    mkdir -p "$OUTPUT_DIR"

    # Use wget to download all files recursively from the directory listing
    wget -r -np -nH --cut-dirs=1 -P "$OUTPUT_DIR" "$URL"

    echo "Files downloaded to $OUTPUT_DIR"
}

# --------------------------------------------------------------------------------

# Function for Displaying mass CNAME/A
massCNAME() {
    if [ "$1" == "-h" ]; then
        usage_mass_cname
    elif [ -z "$1" ]; then
        usage_mass_cname
    fi
    
   # Assign the first argument to the filename variable
    filename=$1

    # Temporary file to store results
    temp_file=$(mktemp)

    # Read each line from the file and perform a DNS lookup
    while read -r sub; do
        # Use dig to perform a DNS query and filter for CNAME and A records
        dig "$sub" +noquestion +noauthority +noadditional +nostats | \
        awk '/IN[[:space:]]+(CNAME)/ {printf "%-50s %-6s %s\n", $1, $4, $5}' >> "$temp_file"
    done < "$filename"

    # Sort the results
    sort -k2,2 -k1,1 "$temp_file"

    # Clean up the temporary file
    rm "$temp_file"
}

# --------------------------------------------------------------------------------

# Function for Displaying mass CNAME/A
massPortScan() {
    if [ "$1" == "-h" ]; then
        usage_mass_Port_Scan
    elif [ -z "$1" ]; then
        usage_mass_Port_Scan
    fi
    
   # Assign the first argument to the filename variable
    filename=$1

    naabu -silent -nc -l $filename -tp 1000 -ep 21,22,80,443,554,1723
}

# --------------------------------------------------------------------------------

# Function for Alien URL
AlienUrl() {
    if [ "$1" == "-h" ]; then
        usage_mass_alien_url
    elif [ -z "$1" ]; then
        usage_mass_alien_url
    fi
    
    process_domain() {
        local domain=$1
        local output_file="AlienResult.txt"
        local base_url="https://otx.alienvault.com/api/v1/indicators/domain/$domain/url_list?limit=500&page="
        local page=1

        echo "[INFO] Scraping URLs for domain: $domain"

        while true; do
            response=$(curl -s "$base_url$page")
            urls=$(echo "$response" | jq -r '.url_list[].url' 2>/dev/null)

            if [ -z "$urls" ]; then
                echo "[INFO] No more URLs for $domain."
                break
            fi

            echo "$urls" >>"$output_file"
            page=$((page + 1))
        done

        if [ -s "$output_file" ]; then
            echo "[INFO] URLs saved to $output_file"
        else
            echo "[INFO] No URLs found for domain: $domain."
        fi
    }

    # Check if input is a file or domain
    if [ -f "$1" ]; then
        echo "[INFO] Input is a file. Processing domains from file: $1"
        while IFS= read -r domain; do
            if [ -n "$domain" ]; then
                process_domain "$domain"
            fi
        done <"$1"
    else
        echo "[INFO] Input is a domain. Processing domain: $1"
        process_domain "$1"
    fi
    
}

# --------------------------------------------------------------------------------

# Function for Displaying VirusTotal
VirusTotal() {
    if [ "$1" == "-h" ]; then
        usage_virus_total
    elif [ -z "$1" ]; then
        usage_virus_total
    fi
    
       # Function to fetch and display undetected URLs for a domain
    fetch_undetected_urls() {
        local domain=$1
        local api_key_index=$2
        local api_key

        # Rotate between three API keys
        if [ $api_key_index -eq 1 ]; then
            api_key="2d1ed4d97f91c3c18877c02c5d14225e95c2b5dab7c16a524efa0b94cfd1c0a9"
        elif [ $api_key_index -eq 2 ]; then
            api_key="2fb731a6845f9d09e17e5334f6a1e2cf29e0131f925c9c43ac7fcf08fe4704ad"
        else
            api_key="2fb731a6845f9d09e17e5334f6a1e2cf29e0131f925c9c43ac7fcf08fe4704ad"
        fi

        local URL="https://www.virustotal.com/vtapi/v2/domain/report?apikey=$api_key&domain=$domain"

        echo -e "\nFetching data for domain: \033[1;34m$domain\033[0m (using API key $api_key_index)"
        response=$(curl -s "$URL")
        if [[ $? -ne 0 ]]; then
            echo -e "\033[1;31mError fetching data for domain: $domain\033[0m"
            return
        fi

        undetected_urls=$(echo "$response" | jq -r '.undetected_urls[][0]')
        if [[ -z "$undetected_urls" ]]; then
            echo -e "\033[1;33mNo undetected URLs found for domain: $domain\033[0m"
        else
            echo -e "\033[1;32mUndetected URLs for domain: $domain\033[0m"
            echo "$undetected_urls"
        fi
    }

    # Function to display a countdown
    countdown() {
        local seconds=$1
        while [ $seconds -gt 0 ]; do
            echo -ne "\033[1;36mWaiting for $seconds seconds...\033[0m\r"
            sleep 1
            : $((seconds--))
        done
        echo -ne "\033[0K"  # Clear the countdown line
    }

    # Initialize variables for API key rotation
    local api_key_index=1
    local request_count=0

    # Process input as file or domain
    if [ -f "$1" ]; then
        echo "[INFO] Input is a file. Processing domains from file: $1"
        while IFS= read -r domain; do
            # Remove the scheme (http:// or https://) if present
            domain=$(echo "$domain" | sed 's|https\?://||')
            fetch_undetected_urls "$domain" $api_key_index
            countdown 20

            # Increment request count and rotate API key if needed
            request_count=$((request_count + 1))
            if [ $request_count -ge 5 ]; then
                request_count=0
                if [ $api_key_index -eq 1 ]; then
                    api_key_index=2
                elif [ $api_key_index -eq 2 ]; then
                    api_key_index=3
                else
                    api_key_index=1
                fi
            fi
        done <"$1"
    else
        echo "[INFO] Input is a domain. Processing domain: $1"
        # Remove the scheme (http:// or https://) if present
        local domain=$(echo "$1" | sed 's|https\?://||')
        fetch_undetected_urls "$domain" $api_key_index
    fi

    echo -e "\033[1;32mAll done!\033[0m"

}
# --------------------------------------------------------------------------------

# Function for Displaying All Domains
AllDomz() {
    if [ "$1" == "-h" ]; then
        usage_mass_Port_Scan
    elif [ -z "$1" ]; then
        usage_mass_Port_Scan
    fi
    
   # Assign the first argument to the filename variable
    crtsh -d $1 | anew SubList1.txt; subdom $1 | anew SubList2.txt; shodanx subdomain -d $1 -o SubList3.txt; subfinder -all -recursive -silent -nc -d $1 | anew SubList4.txt; assetfinder -subs-only $1 | anew SubList5.txt; subdominator -nc -d $1 | anew SubList6.txt
}

# --------------------------------------------------------------------------------

# Function for Displaying All urls
AllUrls() {
    if [ "$1" == "-h" ]; then
        usage_mass_Port_Scan
    elif [ -z "$1" ]; then
        usage_mass_Port_Scan
    fi
    

    echo $1 | gau --mc 200 --blacklist woff,css,png,svg,jpg,ico,otf,ttf,woff2,jpeg,gif,svg | anew ParamFuzz1.txt; echo $1 | waybackurls | anew ParamFuzz2.txt; echo $1 | hakrawler -subs | anew ParamFuzz3.txt; gospider -a -w -c 50 -m 3 -s $1 | anew ParamFuzz4.txt; katana -silent -nc -jc -c 100 -ef woff,css,png,svg,jpg,ico,otf,ttf,woff2,jpeg,gif,svg -u $1 | anew ParamFuzz5.txt
}

# --------------------------------------------------------------------------------

# Function for clearn all domains
CleanDomains() {
    if [ "$1" == "-h" ]; then
        usage_mass_Port_Scan
    elif [ -z "$1" ]; then
        usage_mass_Port_Scan
    fi
    
   cat $1 | httpx-toolkit -sc -nc -t 500 -silent -title | tee >(grep "\[3[0-9][0-9]\]" | anew 300s.txt) >(grep "\[4[0-9][0-9]\]" | anew 400s.txt) >(grep "\[5[0-9][0-9]\]" | anew 500s.txt) | grep "\[2[0-9][0-9]\]" | anew 200s.txt
}
# --------------------------------------------------------------------------------

# Parse options and call appropriate functions
while getopts ":a:A:b:B:c:C:d:D:e:E:f:F:g:G:h:H:i:I:j:J:k:K:l:L" opt; do
    case $opt in
        a)
            domain_to_ips "$OPTARG"
            ;;
        b)
            cidr_to_ips "$OPTARG"
            ;;
        c)
            cidr_to_domain "$OPTARG"
            ;;
        d)
            httpx_status_code "$OPTARG"
            ;;
        e)
            directory_listing "$OPTARG"
            ;;
        f)
            massCNAME "$OPTARG"
            ;;
        g)
            massPortScan "$OPTARG"
            ;;
        h)
            AlienUrl "$OPTARG"
            ;;
        i)
            VirusTotal "$OPTARG"
            ;;
        j)
            AllDomz "$OPTARG"
            ;;
        k)
            AllUrls "$OPTARG"
            ;;
        l)
            CleanDomains "$OPTARG"
            ;;
        *)
            usage
            ;;
    esac
done

if [ $OPTIND -eq 1 ]; then usage; fi
