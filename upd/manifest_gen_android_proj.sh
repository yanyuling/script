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
    echo "错误----必须输入分支"
    exit 1
fi

echo "生成manifest"

resVer="`svn info | grep Revision|awk   '{printf $2}'`" || exit 1
echo "资源版本$resVer" || exit 1
allmd5="" || exit 1

fileList="$(find ../../frameworks/runtime-src/proj.android/assets/src -name "*.*")" || exit 1
for i in $fileList; do
    echo ${i#*proj.android/assets/}
    if [[ -f $DIR/$i && ! $i =~ "DS_Store" ]]; then
        fileMd5="$(md5 -q $DIR/$i )" || exit 1
        allmd5="$allmd5, \"${i#*proj.android/assets/}\":{\"md5\":\"$fileMd5\"}" || exit 1
    fi
done
fileList="$(find ../../frameworks/runtime-src/proj.android/assets/res -name "*.*")" || exit 1
for i in $fileList; do
    echo ${i#*proj.android/assets/}
    if [[ -f $DIR/$i && ! $i =~ "DS_Store" ]]; then
        fileMd5="$(md5 -q $DIR/$i )" || exit 1
        allmd5="$allmd5, \"${i#*proj.android/assets/}\":{\"md5\":\"$fileMd5\"}" || exit 1
    fi
done
# echo "{\"packageUrl\" : \"http://192.168.100.98:8080/tank2upd/\",\"remoteManifestUrl\" : \"http://192.168.100.98:8080/tank2upd/project.manifest\",\"remoteVersionUrl\" : \"http://192.168.100.98:8080/tank2upd/version.manifest\",\"version\" : \"`svn info | grep Revision|awk   '{printf $2}'`\",\"engineVersion\" : \"3.x dev\",\"assets\" : {${allmd5#*,}},\"searchPaths\" : []}" > project.manifest || exit 1
# echo "{\"packageUrl\" : \"http://192.168.100.98:8080/tank2upd/\",\"remoteManifestUrl\" : \"http://192.168.100.98:8080/tank2upd/project.manifest\",\"remoteVersionUrl\" : \"http://192.168.100.98:8080/tank2upd/version.manifest\",\"version\" : \"`svn info | grep Revision|awk   '{printf $2}'`\",\"engineVersion\" : \"3.x dev\"}" > version.manifest || exit 1


echo "{\"packageUrl\" : \"$gateUrl/clientweb/patch/debug/number/\",\"remoteManifestUrl\" : \"$gateUrl/clientweb/patch/debug/number/project.manifest\",\"remoteVersionUrl\" : \"$gateUrl/clientweb/patch/debug/version.manifest\",\"version\" : \"$resVer\",\"engineVersion\" : \"3.x dev\",\"assets\" : {${allmd5#*,}},\"searchPaths\" : []}" > projectDebug.manifest || exit 1
echo "{\"packageUrl\" : \"$gateUrl/clientweb/patch/release/number/\",\"remoteManifestUrl\" : \"$gateUrl/clientweb/patch/release/number/project.manifest\",\"remoteVersionUrl\" : \"$gateUrl/clientweb/patch/release/version.manifest\",\"version\" : \"$resVer\",\"engineVersion\" : \"3.x dev\",\"assets\" : {${allmd5#*,}},\"searchPaths\" : []}" > projectRelease.manifest || exit 1
mv projectDebug.manifest $DIR/../../frameworks/runtime-src/proj.android/assets/res/projectDebug.manifest
mv projectRelease.manifest $DIR/../../frameworks/runtime-src/proj.android/assets/res/projectRelease.manifest