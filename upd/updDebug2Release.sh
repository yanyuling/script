#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR

bigServer=$1
$DIR/updateClientweb.sh $bigServer || exit 1
echo "将debug内容复制到release文件夹" || exit 1
echo "$DIR/../../clientwebPatch/$bigServer/debug/ $DIR/../../clientwebPatch/$bigServer/release/"
rsync -avz --delete $DIR/../../clientwebPatch/$bigServer/debug/ $DIR/../../clientwebPatch/$bigServer/release/ || exit 1
echo "地址debug改release"
sed -i '' "s/patch\/debug/patch\/release/g" $DIR/../../clientwebPatch/$bigServer/release/version.manifest || exit 1
sed -i '' "s/patch\/debug/patch\/release/g" $DIR/../../clientwebPatch/$bigServer/release/number/project.manifest || exit 1

echo "上传patch svn"
cd $DIR/../../clientwebPatch/$bigServer/release
svn stat | grep \\! | awk '{print $2}' | xargs svn remove || exit 1
svn add * --force || exit 1
svn commit -m "切到正式" || exit 1