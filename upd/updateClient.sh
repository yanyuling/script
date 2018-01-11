#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR

bigServer=$1

echo "更新client"
if [[ ! -d $DIR/../../clientSvn ]]; then
    mkdir $DIR/../../clientSvn
fi
if [[ ! -d $DIR/../../clientSvn/$bigServer ]]; then
    svn checkout http://svn.raysns.com/repos/tank2/client/branches/$bigServer $DIR/../../clientSvn/$bigServer
fi

svn cleanup $DIR/../../clientSvn/$bigServer || exit 1
svn stat $DIR/../../clientSvn/$bigServer | grep \\? | awk '{print $2}' | xargs rm -rf || exit 1
svn revert -R $DIR/../../clientSvn/$bigServer  || exit 1
svn update $DIR/../../clientSvn/$bigServer