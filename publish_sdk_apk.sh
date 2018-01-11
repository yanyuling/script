#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR

channel=$1
echo "生成sdk包 $channel"

if [[ "$channel" == "uc" ]]; then
    channelId=419
else
    echo "不支持的channel"
    exit 1
fi
rm -rf ~/Documents/RSDKRelease/T2

cd /Applications/RSDKTools.app/Contents/MacOS || exit 1
outStr="`./RSDKCommand run -gameId 45 -channelId $channelId -userName rayjoy -gamePath /Users/zhaozhantao/me/apache-tomcat-8.0.23/webapps/ROOT/tank2/tank2-base.apk -isIos 0`" || exit 1
cd $DIR || exit 1

echo "复制文件"
rm -f "`find ~/Documents/RSDKRelease/T2 -name "common.apk"`"
cp -f "`find ~/Documents/RSDKRelease/T2 -name "*.apk"`" /Users/zhaozhantao/me/apache-tomcat-8.0.23/webapps/ROOT/tank2/tank2-sdk.apk || exit 1