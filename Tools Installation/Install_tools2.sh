#!/bin/bash

# Author: Raunaksplanet
# Date: 26/07/2024


# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to print messages with color
print_color() {
  echo -e "${1}${2}${NC}"
}

# Function to check if a package is installed
check_and_install() {
  if dpkg -l | grep -q "^ii\s\+$1\s"; then
    print_color $GREEN "$1 is already installed"
  else
    sudo apt-get install -y $1 && print_color $GREEN "Installed $1" || print_color $RED "Failed to install $1"
  fi
}

# Function to check if a Go tool is installed
check_and_install_go_tool() {
  if [ -x "$(command -v $1)" ]; then
    print_color $GREEN "$1 is already installed"
  else
    go install $2 && print_color $GREEN "Installed $1" || print_color $RED "Failed to install $1"
  fi
}

# Function to check if a Python tool is installed
check_and_install_python_tool() {
  if pip show $1 > /dev/null 2>&1; then
    print_color $GREEN "$1 is already installed"
  else
    pip install $1 && print_color $GREEN "Installed $1" || print_color $RED "Failed to install $1"
  fi
}

# Function to check if a Python3 tool is installed
check_and_install_python3_tool() {
  if pip3 show $1 > /dev/null 2>&1; then
    print_color $GREEN "$1 is already installed"
  else
    pip3 install $1 && print_color $GREEN "Installed $1" || print_color $RED "Failed to install $1"
  fi
}

print_color $YELLOW "Checking and installing packages..."

check_and_install python
check_and_install golang-go
check_and_install python-pip
check_and_install python3
check_and_install python3-pip
check_and_install python-dnspython
check_and_install python-dev
check_and_install python-setuptools
check_and_install virtualenv
check_and_install unzip
check_and_install make
check_and_install gcc
check_and_install libpcap-dev
check_and_install curl
check_and_install build-essential
check_and_install libcurl4-openssl-dev
check_and_install libldns-dev
check_and_install libssl-dev
check_and_install libffi-dev
check_and_install libxml2
check_and_install jq
check_and_install libxml2-dev
check_and_install libxslt1-dev
check_and_install ruby-dev
check_and_install ruby-full
check_and_install libgmp-dev
check_and_install zlib1g-dev
check_and_install dirsearch

print_color $YELLOW "Creating Tools directory..."
mkdir -p Tools && cd Tools && print_color $GREEN "Created and navigated to Tools directory" || print_color $RED "Failed to create Tools directory"

print_color $YELLOW "Installing assetfinder..."
check_and_install assetfinder

print_color $YELLOW "Installing subfinder..."
check_and_install subfinder

print_color $YELLOW "Cloning repositories..."
if [ ! -d "Subdomain" ]; then
  git clone https://github.com/Raunaksplanet/Subdomain.git && print_color $GREEN "Cloned Subdomain" || print_color $RED "Failed to clone Subdomain"
else
  print_color $GREEN "Subdomain repository already exists"
fi

sleep 1.5

if [ ! -d "Aranea" ]; then
  git clone https://github.com/leddcode/Aranea && print_color $GREEN "Cloned Aranea" || print_color $RED "Failed to clone Aranea"
else
  print_color $GREEN "Aranea repository already exists"
fi

sleep 1.5

print_color $YELLOW "Downloading revlookup..."
if [ ! -f "/bin/revlookup" ]; then
  wget https://raw.githubusercontent.com/yHunterDep/revlookup/main/revlookup && print_color $GREEN "Downloaded revlookup" || print_color $RED "Failed to download revlookup"
  sudo mv revlookup /bin/ && print_color $GREEN "Moved revlookup to /bin/" || print_color $RED "Failed to move revlookup to /bin/"
else
  print_color $GREEN "revlookup is already downloaded and moved to /bin/"
fi

wget https://raw.githubusercontent.com/Raunaksplanet/Custom-Tools/main/CRTsh.py

print_color $YELLOW "Installing Go tools..."
check_and_install_go_tool anew github.com/tomnomnom/anew@latest
sleep 1.5
check_and_install_go_tool asnmap github.com/projectdiscovery/asnmap/cmd/asnmap@latest
sleep 1.5
check_and_install_go_tool katana github.com/projectdiscovery/katana/cmd/katana@latest
sleep 1.5
check_and_install_go_tool gospider github.com/jaeles-project/gospider@latest
sleep 1.5
check_and_install_go_tool gau github.com/lc/gau/v2/cmd/gau@latest
sleep 1.5

print_color $YELLOW "Installing Python tools..."
check_and_install_python_tool waymore
check_and_install_python3_tool arjun
