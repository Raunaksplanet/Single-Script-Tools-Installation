import aiohttp
import random
import string
import json
import asyncio
import argparse
import re
from typing import Set

# Define the mapping at the top of your script
RECORD_TYPE_CODES = {
    "A": 1,
    "AAAA": 28,
    "TXT": 16,
    "NS": 2,
    "CNAME": 5,
    "MX": 15
}

async def cloudflare_processing(subdomains, parallel_limit=20):
    # Cloudflare DNS Resolver API endpoint
    DNS_API_URL = "https://cloudflare-dns.com/dns-query"

    # Asynchronous function to query DNS records using aiohttp
    async def query_dns_records(session, subdomain, record_type):
        try:
            async with session.get(DNS_API_URL, params={'name': subdomain, 'type': record_type}, headers={'Accept': 'application/dns-json'}) as response:
                if response.status == 200:
                    raw_response = await response.text()
                    try:
                        result = json.loads(raw_response)
                        has_answer = "Answer" in result
                        answers = result.get("Answer", []) if has_answer else []

                        # Look at the first answer's type, as this represents the actual record type
                        # before any CNAME resolution
                        if answers:
                            first_answer_type = answers[0].get("type")
                            # Convert type code back to string for easier comparison
                            first_record_type = next(
                                (rtype for rtype, code in RECORD_TYPE_CODES.items()
                                 if code == first_answer_type), None
                            )
                            return bool(answers), answers, first_record_type

                        if not has_answer and "Authority" in result:
                            return False, [], None

                        return bool(answers), answers, None
                    except json.JSONDecodeError as e:
                        return False, [], None
        except Exception as e:
            return False, [], None

    # Asynchronous function to check for wildcard DNS
    async def wildcard_check(session, subdomain, record_type):
        try:
            record_type_code = RECORD_TYPE_CODES.get(record_type.upper())
            if not record_type_code:
                return False, None

            valid_base, base_answers, base_actual_type = await query_dns_records(session, subdomain, record_type)

            if not valid_base or not base_answers:
                return False, None

            # Split the subdomain into parts
            parts = subdomain.split('.')
            pattern_tests = []

            # Test each position for potential wildcards
            for i in range(len(parts) - 1):  # -1 to avoid testing the TLD
                # Create a test subdomain with a random part at position i
                test_parts = parts.copy()
                random_label = ''.join(random.choices(string.ascii_lowercase, k=10))
                test_parts[i] = random_label
                test_subdomain = '.'.join(test_parts)
                pattern_tests.append(test_subdomain)

                # Create a second test to confirm the pattern
                test_parts[i] = ''.join(random.choices(string.ascii_lowercase, k=8))
                pattern_tests.append('.'.join(test_parts))

            # Test all generated patterns
            for test_subdomain in pattern_tests:
                valid_garbage, garbage_answers, garbage_actual_type = await query_dns_records(
                    session, test_subdomain, record_type
                )
                
                # If any test succeeds with the same record type, it's a wildcard
                if valid_garbage and base_actual_type == garbage_actual_type:
                    return True, base_actual_type

            return False, None

        except Exception as e:
            print(f"[!] Error during wildcard check: {str(e)}")
            return False, None

    # Asynchronous function to process each subdomain
    async def process_subdomain(session, subdomain):
        record_types = ["A", "AAAA", "NS", "CNAME", "TXT", "MX"]
        try:
            for record_type in record_types:
                has_records, _, actual_type = await query_dns_records(session, subdomain, record_type)
                if has_records:
                    is_wildcard, wildcard_type = await wildcard_check(session, subdomain, record_type)
                    if is_wildcard:
                        return (subdomain, False, f"wildcard_{wildcard_type}")
                    else:
                        return (subdomain, True, None)
            return (subdomain, False, "no_records")
        except Exception as e:
            return (subdomain, False, "error")

    # Asynchronous function to handle DNS queries in parallel
    async def process_subdomains(subdomains):
        async with aiohttp.ClientSession() as session:
            tasks = []
            for subdomain in subdomains:
                tasks.append(process_subdomain(session, subdomain))
                if len(tasks) >= parallel_limit:
                    results = await asyncio.gather(*tasks, return_exceptions=True)
                    for result in results:
                        if not isinstance(result, Exception):
                            yield result
                    tasks = []
            if tasks:
                results = await asyncio.gather(*tasks, return_exceptions=True)
                for result in results:
                    if not isinstance(result, Exception):
                        yield result

    # Main function to run the processing
    valid_subs = []
    invalid_subs = []
    invalid_reasons = {}
    try:
        async with aiohttp.ClientSession() as session:
            async for subdomain, is_valid, reason in process_subdomains(subdomains):
                if is_valid:
                    valid_subs.append(subdomain)
                else:
                    invalid_subs.append(subdomain)
                    invalid_reasons[subdomain] = reason
    except Exception as e:
        pass
    finally:
        # Ensure all connections are closed
        await session.close()

    return valid_subs, invalid_subs, invalid_reasons

