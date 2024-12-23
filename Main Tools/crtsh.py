#!/usr/bin/env python3

import sys, argparse, requests, json
from concurrent.futures import ThreadPoolExecutor

def fetch_subdomains(domain):
    try:
        response = requests.get(f"https://crt.sh/?q={domain}&output=json", timeout=25)
        if response.ok:
            return {entry['name_value'] for entry in json.loads(response.text)}
    except Exception as e:
        print(f"Error fetching data for {domain}: {e}")
    return set()

def parse_args():
    parser = argparse.ArgumentParser(description='Fetch subdomains from crt.sh', epilog='Example: python3 script.py -d example.com')
    parser.add_argument('-d', '--domain', help='Target Domain to get subdomains from crt.sh')      
    parser.add_argument('-f', '--file', help='File containing list of domains')
    return parser.parse_args()

def main():
    args = parse_args()
    domains = []

    if args.file:
        with open(args.file) as f:
            domains.extend(f.read().splitlines())
    elif args.domain:
        domains.append(args.domain)
    else:
        print("Usage: python3 " + sys.argv[0] + " -d <domain> or -f <file>")
        sys.exit()

    # Use ThreadPoolExecutor to fetch subdomains concurrently
    with ThreadPoolExecutor(max_workers=10) as executor:
        future_to_domain = {executor.submit(fetch_subdomains, domain): domain for domain in domains}
        subdomains = set()
        for future in future_to_domain:
            subdomains.update(future.result())

    print("\n".join(subdomains))

if __name__ == "__main__":
    main()
