#!/bin/bash
set -x
DEBIAN_FRONTEND=noninteractive
#
echo "Updating Repositories"
sudo apt update &> /tmp/apt.txt
echo "Installing the necessary packages"
sudo apt install -y curl dos2unix wget git dpkg-dev &> /tmp/apt.txt
sudo apt clean &> /tmp/apt.txt
#
if [ $INPUT_SPACE == 'true' ];then
    echo "Removing unnecessary packages"
    apt purge --remove *dotnet* -y &> /tmp/apt.txt
    sudo rm -rf /usr/share/dotnet &> /tmp/apt.txt
    sudo rm -rf /usr/local/lib/android &> /tmp/apt.txt
fi
# Autoremove
sudo apt-get -qq autoremove --purge &> /tmp/apt.txt
echo "removing the swap"
sudo swapoff -a &> /tmp/apt.txt
sudo rm -rf /mnt/swap* &> /tmp/apt.txt
exit 0