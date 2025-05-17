awk '{ print length, $0 }' 200s.txt | sort -n | cut -d" " -f2- | anew data
