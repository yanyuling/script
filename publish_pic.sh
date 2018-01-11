#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR

source $DIR/util.sh

root_dir=$DIR/../cocosstudio/cocosstudio/
target_dir=$DIR/../res/


fileChangeMd5Dir="./fileChangeMd5"
if [[ ! -d "$fileChangeMd5Dir" ]]; then
    mkdir -p $fileChangeMd5Dir || exit 1
fi

if [[ ! -f "./fileChangeMd5/copyPlistMd5.txt" ]]; then
    touch "./fileChangeMd5/copyPlistMd5.txt" || exit 1
fi

if [[ ! -f "./fileChangeMd5/wholeListMd5_publicPic.txt" ]]; then
    touch "./fileChangeMd5/wholeListMd5_publicPic.txt" || exit 1
fi

array=("ccs/bigPic" "ccs/particle" "ccs/font" "sound" "spine")

fileCount=0
filePoint=0

function getdir(){

    for element in `ls $1`
    do
        dir_or_file=$1"/"$element

        if [[ -d $dir_or_file ]]
        then
            getdir $dir_or_file  $2"/"$element
        else
            #相对路径
            localPath=$2"/"$element

            #源文件全路径
            rootFilePath=$root_dir$localPath

            #目标目录全路径
            targetFilePath=$target_dir$localPath

            if [[ ! -d "$target_dir$2" ]]; then
                mkdir -p $target_dir$2 || exit 1
            fi

            oldMd5="$(grep $localPath ./fileChangeMd5/copyPlistMd5.txt | awk '{print $2}' )" || exit 1
            newMd5="$(md5 -q -s "$(md5 -q -s $localPath) $(md5 -q $rootFilePath)")" || exit 1
            # # # 源目录修改
            if [[ "$oldMd5"x == ""x ]]; then
                echo "md5file free, copy==="$targetFilePath

                if [[ -f "$targetFilePath" ]]; then
                    rm -f $targetFilePath || exit 1
                fi
                cp -p $rootFilePath $targetFilePath || exit 1

                echo $localPath"   $newMd5" >> ./fileChangeMd5/copyPlistMd5.txt || exit 1
            else
                if [[ "$oldMd5"x != "$newMd5"x ]]; then
                    echo "change, copy==="$targetFilePath
                    if [[ -f "$targetFilePath" ]]; then
                        rm -f $targetFilePath || exit 1
                    fi
                    cp -p $rootFilePath $targetFilePath || exit 1

                    file2="$(echo $localPath | sed 's/\//\\\//g' | sed 's/\./\\\./g')" || exit 1
                    sed -i '' "s/$file2   $oldMd5/$file2   $newMd5/g" ./fileChangeMd5/copyPlistMd5.txt || exit 1
                fi
            fi
            # filePoint=$[$filePoint+1]
            # echo -n -e "progress:$[$filePoint*100/$fileCount]%\r"
        fi
    done
}


for value in ${array[*]}; do

    allRootDir=$root_dir$value
    allTargetDir=$target_dir$value

    oldMd5="$(grep $allRootDir ./fileChangeMd5/wholeListMd5_publicPic.txt | awk '{print $2}' )" || exit 1
    newMd5=(`getDirMd5 $allRootDir`) || exit 1
    # newMd5=${newMd5Info%%|*}
    # fileCount=${newMd5Info##*|}
    # filePoint=0

    # echo "需要复制图片, 文件个数: $fileCount"
    if [[ "$oldMd5"x == ""x ]]; then
        echo $allRootDir"   $newMd5" >> ./fileChangeMd5/wholeListMd5_publicPic.txt
        getdir $allRootDir $value
    else
        if [[ "$oldMd5"x != "$newMd5"x ]]; then
           file2="$(echo $allRootDir | sed 's/\//\\\//g' | sed 's/\./\\\./g')"
           sed -i '' "s/$file2   $oldMd5/$file2   $newMd5/g" ./fileChangeMd5/wholeListMd5_publicPic.txt
           getdir $allRootDir $value
        else
           echo "$value 没改变"
        fi
    fi

done

echo
echo "执行完成"
