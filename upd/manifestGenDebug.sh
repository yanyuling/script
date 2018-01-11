#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR

bigServer=$1
gateUrl="http://192.168.8.81"
if [[ "$bigServer"x = "cn_uc"x ]]; then
    gateUrl="http://tank2-cnuc-in.raygame3.com"
elif [[ "$bigServer"x = "alpha"x ]]; then
    gateUrl="http://192.168.8.81"
elif [[ "$bigServer"x = "shenji"x ]]; then
    gateUrl="http://t2sj.raygame3.com"
elif [[ "$bigServer"x = "out"x ]]; then
    gateUrl="http://tank2-cntest.raygame3.com"
elif [[ "$bigServer"x = "mailiang"x ]]; then
    gateUrl="http://tank2-ml-in.raygame3.com"
else
    echo "必须输入分支"
    exit 1
fi

echo "生成manifest"
resVer="`svn info $DIR/../../clientSvn/$bigServer | grep Revision|awk   '{printf $2}'`"
echo "资源版本$resVer"
allmd5=""

fileList="$(find $DIR/../../tmpData/$bigServer/numberNoMd5/src -name "*.*")" || exit 1
# echo $fileList
for i in $fileList; do
    echo $i
    if [[ -f $i && ! $i =~ "DS_Store" ]]; then
        fileMd5="$(md5 -q $i )" || exit 1
        allmd5="$allmd5, \"${i#*/numberNoMd5/}\":{\"md5\":\"$fileMd5\"}" || exit 1
    fi
done
fileList="$(find $DIR/../../tmpData/$bigServer/numberNoMd5/res -name "*.*")" || exit 1
for i in $fileList; do
    if [[ -f $i && ! $i =~ "DS_Store" ]]; then
        fileMd5="$(md5 -q $i )" || exit 1
        allmd5="$allmd5, \"${i#*/numberNoMd5/}\":{\"md5\":\"$fileMd5\"}" || exit 1
    fi
done
# echo "打印md5"
# echo $allmd5
echo "{\"packageUrl\" : \"$gateUrl/clientweb/patch/debug/number/\",\"remoteManifestUrl\" : \"$gateUrl/clientweb/patch/debug/number/project.manifest\",\"remoteVersionUrl\" : \"$gateUrl/clientweb/patch/debug/version.manifest\",\"version\" : \"$resVer\",\"engineVersion\" : \"3.x dev\",\"assets\" : {${allmd5#*,}},\"searchPaths\" : []}" > $DIR/../../tmpData/$bigServer/project.manifest || exit 1
echo "{\"packageUrl\" : \"$gateUrl/clientweb/patch/debug/number/\",\"remoteManifestUrl\" : \"$gateUrl/clientweb/patch/debug/number/project.manifest\",\"remoteVersionUrl\" : \"$gateUrl/clientweb/patch/debug/version.manifest\",\"version\" : \"$resVer\",\"engineVersion\" : \"3.x dev\"}" > $DIR/../../tmpData/$bigServer/version.manifest || exit 1