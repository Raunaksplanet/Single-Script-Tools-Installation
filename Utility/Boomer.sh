#!/bin/bash

# Function to display general usage instructions
usage() {
    echo "Usage: Combined All My Mini Scripts Into Single Script
    -a        Domain To IP's
    -b        CIDR To IP's
    -c        CIDR To Domain
    -d        HTTPX To Specific Status Code Text File
    -e        Download Directory Listing Enabled Website
    -f        Show all the cname from the provided file"
    exit 1
}

# --------------------------------------------------------------------------------

# Function to display usage instructions for -D
usage_domain_to_ips() {
    echo "Usage for -a:
    Example: $0 -a <Domain File>"
    exit 1
}

# --------------------------------------------------------------------------------

# Function to display usage instructions for -c
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

# Function to display usage instructions for -H
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

# Function to display usage instructions for -e
usage_mass_cname() {
    echo "Usage for -e:
    Example: $0 -f <File contain sub-domains>"
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
    prips "$cidr" | tee -a Finalip.txt
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
    prips "$cidr" | hakrevdns -d -t 1000 -r 1.1.1.1 | anew Reversed-DNS-Subdomains.txt
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
        awk '/IN[[:space:]]+(A|CNAME)/ {printf "%-50s %-6s %s\n", $1, $4, $5}' >> "$temp_file"
    done < "$filename"

    # Sort the results
    sort -k2,2 -k1,1 "$temp_file"

    # Clean up the temporary file
    rm "$temp_file"
}

# --------------------------------------------------------------------------------

# Parse options and call appropriate functions
while getopts ":a:A:b:B:c:C:d:D:e:E:f:F" opt; do
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
        *)
            usage
            ;;
    esac
done

if [ $OPTIND -eq 1 ]; then usage; fi
