#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR

echo "更新client trunk"
if [[ ! -d $DIR/../../clientSvn ]]; then
    mkdir $DIR/../../clientSvn
fi
if [[ ! -d $DIR/../../clientSvn/trunk ]]; then
    mkdir $DIR/../../clientSvn/trunk
fi
if [[ ! -d $DIR/../../clientSvn/trunk/tank2 ]]; then
    mkdir $DIR/../../clientSvn/trunk/tank2
fi
if [[ ! -d $DIR/../../clientSvn/trunk/tank2/src ]]; then
    svn checkout http://svn.raysns.com/repos/tank2/client/trunk/tank2/src $DIR/../../clientSvn/trunk/tank2/src
fi
if [[ ! -d $DIR/../../clientSvn/trunk/tank2/res ]]; then
    svn checkout http://svn.raysns.com/repos/tank2/client/trunk/tank2/res $DIR/../../clientSvn/trunk/tank2/res
fi
svn cleanup $DIR/../../clientSvn/trunk/tank2/src || exit 1
svn stat $DIR/../../clientSvn/trunk/tank2/src | grep \\? | awk '{print $2}' | xargs rm -rf || exit 1
svn revert -R $DIR/../../clientSvn/trunk/tank2/src  || exit 1
svn update $DIR/../../clientSvn/trunk/tank2/src || exit 1
svn cleanup $DIR/../../clientSvn/trunk/tank2/res || exit 1
svn stat $DIR/../../clientSvn/trunk/tank2/res | grep \\? | awk '{print $2}' | xargs rm -rf || exit 1
svn revert -R $DIR/../../clientSvn/trunk/tank2/res  || exit 1
svn update $DIR/../../clientSvn/trunk/tank2/res || exit 1