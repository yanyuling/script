#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR

# echo "生成apk"
# cd $DIR/../
# cocos compile -p android --compile-script 1 --lua-encrypt --lua-encrypt-key keyj7ge3ghk --lua-encrypt-sign signbvsjy78e4jvywl

versionName=$1
sed -i '' "s/android:versionName=\"100.0\"/android:versionName=\"$versionName\"/g" $DIR/../frameworks/runtime-src/proj.android/AndroidManifest.xml

echo "加密图片"
$DIR/encrypt_res.sh -i $DIR/../res -o $DIR/../res2 -es h98y8o9yeeqiie3t -ek zdjhgrs3sc72pll0 || exit 1
mv -f $DIR/../res $DIR/../res3 || exit 1
mv -f $DIR/../res2 $DIR/../res || exit 1
rm -rf $DIR/../res/ccs/views || exit 1
echo "编译加密lua"
# cocos luacompile -s $DIR/../src -d $DIR/../src2 -e -k keyj7ge3ghk -b signbvsjy78e4jvywl --encrypt --disable-compile || exit 1
$DIR/compile_scripts_enter.sh $DIR/../src $DIR/../src2 || exit 1
mv -f $DIR/../src $DIR/../src3 || exit 1
mv -f $DIR/../src2 $DIR/../src || exit 1
echo "编译加密ui lua"
$DIR/compile_scripts_enter.sh $DIR/../res3/ccs/views $DIR/../res/ccs/views || exit 1


echo "生成manifest"
$DIR/upd/manifest_gen.sh alpha || exit 1
mv -f $DIR/upd/projectRelease.manifest $DIR/../res/projectRelease.manifest || exit 1
mv -f $DIR/upd/projectDebug.manifest $DIR/../res/projectDebug.manifest || exit 1


echo "生成apk"
cd $DIR/../ || exit 1
cocos compile -p android || exit 1
cd $DIR || exit 1

echo "还原src和res"
rm -rf $DIR/../src || exit 1
mv -f $DIR/../src3 $DIR/../src || exit 1
rm -rf $DIR/../res || exit 1
mv -f $DIR/../res3 $DIR/../res || exit 1
rm -f $DIR/../res/projectRelease.manifest || exit 1
rm -f $DIR/../res/projectDebug.manifest || exit 1

echo "还原AndroidManifest"
svn revert $DIR/../frameworks/runtime-src/proj.android/AndroidManifest.xml

# echo "bugly符号表"
# $DIR/bugly/genSymbol.sh $versionName