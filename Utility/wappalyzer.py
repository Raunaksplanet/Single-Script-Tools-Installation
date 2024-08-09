#!/usr/bin/env python

import argparse
import requests
from Wappalyzer import Wappalyzer, WebPage
from colorama import Fore, Style
import warnings

warnings.filterwarnings("ignore")

def find_version(versions):
    return versions[0] if versions else 'nil'

def find_techs(url):
    # Ensure the URL has a proper scheme
    if not url.startswith(('http://', 'https://')):
        if '.' in url:
            url = 'http://' + url
        else:
            print("[+] Invalid URL format.")
            return

    try:
        url = requests.head(url, allow_redirects=True).url
    except requests.RequestException:
        print("[+] Error occurred while resolving the URL.")
        return

    try:
        webpage = WebPage.new_from_url(url)
        wappalyzer = Wappalyzer.latest()
        techs = wappalyzer.analyze_with_versions_and_categories(webpage)
    except Exception as e:
        print(Style.BRIGHT + Fore.RED + f"\n[!] Error occurred for {url}: {e}")
        return

    nurl = url.split("//")[1].rstrip("/")
    output = f"\n[+] TECHNOLOGIES [{nurl.upper()}]:\n"
    
    for tech, details in techs.items():
        category = details['categories'][0]
        version = find_version(details['versions'])
        output += f"{category} : {tech} [version: {version}]\n"

    print(Style.BRIGHT + Fore.BLUE + output + Style.RESET_ALL)

def main():
    parser = argparse.ArgumentParser(description='Finds Web Technologies!')
    parser.add_argument('-u', '--url', help='URL to find technologies')
    parser.add_argument('-f', '--file', help="List of URLs to find web technologies")

    args = parser.parse_args()

    # Check if no arguments are provided
    if not any(vars(args).values()):
        parser.print_help()
        return

    if args.file:
        try:
            with open(args.file, 'r') as f:
                for line in f:
                    find_techs(line.strip())
        except IOError as e:
            print(Style.BRIGHT + Fore.RED + f"[!] Error reading file {args.file}: {e}")
    elif args.url:
        find_techs(args.url)

if __name__ == '__main__':
    main()
