#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR

echo "复制大图"
# rsync -avz --delete $DIR/../cocosstudio/cocosstudio/ccs/animation $DIR/../res/ccs/
#rsync -avz --delete $DIR/../src $DIR/../frameworks/runtime-src/proj.android/assets/

if [[ "$1"x = ""x ]]; then
    echo "错误-----必须输入分支"
    exit 1
fi

if [[ -d $DIR/../frameworks/runtime-src/proj.android/assets/src/ ]]; then
    rm -rf $DIR/../frameworks/runtime-src/proj.android/assets/src/ || exit 1
fi
mkdir -p $DIR/../frameworks/runtime-src/proj.android/assets/src/ || exit 1

if [[ -d $DIR/../frameworks/runtime-src/proj.android/assets/res/ ]]; then
    rm -rf $DIR/../frameworks/runtime-src/proj.android/assets/res/ || exit 1
fi

# rsync -avz --delete $DIR/../res $DIR/../frameworks/runtime-src/proj.android/assets/
# rsync -avz --delete $DIR/../src $DIR/../frameworks/runtime-src/proj.android/assets/
rsync -avz --delete $DIR/../config.json $DIR/../frameworks/runtime-src/proj.android/assets/ || exit 1

$DIR/encrypt_res.sh -i $DIR/../res -o $DIR/../frameworks/runtime-src/proj.android/assets/res -es h98y8o9yeeqiie3t -ek zdjhgrs3sc72pll0 || exit 1
rm -rf $DIR/../frameworks/runtime-src/proj.android/assets/res/ccs/views || exit 1
echo "编译加密ui lua"
$DIR/compile_scripts_enter.sh $DIR/../res/ccs/views $DIR/../frameworks/runtime-src/proj.android/assets/res/ccs/views || exit 1

# echo "加密lua"
# cocos luacompile -s $DIR/../src -d $DIR/../frameworks/runtime-src/proj.android/assets/src -e -k keyj7ge3ghk -b signbvsjy78e4jvywl --encrypt --disable-compile || exit 1

#加密lua
$DIR/compile_scripts_enter.sh $DIR/../src $DIR/../frameworks/runtime-src/proj.android/assets/src || exit 1

$DIR/upd/manifest_gen_android_proj.sh $1 || exit 1
# cp -rp $DIR/../src/ $DIR/../frameworks/runtime-src/proj.android/assets/src/

echo "执行成功"