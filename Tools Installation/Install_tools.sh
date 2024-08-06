#!/bin/bash

# Update and install prerequisites
sudo apt update
sudo apt install -y git curl jq python3 python3-pip nmap ruby snapd

# Install SubFinder
echo "Installing SubFinder..."
GO111MODULE=on go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

# Install AssetFinder
echo "Installing AssetFinder..."
go install -v github.com/tomnomnom/assetfinder@latest

# Install Chaos
echo "Installing Chaos..."
go install -v github.com/projectdiscovery/chaos-client/cmd/chaos@latest

# Install Amass
echo "Installing Amass..."
go install -v github.com/OWASP/Amass/v3/...@master

# Install HTTPx
echo "Installing HTTPx..."
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

# Install Naabu
echo "Installing Naabu..."
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest

# Install Gau
echo "Installing Gau..."
go install -v github.com/lc/gau@latest

# Install Katana
echo "Installing Katana..."
go install -v github.com/projectdiscovery/katana/cmd/katana@latest

# Install Waybackurls
echo "Installing Waybackurls..."
go install -v github.com/tomnomnom/waybackurls@latest

# Install Uro
echo "Installing Uro..."
pip3 install uro

# Install Dirsearch
echo "Installing Dirsearch..."
git clone https://github.com/maurosoria/dirsearch.git
cd dirsearch
pip3 install -r requirements.txt
cd ..

# Install Nuclei
echo "Installing Nuclei..."
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest

# Install SecretFinder
echo "Installing SecretFinder..."
git clone https://github.com/m4ll0k/SecretFinder.git
cd SecretFinder
pip3 install -r requirements.txt
cd ..

# Install Subzy
echo "Installing Subzy..."
go install -v github.com/LukaSikic/subzy@latest

# Install Corsy
echo "Installing Corsy..."
git clone https://github.com/s0md3v/Corsy.git
cd Corsy
pip3 install -r requirements.txt
cd ..

# Install SQLMap
echo "Installing SQLMap..."
git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git sqlmap-dev
cd sqlmap-dev
python3 setup.py install
cd ..

# Install XSStrike
echo "Installing XSStrike..."
git clone https://github.com/s0md3v/XSStrike.git
cd XSStrike
pip3 install -r requirements.txt
cd ..

# Install TruffleHog
echo "Installing TruffleHog..."
pip3 install truffleHog

# Install Shodan CLI
echo "Installing Shodan CLI..."
pip3 install shodan

# Install Masscan
echo "Installing Masscan..."
git clone https://github.com/robertdavidgraham/masscan
cd masscan
make
sudo make install
cd ..

# Install Aquatone
echo "Installing Aquatone..."
go install -v github.com/michenriksen/aquatone@latest

# Install Gitrob
echo "Installing Gitrob..."
go install -v github.com/michenriksen/gitrob@latest

# Install JSParser
echo "Installing JSParser..."
git clone https://github.com/nahamsec/JSParser.git
cd JSParser
sudo python setup.py install
cd ..

# Install Sublist3r
echo "Installing Sublist3r..."
git clone https://github.com/aboul3la/Sublist3r.git
cd Sublist3r
pip install -r requirements.txt
cd ..

# Install WPScan
echo "Installing WPScan..."
git clone https://github.com/wpscanteam/wpscan.git
cd wpscan
sudo gem install bundler && bundle install --without test
cd ..

# Install Lazys3
echo "Installing Lazys3..."
git clone https://github.com/nahamsec/lazys3.git
cd ..

# Install Virtual Host Discovery
echo "Installing Virtual Host Discovery..."
git clone https://github.com/jobertabma/virtual-host-discovery.git
cd ..

# Install Knock.py
echo "Installing Knock.py..."
git clone https://github.com/guelfoweb/knock.git
cd ..

# Install LazyRecon
echo "Installing LazyRecon..."
git clone https://github.com/nahamsec/lazyrecon.git
cd ..

# Install ASNLookup
echo "Installing ASNLookup..."
git clone https://github.com/yassineaboukir/asnlookup.git
cd asnlookup
pip install -r requirements.txt
cd ..

# Install httprobe
echo "Installing httprobe..."
go get -u github.com/tomnomnom/httprobe

# Install Unfurl
echo "Installing Unfurl..."
go get -u github.com/tomnomnom/unfurl

# Install crtndstry
echo "Installing crtndstry..."
git clone https://github.com/nahamsec/crtndstry.git
cd ..

# Install Chromium
echo "Installing Chromium..."
sudo snap install chromium

# Download Seclists
echo "Downloading Seclists..."
git clone https://github.com/danielmiessler/SecLists.git
cd SecLists/Discovery/DNS/
cat dns-Jhaddix.txt | head -n -14 > clean-jhaddix-dns.txt
cd ..

echo "All tools installed successfully!"

