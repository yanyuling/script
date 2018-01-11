#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR

bigServer=$1

echo "更新clientweb"
if [[ ! -d $DIR/../../clientwebPatch ]]; then
    mkdir $DIR/../../clientwebPatch
fi
if [[ ! -d $DIR/../../clientwebPatch/$bigServer ]]; then
    svn checkout http://publish.rayjoy.com/repos/tank2/publish/client/$bigServer $DIR/../../clientwebPatch/$bigServer
fi
svn cleanup $DIR/../../clientwebPatch/$bigServer || exit 1
svn stat $DIR/../../clientwebPatch/$bigServer | grep \\? | awk '{print $2}' | xargs rm -rf || exit 1
svn revert -R $DIR/../../clientwebPatch/$bigServer  || exit 1
svn update $DIR/../../clientwebPatch/$bigServer || exit 1