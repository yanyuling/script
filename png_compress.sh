#!/bin/bash
#author:hz
#将美术资源目录的png文件压缩后到程序资源目录


# if [[ ! -f "/usr/local/bin/libpng16-config" || ! -f "/usr/local/bin/libpng-config" || ! -f "/usr/local/bin/pngquant" ]]; then
#     echo
#     echo "error : 检测到没有安装压缩图片所使用的库,请到 [tank2/script/tools/批量压缩png所需库/] 目录下安装，安装方法请参照readMe"
#     echo
#     exit
# fi

basepath=$(cd `dirname $0`; pwd)
systemTime="$(date +%Y-%m-%d-%H.%M.%S)"
root_dir=$basepath"/../res"

cd $basepath

fileList="$(find $root_dir -name "*.png")"
#syncFileList="$(find $target_DIR -name "*.png")"

tempSuffix="__TempFile"
fileChangeMd5Dir="./fileChangeMd5"
if [[ ! -d "$fileChangeMd5Dir" ]]; then
    mkdir -p $fileChangeMd5Dir
fi

if [[ ! -f "./fileChangeMd5/compressPngMd5.txt" ]]; then
    touch "./fileChangeMd5/compressPngMd5.txt"
fi

fileCount=0
filePoint=0
for i in ${fileList[@]}; do
    fileCount=$[$fileCount+1]
done





# 不压缩配置目录
noCompressDirectoryList=("/ccs/views" "/ccs/font")

# 不压缩配置文件
noCompressList=("/ccs/plist/animation/mapAni.0.png" "/ccs/plist/uiPic/noCompress.0.png" "/ccs/plist/uiPic/comm_scale9.0.png" "/ccs/plist/uiPic/comm_bg.0.png" "/ccs/plist/uiPic/comm_btn.0.png" "/ccs/plist/uiPic/comm_icon.0.png" "/ccs/plist/uiPic/comm_ui.0.png" "/ccs/plist/uiPic/bassisInfo.0.png" "/ccs/plist/uiPic/mapTop.0.png" "/ccs/bigPic/lead/animationPlaneBg.png" "/ccs/bigPic/lead/animationTankBg.png")





# 重新刷新总个数，去除跳过的目录文件数量
for i in ${noCompressDirectoryList[@]}; do
    fileList1="$(find $root_dir$i -name "*.png")"
    for ii in ${fileList1[@]}; do
        fileCount=$[$fileCount-1]
    done
done

# 重新刷新总个数，去除跳过的件数量
for i in ${noCompressList[@]}; do
    fileCount=$[$fileCount-1]
done


#syncFileCount=0
#syncPoint=0
#for i in ${syncFileList[@]}; do
#    syncFileCount=$[$syncFileCount+1]
#done

# 检查同步
#function checkSync(){
#    for element in `ls $1`
#    do
#        dir_or_file=$1"/"$element
#        if [ -d $dir_or_file ]
#        then
#            checkSync $dir_or_file $2"/"$element
#        else
#            _fileType=${dir_or_file:0-3:3}
#            if [ "$_fileType"x == "png"x ]; then
#                # 源路径
#                rootPathFile=$root_dir$2"/"$element
#                if [ ! -f "$rootPathFile" ]; then
#                    rm -f $dir_or_file
#                    if [[ ! -f "./fileChangeMd5/pngFileSyncDeleteLog($systemTime).txt" ]]; then
#                        touch "./fileChangeMd5/pngFileSyncDeleteLog($systemTime).txt"
#                    fi
#                    echo "同步发现[$dir_or_file]不存在于源目录,删除了" >> ./fileChangeMd5/pngFileSyncDeleteLog"("$systemTime")".txt
#                fi
#                syncPoint=$[$syncPoint+1]
#                printf "progress:%d%%\r" $[$syncPoint*100/$syncFileCount]
#            fi
#        fi
#    done
#}

function getdir(){
    for element in `ls $1`
    do
        dir_or_file=$1"/"$element

        if [[ -d $dir_or_file ]]
        then
            #相对目录
            localDir=$2"/"$element
            noCompressFlag=1
            for i in ${noCompressDirectoryList[@]}; do
                if [ "$localDir"x = "$i"x ]; then
                    noCompressFlag=0
                    break
                fi
            done

            if [ "$noCompressFlag" -eq 1 ]; then
                getdir $dir_or_file $2"/"$element
            fi
       else
           _fileType=${dir_or_file:0-3:3}
           if [[ "$_fileType"x == "png"x ]]; then
               #相对路径
               localPath=$2"/"$element
               #跳过不压缩的文件
               noCompressPngFlag=1
              for i in ${noCompressList[@]}; do
                  if [ "$localPath"x = "$i"x ]; then
                      noCompressPngFlag=0
                      echo "no compress file localPath="$localPath
                      break
                  fi
              done

              if [ "$noCompressPngFlag" -eq 1 ]; then
                  oldMd5="$(grep $localPath ./fileChangeMd5/compressPngMd5.txt | awk '{print $2}' )"
                   # # # 源目录修改
                   if [[ "$oldMd5"x == ""x ]]; then
                       echo "free compress fileName="$dir_or_file
                       $basepath/tools/pngquant2.9.0/pngquant -s 1 -o $dir_or_file$tempSuffix $dir_or_file
                       if [[ -f "$dir_or_file" ]]; then
                           rm -f $dir_or_file
                           mv $dir_or_file$tempSuffix $dir_or_file
                       fi
                       newMd5="$(md5 -q -s "$(md5 -q -s $localPath) $(md5 -q $dir_or_file)")"
                       echo $localPath"   $newMd5" >> ./fileChangeMd5/compressPngMd5.txt
                   else
                       newMd5="$(md5 -q -s "$(md5 -q -s $localPath) $(md5 -q $dir_or_file)")"
                       if [[ "$oldMd5"x != "$newMd5"x ]]; then
                           echo "change compress fileName="$dir_or_file
                           $basepath/tools/pngquant2.9.0/pngquant -s 1 -o $dir_or_file$tempSuffix $dir_or_file
                           if [[ -f "$dir_or_file" ]]; then
                               rm -f $dir_or_file
                               mv $dir_or_file$tempSuffix $dir_or_file
                           fi
                           newMd5="$(md5 -q -s "$(md5 -q -s $localPath) $(md5 -q $dir_or_file)")"
                           file2="$(echo $localPath | sed 's/\//\\\//g' | sed 's/\./\\\./g')"
                           sed -i '' "s/$file2   $oldMd5/$file2   $newMd5/g" ./fileChangeMd5/compressPngMd5.txt
                       fi
                  fi
                  filePoint=$[$filePoint+1]
                  echo -n -e "progress:$[$filePoint*100/$fileCount]%\r"
              fi
           fi
        fi
    done
}

#echo "开始检查同步, 文件个数: $syncFileCount"
#checkSync $target_DIR ""
#echo
#echo "同步完成"
echo "压缩png, 文件个数: $fileCount"
getdir $root_dir "" ""
echo
echo "执行完成"
