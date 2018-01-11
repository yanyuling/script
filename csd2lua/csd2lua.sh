#!/bin/bash

#转换csd到lua

DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR

fileList="$(find ../../cocosstudio/cocosstudio/ccs/views -name "*.csd")"
# echo $fileList
if [[ ! -d "../fileChangeMd5" ]]; then
	mkdir "../fileChangeMd5"
fi
if [[ ! -f "../fileChangeMd5/fileMd5.txt" ]]; then
	touch "../fileChangeMd5/fileMd5.txt"
fi
fileCount=0
for i in ${fileList[@]}; do
	fileCount=$[$fileCount+1]
done
echo "文件个数：$fileCount"

filePoint=0
for i in ${fileList[@]}; do
	oldMd5="$(grep "$DIR/$i" ../fileChangeMd5/fileMd5.txt | awk '{print $2}' )"
	newMd5="$(md5 -q $DIR/$i )"
	if [[ "$oldMd5"x != "$newMd5"x ]]; then
		resPath=${i/cocosstudio\/cocosstudio/res}
		resPath=${resPath%/*}
		if [[ ! -d $resPath ]]; then
			echo "mkdir -p $resPath"
			mkdir -p $resPath
		fi
		echo "转换 $DIR/$i $resPath"
		lua csd2luaEnter.lua $DIR/$i
		if [ ! $? -eq 0 ];then
			echo "导出lua出错$i"
			exit 1
		fi

		if [[ "$oldMd5"x == ""x ]]; then
			echo "$DIR/$i	$newMd5" >> ../fileChangeMd5/fileMd5.txt
		else
			file2="$(echo $DIR/$i | sed 's/\//\\\//g' | sed 's/\./\\\./g')"
			sed -i '' "s/$file2	.*/$file2	$newMd5/g" ../fileChangeMd5/fileMd5.txt
		fi

	fi
	filePoint=$[$filePoint+1]
	printf "progress:%d%%\r" $[$filePoint*100/$fileCount]
done
echo
echo "处理完成"