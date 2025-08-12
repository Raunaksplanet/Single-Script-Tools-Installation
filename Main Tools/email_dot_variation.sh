#!/bin/bash

# Email Dot Variation Generator (Lowercase only)
# Usage: ./email_dot_generator.sh example@example.com
# Options:
#   -h  Show help

show_help() {
    echo "Usage: $0 [email]"
    echo
    echo "Generates dot variations of the given email's username part (lowercase only)."
    echo "Useful for testing email normalization and rate limit bypass scenarios."
    echo
    echo "Example:"
    echo "  $0 example@example.com"
    echo
    echo "Output is saved to 'email_dot_variations.txt'."
    exit 0
}

# If -h flag is provided
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
fi

# Require email input
if [[ -z "$1" ]]; then
    echo "Error: No email provided."
    echo "Use -h for help."
    exit 1
fi

email="$1"
output="email_dot_variations.txt"
username="${email%@*}"
domain="${email#*@}"

> "$output"
declare -A seen

# Function to insert dots in all possible positions
generate_dot_variations() {
    local user="$1"
    local len=${#user}
    local variations=()

    # Total combinations = 2^(len-1) for inserting dots
    local total=$((1 << (len - 1)))

    for ((mask = 0; mask < total; mask++)); do
        local new_user=""
        for ((i = 0; i < len; i++)); do
            new_user+="${user:i:1}"
            if (( (mask >> i) & 1 )) && (( i < len - 1 )); then
                new_user+="."
            fi
        done
        variations+=("$new_user")
    done

    echo "${variations[@]}"
}

# Lowercase username
username="${username,,}"

# Generate dot variations
dot_variants=($(generate_dot_variations "$username"))

# Output variations
for var in "${dot_variants[@]}"; do
    email_var="$var@$domain"
    if [[ -z "${seen[$email_var]}" ]]; then
        echo "$email_var" >> "$output"
        seen[$email_var]=1
    fi
done

echo "Saved to $output"
