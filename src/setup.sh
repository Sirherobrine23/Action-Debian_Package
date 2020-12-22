#!/bin/bash
set -x
exit 0
DEBIAN_FRONTEND=noninteractive
echo "::group::Updating Repositories"
    sudo apt update
echo "::endgroup::"
#
echo "::group::Installing the necessary packages"
    sudo apt install -y curl dos2unix wget git dpkg-dev
    sudo apt clean
echo "::endgroup::"
#
if [ $INPUT_SPACE == 'true' ];then
    echo "::group::Removing unnecessary apt packages"
        apt purge --remove *dotnet* -y
        sudo rm -rf /usr/share/dotnet
        sudo rm -rf /usr/local/lib/android
    echo "::endgroup::"
fi
#
# Autoremove
echo "::group::Removing unnecessary apt packages"
    sudo apt-get -qq autoremove --purge -y
echo "::endgroup::"
#
echo "::group::Removing the swap"
    sudo swapoff -a
    sudo rm -rf /mnt/swap*
echo "::endgroup::"
exit 0