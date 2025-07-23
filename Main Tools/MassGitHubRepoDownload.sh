mkdir zerodha-repos && cd zerodha-repos

for page in {1..5}; do
  curl -s "https://api.github.com/orgs/zerodha/repos?per_page=100&page=$page" | \
  grep -o 'https://github.com/zerodha/[^"]*' | \
  while read repo; do
    git clone "$repo.git"
  done
done
