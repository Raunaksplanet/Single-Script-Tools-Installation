#!/bin/bash

# Prompt for the domain name.
read -p "Enter the domain (e.g., example.com): " domain

echo "Fetching all URLs from the Wayback Machine..."
# Fetch all URLs for the given domain and exclude robots.txt and .well-known related files.
curl -G "https://web.archive.org/cdx/search/cdx" \
  --data-urlencode "url=*.$domain/*" \
  --data-urlencode "collapse=urlkey" \
  --data-urlencode "output=text" \
  --data-urlencode "fl=original" | \
  grep -Ev "/robots\.txt|/\.well-known/" > all_urls.txt

echo "Fetching URLs with specific file extensions..."
# Fetch only URLs ending with certain file extensions and exclude robots.txt and .well-known related files.
curl "https://web.archive.org/cdx/search/cdx?url=*.$domain/*&collapse=urlkey&output=text&fl=original&filter=original:.*\.(xls|xml|xlsx|json|pdf|sql|doc|docx|pptx|txt|git|zip|tar\.gz|tgz|bak|7z|rar|log|cache|secret|db|backup|yml|gz|config|csv|yaml|md|md5|exe|dll|bin|ini|bat|sh|tar|deb|rpm|iso|img|env|apk|msi|dmg|tmp|crt|pem|key|pub|asc)$" | \
  grep -Ev "/robots\.txt|/\.well-known/" > filtered_urls.txt

echo "Done! Results saved to:"
echo "  - all_urls.txt (all URLs, excluding robots.txt and .well-known)"
echo "  - filtered_urls.txt (Filtered URLs, excluding robots.txt and .well-known)"
