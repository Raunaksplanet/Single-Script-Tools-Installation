#!/bin/bash

# Usage: ./email_case_generator.sh example@example.com

email="$1"
output="email_payloads.txt"
username="${email%@*}"
domain="${email#*@}"

> "$output"
declare -A seen

generate_domain_permutations() {
    local input="$1"
    local max_upper=3
    local len=${#input}
    local total=$((1 << len))
    local variants=()

    for ((i = 0; i < total; i++)); do
        local upper_count=0
        local modified=""

        for ((j = 0; j < len; j++)); do
            char="${input:j:1}"
            if [[ "$char" =~ [a-zA-Z] ]]; then
                if (( (i >> j) & 1 )); then
                    char="${char^^}"
                    ((upper_count++))
                else
                    char="${char,,}"
                fi
            fi
            modified+="$char"
        done

        if (( upper_count > 0 && upper_count <= max_upper )); then
            variants+=("$modified")
        fi
    done

    echo "${variants[@]}"
}

generate_email_permutations() {
    local user="$1"
    local domains=("$@")
    local len=${#user}
    local total=$((1 << len))
    local max_upper=3

    for ((i = 0; i < total; i++)); do
        local upper_count=0
        local uname=""

        for ((j = 0; j < len; j++)); do
            char="${user:j:1}"
            if [[ "$char" =~ [a-zA-Z] ]]; then
                if (( (i >> j) & 1 )); then
                    char="${char^^}"
                    ((upper_count++))
                else
                    char="${char,,}"
                fi
            fi
            uname+="$char"
        done

        if (( upper_count > 0 && upper_count <= max_upper )); then
            for d in "${domains[@]:1}"; do
                result="$uname@$d"
                if [[ -z "${seen[$result]}" ]]; then
                    echo "$result" >> "$output"
                    seen[$result]=1
                fi
            done
        fi
    done
}

domain_variants=($(generate_domain_permutations "$domain"))
generate_email_permutations "$username" "${domain_variants[@]}"

echo "Saved to $output"
