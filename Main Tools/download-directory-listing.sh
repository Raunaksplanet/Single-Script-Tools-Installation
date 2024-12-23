#!/bin/bash

# Check if the URL is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <url>"
  exit 1
fi

# URL of the directory listing
URL="$1"

# Create an output directory
OUTPUT_DIR="downloaded_files"
mkdir -p "$OUTPUT_DIR"

# Use wget to download all files recursively from the directory listing
wget -r -np -nH --cut-dirs=1 -P "$OUTPUT_DIR" "$URL"

echo "Files downloaded to $OUTPUT_DIR"
