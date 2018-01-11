#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR

bigServer=$1
$DIR/updateClient.sh $bigServer || exit 1
$DIR/updateClientTrunk.sh || exit 1
echo "复制文件"
rsync -avz --delete --exclude ".svn" $DIR/../../clientSvn/trunk/tank2/ $DIR/../../clientSvn/$bigServer/tank2/ || exit 1
echo "上传patch svn"
cd $DIR/../../clientSvn/$bigServer/
svn stat | grep \\! | awk '{print $2}' | xargs svn remove || exit 1
svn add * --force || exit 1
svn commit -m "测试提交" || exit 1
cd $DIR