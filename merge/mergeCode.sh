#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR


bigServer=$1
ver=$2
$DIR/../upd/updateClient.sh $bigServer || exit 1
$DIR/../upd/updateClient.sh master || exit 1
$DIR/../upd/updateClientTrunk.sh || exit 1

echo "开始合并到master"
cd $DIR/../../clientSvn/master
svn merge -c$ver ^/client/trunk || exit 1
svn commit -m "merge from trunk $ver" || exit 1
cd $DIR
echo "结束合并到master"
date

if [[ "z"$bigServer == "z" ]]; then
    echo "只合并到master"
else
    cd $DIR/../../clientSvn/$bigServer
    svn merge -c$ver ^/client/trunk || exit 1
    svn commit -m "merge from trunk $ver" || exit 1
    cd $DIR
    echo "结束合并到$bigServer"
fi
