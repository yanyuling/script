#!/bin/bash
DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR

cd $DIR/../res
echo -e "--[[\n游戏中所有的合图plist\n本文件由gen_plist_cfg.sh生成，请勿手动修改本文件\n本文件受svn管理，如提示有变动，则需要提交。\n]]\nreturn {\n`find ./ccs/plist -name "*.plist" | sed 's/.\/ccs/"ccs/g' | sed 's/$/",/g'`\n}" > $DIR/../src/app/config/plistCfg.lua

