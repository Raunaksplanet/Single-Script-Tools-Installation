#!/bin/bash

# Install dependencies
sudo apt-get update
sudo apt-get install -y jq prips wget

# Install additional tools
go install github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/tomnomnom/assetfinder@latest
go install github.com/tomnomnom/waybackurls@latest
go install github.com/hakluke/hakrawler@latest
go install github.com/jaeles-project/gospider@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest

# Make the script executable
chmod +x your_script_name.sh

echo "Setup complete. You can now run the tool using ./your_script_name.sh"