# Function to save valid subdomains to a text file
def save_valid_subdomains(valid_subs, output_file):
    with open(output_file, 'w') as f:
        for subdomain in valid_subs:
            f.write(f"{subdomain}\n")

# Example usage
if __name__ == "__main__":
    # Set up argument parser
    parser = argparse.ArgumentParser(
        description='Process subdomains and calculate potential Recon Royale points',
        epilog='''Example usage:

        python base.py -l subdomains.txt -t example.com
        python base.py -l subdomains.txt -t example.com -v

        The script will:
        1. Clean and validate subdomains from the input file
        2. Check each subdomain for DNS records
        3. Detect and filter out wildcard DNS entries
        4. Calculate potential Recon Royale points

        Output shows valid subdomains minus invalid ones for point calculation.
        Use -v for detailed output of valid/invalid subdomains.''',
        formatter_class=argparse.RawDescriptionHelpFormatter)

    parser.add_argument('-l', '--list', required=True, help='File containing list of subdomains')
    parser.add_argument('-t', '--target', required=True, help='Target domain to validate against')
    parser.add_argument('-v', '--verbose', action='store_true', help='Enable verbose output')
    parser.add_argument('-o', '--output', required=True, help='Output file to save valid subdomains')
    args = parser.parse_args()

    # Read subdomains from file
    try:
        with open(args.list) as f:
            lines = [line.strip() for line in f if line.strip()]
    except FileNotFoundError:
        print(f"Error: File {args.list} not found")
        exit(1)
    except Exception as e:
        print(f"Error reading file: {e}")
        exit(1)

    if not lines:
        print("No lines found in file")
        exit(1)

    # Pre-process subdomains
    subdomains = set()
    for line in lines:
        original_line = line
        # Remove any URL schemes first
        cleaned_line = re.sub(r'^[a-zA-Z]+://', '', line)
        if cleaned_line != line and args.verbose:
            print(f"Removed URL scheme from: {line} -> {cleaned_line}")

        # Remove ANSI escape sequences
        prev_line = cleaned_line
        cleaned_line = re.sub(r'\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])', '', cleaned_line)
        if cleaned_line != prev_line and args.verbose:
            print(f"Removed ANSI sequences from: {prev_line} -> {cleaned_line}")

        # Remove invalid characters
        prev_line = cleaned_line
        cleaned_line = re.sub(r'[^a-zA-Z0-9._-]', '', cleaned_line)
        if cleaned_line != prev_line and args.verbose:
            print(f"Removed invalid characters from: {prev_line} -> {cleaned_line}")

        # Convert to lowercase and strip
        prev_line = cleaned_line
        cleaned_line = cleaned_line.strip().lower()
        if cleaned_line != prev_line and args.verbose:
            print(f"Converted to lowercase and stripped: {prev_line} -> {cleaned_line}")

        # Remove leading dot if present
        prev_line = cleaned_line
        cleaned_line = cleaned_line.lstrip('.')
        if cleaned_line != prev_line and args.verbose:
            print(f"Removed leading dot from: {prev_line} -> {cleaned_line}")

        if not cleaned_line:
            if args.verbose:
                print(f"Rejected: '{original_line}' - Became empty after cleaning")
        elif cleaned_line == args.target:
            if args.verbose:
                print(f"Rejected: '{original_line}' - Matches target domain exactly")
        elif not cleaned_line.endswith("."+args.target):
            if args.verbose:
                print(f"Rejected: '{original_line}' - Does not end with target domain {args.target}")
        else:
            subdomains.add(cleaned_line)

    if not subdomains:
        print("No valid subdomains found after preprocessing")
        exit(1)

    if args.verbose:
        print(f"\nProcessing {len(subdomains)} unique subdomains...\n")

    # Run the asynchronous processing function
    valid_subs, invalid_subs, invalid_reasons = asyncio.run(
        cloudflare_processing(list(subdomains), parallel_limit=50)
    )

    # Save valid subdomains to the output file
    save_valid_subdomains(valid_subs, args.output)

    print("\n=== Final Results ===")
    if args.verbose:
        print("Valid Subdomains:")
        for sub in valid_subs:
            print(f"  - {sub}")

        print("\nInvalid Subdomains:")
        for sub in invalid_subs:
            reason = invalid_reasons[sub]
            if reason.startswith("wildcard_"):
                record_type = reason.split("_")[1]
                reason_text = f"wildcard DNS detected (Record type: {record_type})"
            else:
                reason_text = {
                    "no_records": "no DNS records found",
                    "error": "error during processing"
                }.get(reason, "unknown reason")
            print(f"  - {sub} ({reason_text})")
        print("__________________________")

    print(f"Total valid subdomains: {len(valid_subs)}")
    print(f"Total invalid subdomains: {len(invalid_subs)}")
    print(f"Total potential points on Recon Royale: {len(valid_subs) - len(invalid_subs)}")
    print(f"Valid subdomains saved to: {args.output}")
