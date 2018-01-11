#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR

bigServer=$1
echo "生成母包apk $bigServer"
sed -i '' "s/public static boolean useSdk = false;/public static boolean useSdk = true;/g" $DIR/../frameworks/runtime-src/proj.android/src/org/cocos2dx/lua/SdkUtil.java || exit 1

$DIR/cp_src_res_android_with_opt.sh $bigServer || exit 1

cd $DIR/../frameworks/runtime-src/proj.android/ || exit 1
ant release || exit 1
cd $DIR || exit 1