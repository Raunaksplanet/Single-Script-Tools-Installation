#!/bin/bash

help(){
    echo -e "[Usage]:"
    echo -e "\t$ ~/subdomain.sh DOMAIN"
}

getSubdomains(){
    curl -s "https://shrewdeye.app/domains/$1.txt" | sort -u >> tmp.txt &
    curl -s "https://api.subdomain.center/?domain=$1" | jq -r '.[]' | sort -u >> tmp.txt &
    curl -s "https://leakix.net/api/subdomains/$1" | jq -r '.[].subdomain' | sort -u >> tmp.txt &
    curl -s "https://api.hackertarget.com/hostsearch/?q=$1" | cut -d ',' -f1 | sort -u >> tmp.txt &
    curl -s "https://api.threatminer.org/v2/domain.php?q=$1&rt=5" | jq -r '.results[]' | sort -u >> tmp.txt &
    curl -s "https://crt.sh/?q=%.$1&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u >> tmp.txt &
    curl -s "https://urlscan.io/api/v1/search/?q=domain:$1" | jq -r '.results[].page.domain' | sort -u >> tmp.txt &
    curl -s "https://myssl.com/api/v1/discover_sub_domain?domain=$1" | jq -r '.data[].domain' | sort -u >> tmp.txt &
    curl -s "https://riddler.io/search/exportcsv?q=pld:$1" | grep -o "\w.*$1" | cut -d ',' -f6 | sort -u >> tmp.txt &
    curl -s "https://www.virustotal.com/ui/domains/$1/subdomains?limit=40" | grep '"id":' | cut -d '"' -f4 | sort -u >> tmp.txt &
    curl -s "https://rapiddns.io/subdomain/$1?full=1#result" | grep "$1" | awk -F'[<>]' '/'"$1"'/ {print $3}' | sort -u >> tmp.txt &
    curl -s "https://otx.alienvault.com/api/v1/indicators/domain/$1/passive_dns" | jq -r ".passive_dns[].hostname" | sort -u >> tmp.txt &
    curl -s "https://dns.bufferover.run/dns?q=.$1" | jq -r .RDNS[] 2>/dev/null | cut -d ',' -f2 | grep -o "\w.*$1" | sort -u >> tmp.txt &
    curl -s "https://tls.bufferover.run/dns?q=.$1" | jq -r .Results 2>/dev/null | cut -d ',' -f3 | grep -o "\w.*$1"| sort -u >> tmp.txt &
    curl -s "https://dns.bufferover.run/dns?q=.$1" | jq -r .FDNS_A[] 2>/dev/null | cut -d ',' -f2 | grep -o "\w.*$1" | sort -u >> tmp.txt &
    curl -s "https://jldc.me/anubis/subdomains/$1" | jq -r '.' | cut -d '"' -f2 | cut -d '[' -f1 | cut -d ']' -f1 | grep . | sort -u >> tmp.txt &
    curl -s "https://api.certspotter.com/v1/issuances?domain=$1&include_subdomains=true&expand=dns_names" | jq -r '.[].dns_names[]' | sort -u >> tmp.txt &
    curl -s "https://app.netlas.io/api/domains/?q=domain:*.$1+AND+NOT+domain:$1&source_type=include" | jq -r '.items[].data.domain' | sort -u >> tmp.txt &
    curl -s "https://www.threatcrowd.org/searchApi/v2/domain/report/?domain=$1" | jq '.subdomains' | cut -d '"' -f2 | cut -d '[' -f1 | cut -d ']' -f1 | grep . | sort -u >> tmp.txt &
    curl -s "https://www.virustotal.com/vtapi/v2/domain/report?apikey=2d1ed4d97f91c3c18877c02c5d14225e95c2b5dab7c16a524efa0b94cfd1c0a9&domain=$1" | jq -r '.subdomains[]' | sort -u >> tmp.txt &
    curl -s "http://web.archive.org/cdx/search/cdx?url=*.$1/*&output=text&fl=original&collapse=urlkey" | sort | sed -e 's_https*://__' -e "s/\/.*//" -e 's/:.*//' -e 's/^www\.//' | sort -u >> tmp.txt &
    curl -s -X GET "https://api.securitytrails.com/v1/domain/$1/subdomains" -H "Accept: application/json" -H "APIKEY: OklShxh2JYjVwzxr7xHefSG4wXdlyCE6" | jq -r '.subdomains[] + ".$1"' | sort -u >> tmp.txt &

    csrftoken=$(curl -ILs https://dnsdumpster.com | grep csrftoken | cut -d " " -f2 | cut -d "=" -f2 | tr -d ";")
    curl -s --header "Host:dnsdumpster.com" --referer https://dnsdumpster.com --user-agent "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:45.0) Gecko/20100101 Firefox/45.0" --data "csrfmiddlewaretoken=$csrftoken&targetip=$1" --cookie "csrftoken=$csrftoken; _ga=GA1.2.1737013576.1458811829; _gat=1" https://dnsdumpster.com >> dnsdumpster.html
    if [[ -e $1 && -s $1 ]]; then # file exists and is not zero size
        cat dnsdumpster.html | grep "https://api.hackertarget.com/httpheaders" | grep -o "\w.*$1" | cut -d "/" -f7 | grep '.' | sort -u >> tmp.txt
    fi
    cat tmp.txt | grep -iv "*" | sort -u | grep $1 | tee
    rm -rf dnsdumpster.html
    rm -rf tmp.txt
}

if [[ -z $1 ]]; then help; else getSubdomains $1; fi
