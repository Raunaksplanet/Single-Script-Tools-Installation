#!/bin/bash

# Check if the input file is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <input_file>"
  exit 1
fi

input_file="$1"

# Process each domain in the input file
while IFS=$'\r' read -r line;
do
echo -n "$line "
hostname=`host $line | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'| sort -u`
echo $hostname
done < $input_file


echo "IP addresses have been saved"
