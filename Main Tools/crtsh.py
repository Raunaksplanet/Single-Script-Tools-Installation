#!/usr/bin/env python3
import sys
import subprocess
import importlib
import argparse
import json
import warnings
from concurrent.futures import ThreadPoolExecutor, as_completed

try:
    import requests
    from urllib3.exceptions import NotOpenSSLWarning
    warnings.filterwarnings("ignore", category=NotOpenSSLWarning)
except ImportError:
    print("[*] 'requests' not found; installing...")
    subprocess.check_call([sys.executable, "-m", "pip", "install", "requests"])
    importlib.invalidate_caches()
    import requests


HEADERS = {
    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36",
    "Accept": "application/json, text/plain, */*",
    "Accept-Language": "en-US,en;q=0.9",
    "Accept-Encoding": "gzip, deflate, br",
    "Referer": "https://crt.sh/",
    "Connection": "keep-alive",
}


def clean_subs(names):
    subs = set()
    for name in names:
        for line in name.splitlines():
            line = line.strip().lstrip('*.')
            if line:
                subs.add(line)
    return subs


def fetch_crtsh_requests(domain, retries=3, timeout=60):
    session = requests.Session()
    session.headers.update(HEADERS)
    for attempt in range(retries):
        try:
            resp = session.get(f"https://crt.sh/?q={domain}&output=json", timeout=timeout)
            resp.raise_for_status()
            data = resp.text.strip()
            if not data:
                return set()
            return clean_subs(entry.get('name_value', '') for entry in json.loads(data))
        except requests.exceptions.Timeout:
            print(f"[!] crt.sh timeout (attempt {attempt+1}/{retries})", file=sys.stderr)
        except Exception as e:
            print(f"[!] crt.sh requests error: {e}", file=sys.stderr)
            break
    return set()


def fetch_crtsh_curl(domain, timeout=60):
    try:
        result = subprocess.run([
            "curl", "-s", "--compressed",
            "-A", HEADERS["User-Agent"],
            "-H", f"Accept: {HEADERS['Accept']}",
            "-H", f"Referer: {HEADERS['Referer']}",
            f"https://crt.sh/?q={domain}&output=json"
        ], capture_output=True, text=True, timeout=timeout)
        data = result.stdout.strip()
        if not data:
            return set()
        return clean_subs(entry.get('name_value', '') for entry in json.loads(data))
    except Exception as e:
        print(f"[!] crt.sh curl error: {e}", file=sys.stderr)
        return set()


def fetch_certspotter(domain, timeout=60):
    subs = set()
    after = None
    while True:
        try:
            url = f"https://api.certspotter.com/v1/issuances?domain={domain}&include_subdomains=true&expand=dns_names"
            if after:
                url += f"&after={after}"
            resp = requests.get(url, timeout=timeout, headers=HEADERS)
            resp.raise_for_status()
            data = resp.json()
            if not data:
                break
            subs.update(clean_subs(
                name
                for entry in data
                for name in entry.get('dns_names', [])
            ))
            after = data[-1]['id']
        except Exception as e:
            print(f"[!] certspotter error: {e}", file=sys.stderr)
            break
    return subs


def fetch_subdomains(domain):
    subs = set()

    result = fetch_crtsh_requests(domain)
    if result:
        subs.update(result)
    else:
        result = fetch_crtsh_curl(domain)
        subs.update(result)

    subs.update(fetch_certspotter(domain))
    return subs


def parse_args():
    parser = argparse.ArgumentParser(description='Fetch subdomains from crt.sh + certspotter')
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('-d', '--domain', help='Target domain (single)')
    group.add_argument('-f', '--file', help='File with domains, one per line')
    parser.add_argument('-o', '--output', help='Output file (default: stdout)')
    return parser.parse_args()


def main():
    args = parse_args()

    if args.file:
        try:
            with open(args.file, 'r') as fh:
                domains = [line.strip() for line in fh if line.strip()]
        except Exception as e:
            print(f"Failed to read file: {e}", file=sys.stderr)
            sys.exit(1)
    else:
        domains = [args.domain]

    subdomains = set()
    with ThreadPoolExecutor(max_workers=10) as executor:
        futures = {executor.submit(fetch_subdomains, d): d for d in domains}
        for fut in as_completed(futures):
            subdomains.update(fut.result())

    output = sorted(subdomains)

    if args.output:
        try:
            with open(args.output, 'w') as fh:
                fh.write('\n'.join(output) + '\n')
        except Exception as e:
            print(f"Failed to write output: {e}", file=sys.stderr)
            sys.exit(1)
    else:
        for s in output:
            print(s)


if __name__ == "__main__":
    main()
