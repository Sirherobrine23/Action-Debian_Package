#!/bin/bash
set -x
DEBIAN_FRONTEND=noninteractive
# 
sudo apt update &> /tmp/apt.txt
sudo apt install -y curl dos2unix wget git dpkg-dev &> /tmp/apt.txt
sudo apt clean &> /tmp/apt.txt
# 
apt purge --remove *dotnet* -y &> /tmp/apt.txt
sudo rm -rf /usr/share/dotnet &> /tmp/apt.txt
sudo rm -rf /usr/local/lib/android &> /tmp/apt.txt
# Autoremove
sudo apt-get -qq autoremove --purge &> /tmp/apt.txt
sudo swapoff -a &> /tmp/apt.txt
sudo rm -rf /mnt/swap* &> /tmp/apt.txt
exit 0