#!/bin/env bash
set -x
DEBIAN_FRONTEND=noninteractive
# 
sudo apt update
sudo apt install -y curl dos2unix wget git dpkg-dev
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