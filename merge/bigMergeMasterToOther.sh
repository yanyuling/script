#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR

bigServer=$1
$DIR/../upd/updateClient.sh $bigServer || exit 1
$DIR/../upd/updateClientTrunk.sh || exit 1

rsync -avz --delete --exclude='*.svn*' $DIR/../../clientSvn/master/ $DIR/../../clientSvn/$bigServer/ || exit 1

cd $DIR/../../clientSvn/$bigServer || exit 1
svn stat | grep \\! | awk '{print $2}' | xargs svn remove || exit 1
svn add * --force || exit 1
svn commit -m "bigMergeMasterToOther" || exit 1
cd $DIR || exit 1