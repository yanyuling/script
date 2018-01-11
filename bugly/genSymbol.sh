#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR

#版本
versionName=$1

echo "生成符号表"
java -jar buglySymbolAndroid.jar -i $DIR/../../frameworks/runtime-src/proj.android/obj/local/armeabi/libcocos2dlua.so -o $DIR/symbol.zip


echo "上传符号表"
curl -L --header "Content-Type: application/zip" --data-binary @symbol.zip 'http://bugly.qq.com/upload/symbol?pid=1&app=1ef5ff894d&key=a28f403d-7863-41b5-b2f7-a96da4f70636&bid=com.rayjoy.tank2&ver='$versionName'&n=symbol.zip' --verbose