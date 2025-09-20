#!/bin/bash

# Usage: ./case_generator.sh "example123"
# Generates all possible case variations of the string

input="$1"
output="string_payloads.txt"
> "$output"

len=${#input}
total=$((1 << len))

for ((i = 0; i < total; i++)); do
    variant=""
    for ((j = 0; j < len; j++)); do
        char="${input:j:1}"
        if [[ "$char" =~ [a-zA-Z] ]]; then
            if (( (i >> j) & 1 )); then
                variant+="${char^^}"
            else
                variant+="${char,,}"
            fi
        else
            variant+="$char"
        fi
    done
    echo "$variant" >> "$output"
done

echo "All variations saved to $output"
