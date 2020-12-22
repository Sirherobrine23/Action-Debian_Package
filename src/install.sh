#!/bin/env bash
DEBIAN_FRONTEND=noninteractive
# 
sudo apt-get -qq update
sudo apt-get install -y curl dos2unix wget git dpkg-dev
sudo apt clean
# 
apt purge --remove *dotnet* -y
sudo rm -rf /usr/share/dotnet
sudo rm -rf /usr/local/lib/android
# Autoremove
sudo apt-get -qq autoremove --purge
sudo swapoff -a
sudo rm -rf /mnt/swap*
exit 0