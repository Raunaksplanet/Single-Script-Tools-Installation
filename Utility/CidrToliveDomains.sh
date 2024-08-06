#!/bin/bash

# Converting CIDR to indiviual IP's and then performing Reverse DNS to get SubDomains

# Check if prips is installed
if ! command -v prips &> /dev/null; then
  echo "prips could not be found. Please install prips to proceed."
  exit 1
fi

# Check if the input file is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <cidr_file>"
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
