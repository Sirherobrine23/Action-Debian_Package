#!/bin/bash
echo "Preparing to upload the file"

if [ $INPUT_GIT == 'true' ];then
    git config --global user.name ${GITHUB_ACTOR}
    git config --global user.email "actions@github.com"
    if [ $INPUT_URL == 'http://' ];then
        REPO="http://$INPUT_TOKEN@$(echo $INPUT_URL |sed 's|http://||g')"
    elif [ $INPUT_URL == 'https://' ];then
        REPO="http://$INPUT_TOKEN@$(echo $INPUT_URL |sed 's|https://||g')"
    else
        REPO="git://$INPUT_TOKEN@$(echo $INPUT_URL |sed 's|http://||g')"
    fi
    git clone --depth=1 $REPO -b $INPUT_BRANCH /tmp/repo
    cd /tmp/repo/$INPUT_PATH
    cp -rfv DEB_PATH ./
    git add .
    git commit -m "Package add from ${GITHUB_REPO}"
    git push
fi
#
#
exit 0