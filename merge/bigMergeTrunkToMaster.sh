#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR

$DIR/../upd/updateClient.sh master || exit 1
$DIR/../upd/updateClientTrunk.sh || exit 1

rsync -avz --delete --exclude='*.svn*' $DIR/../../clientSvn/trunk/ $DIR/../../clientSvn/master/ || exit 1

cd $DIR/../../clientSvn/master || exit 1
svn stat | grep \\! | awk '{print $2}' | xargs svn remove || exit 1
svn add * --force || exit 1
svn commit -m "bigMergeTrunkToMaster" || exit 1
cd $DIR || exit 1