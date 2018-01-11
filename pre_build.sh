#!/bin/bash
#1. 什么也不传全部导出
#2. 只传1 则只导出csd

DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR

if [ $# == 0 ];then
    $DIR/csd2lua/csd2lua.sh || exit 1
    $DIR/publish_pic.sh || exit 1
    $DIR/compile_pic.sh || exit 1
    $DIR/gen_plist_cfg.sh || exit 1
    $DIR/png_compress.sh || exit 1
    $DIR/mapLuaToByte/mapLuaToByte.sh || exit 1
else
    if [ "$1" -eq 1 ]; then
        $DIR/csd2lua/csd2lua.sh || exit 1
    fi
fi

echo "执行成功"
