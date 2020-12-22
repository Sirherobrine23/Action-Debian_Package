#!/bin/bash
if [ $INPUT_DEBUG == 'true' ];then
    env
fi
echo "Preparing to upload the file"
    cd /tmp/repo
    if cd $INPUT_PATH;then
        echo $PWD
        echo 'inside the directory'
    else
        echo 'Error entering the directory'
        find .
        exit 23
    fi
    cp -rfv $DEB_PATH ./
fi
#
#
exit 0