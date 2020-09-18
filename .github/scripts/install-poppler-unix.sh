#!/bin/bash

# A script to install `poppler`, a PDF rendering library, on Unix systems

# Set auxiliary variables
# for ANSI escape codes
cyan="\e[1;36m" # Bold cyan
reset="\e[0m"   # Reset colors

echo -e "\n${cyan}Updating the lists of packages...${reset}\n"
sudo apt-get update

echo -e "\n${cyan}Installing \`python3-poppler-qt5\`...${reset}\n"
sudo apt-get install -y --no-install-recommends python3-poppler-qt5