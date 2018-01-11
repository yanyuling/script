#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR

bigServer=$1
$DIR/updateClient.sh $bigServer || exit 1
$DIR/updateClientweb.sh $bigServer || exit 1
if [[ ! -d $DIR/../../tmpData ]]; then
    mkdir $DIR/../../tmpData || exit 1
fi
if [[ -d $DIR/../../tmpData/$bigServer ]]; then
    rm -rf $DIR/../../tmpData/$bigServer || exit 1
fi
if [[ ! -d $DIR/../../tmpData/$bigServer ]]; then
    mkdir $DIR/../../tmpData/$bigServer || exit 1
fi
echo "开始加密lua"
date
echo "编译加密lua"
# cocos luacompile -s $DIR/../../clientSvn/$bigServer/tank2/src -d $DIR/../../tmpData/$bigServer/numberNoMd5/src -e -k keyj7ge3ghk -b signbvsjy78e4jvywl --encrypt --disable-compile || exit 1
#加密lua
$DIR/../compile_scripts_enter.sh $DIR/../../clientSvn/$bigServer/tank2/src $DIR/../../tmpData/$bigServer/numberNoMd5/src || exit 1

echo "结束加密lua"
date
# rsync -avz --delete $DIR/../../clientSvn/$bigServer/tank2/res/ $DIR/../../tmpData/$bigServer/numberNoMd5/res/ || exit 1
echo "开始加密图片"
date
echo "加密图片"
$DIR/../encrypt_res.sh -i $DIR/../../clientSvn/$bigServer/tank2/res/ -o $DIR/../../tmpData/$bigServer/numberNoMd5/res/ -es h98y8o9yeeqiie3t -ek zdjhgrs3sc72pll0 || exit 1
echo "结束加密图片"
date
rm -rf $DIR/../../tmpData/$bigServer/numberNoMd5/res/ccs/views || exit 1

echo "开始加密ui lua"
date
echo "编译加密ui lua"
$DIR/../compile_scripts_enter.sh $DIR/../../clientSvn/$bigServer/tank2/res/ccs/views $DIR/../../tmpData/$bigServer/numberNoMd5/res/ccs/views || exit 1
echo "结束加密ui lua"
date


echo "开始生成manifest"
date
# 生成manifest
$DIR/manifestGenDebug.sh $bigServer || exit 1
echo "结束生成manifest"
date
echo "开始处理杂项"
date
echo "文件名加md5"
cd $DIR/../../tmpData/$bigServer/numberNoMd5 || exit 1
for i1 in {"src","res"}; do
    echo $i1 || exit 1
    fileList="$(find $i1 -name "*.*")" || exit 1
    for i in $fileList; do
        if [[ -f $DIR/../../tmpData/$bigServer/numberNoMd5/$i && ! $i =~ "DS_Store" ]]; then
            fileMd5="$(md5 -q $DIR/../../tmpData/$bigServer/numberNoMd5/$i )" || exit 1
            mkdir -p "$( dirname "$DIR/../../tmpData/$bigServer/number/$i.$fileMd5" )" || exit 1
            cp $DIR/../../tmpData/$bigServer/numberNoMd5/$i $DIR/../../tmpData/$bigServer/number/$i.$fileMd5 || exit 1
        fi
    done
done
cd $DIR || exit 1
rm -rf $DIR/../../tmpData/$bigServer/numberNoMd5 || exit 1
echo "移动project.manifest到number文件夹下"
mv $DIR/../../tmpData/$bigServer/project.manifest $DIR/../../tmpData/$bigServer/number/project.manifest
echo "同步到patch svn文件夹" || exit 1
rsync -avz --delete $DIR/../../tmpData/$bigServer/ $DIR/../../clientwebPatch/$bigServer/debug/ || exit 1
echo "结束处理杂项"
date
echo "开始上传"
date
echo "上传patch svn"
cd $DIR/../../clientwebPatch/$bigServer/debug
svn stat | grep \\! | awk '{print $2}' | xargs svn remove || exit 1
svn add * --force || exit 1
svn commit -m "测试提交" || exit 1

echo "结束上传"
date