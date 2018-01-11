#!/bin/bash
#图片密码 --content-protection "a6bada9636ada74895fa5197eeebd45a"
DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR

# 如果不存在res/ccs，就创建
if [[ ! -d ../res/ccs ]]; then
	mkdir ../res/ccs || exit 1
fi
if [[ ! -d ../res/ccs/plist ]]; then
	mkdir ../res/ccs/plist || exit 1
fi

if [[ ! -d "./fileChangeMd5" ]]; then
	mkdir "./fileChangeMd5" || exit 1
fi
if [[ ! -f "./fileChangeMd5/fileMd5.txt" ]]; then
	touch "./fileChangeMd5/fileMd5.txt" || exit 1
fi

rootPath="$DIR/../cocosstudio/cocosstudio/ccs/"
# rgba444配置目录
rgba4444=("uiPic/officerRecruitB")


for f1 in `ls $rootPath`; do
	if [[ "$f1"x = "particle"x || "$f1"x = "plist"x || "$f1"x = "views"x || "$f1"x = "bigPic"x  || "$f1"x = "font"x  ]]; then
		echo "不处理"$f1
		continue
	fi
	echo $f1
	for f2 in `ls $DIR/../cocosstudio/cocosstudio/ccs/$f1/`; do
		# 源图文件夹
		srcAbsFilePath="$DIR/../cocosstudio/cocosstudio/ccs/$f1/$f2"
		# plist文件
		plistAbsFilePath="$DIR/../res/ccs/plist/$f1/$f2.{n}.plist"
		# pvr.ccz文件
#		if [[ "$f1"x = "animation"x ]]; then
			pvrAbsFilePath="$DIR/../res/ccs/plist/$f1/$f2.{n}.png"
#		else
#			pvrAbsFilePath="$DIR/../res/ccs/plist/$f1/$f2.{n}.pvr.ccz"
#		fi

		if [ "`ls -A $srcAbsFilePath`" = "" ]; then
			# echo -e "^[[1;34m 空文件夹$srcAbsFilePath,请抓紧删掉 ^[[0m"
			echo -e '\033[41;33;1m ↓↓↓↓↓↓↓空文件夹,请抓紧删掉↓↓↓↓↓↓↓ \033[0m'
			echo $srcAbsFilePath
			echo -e '\033[41;33;1m ↑↑↑↑↑↑↑空文件夹,请抓紧删掉↑↑↑↑↑↑↑ \033[0m'
			oldMd5=""
			newMd5=""
		else
			oldMd5="$(grep "$srcAbsFilePath	" ./fileChangeMd5/fileMd5.txt | awk '{print $2}' )" || exit 1
			newMd5="$(md5 -qs "$(md5 -q $(find $srcAbsFilePath -name "*.png" -o -name "*.jpg"))")" || exit 1
		fi

		if [[ "$oldMd5"x != "$newMd5"x ]]; then
			echo "srcAbsFilePath==="$srcAbsFilePath


                flag=0
                for i in ${rgba4444[@]}; do
                    if [ "$srcAbsFilePath"x = "$rootPath$i"x ]; then
                        flag=1
                        break
                    fi
                done

            	if [ "$flag" -eq 1 ]; then
              		TexturePacker $srcAbsFilePath --data $plistAbsFilePath --sheet $pvrAbsFilePath --replace '^'="ccs/$f1/$f2/" --opt RGBA4444 --dither-fs-alpha --allow-free-size --multipack --size-constraints AnySize || exit 1
            	else
              		TexturePacker $srcAbsFilePath --data $plistAbsFilePath --sheet $pvrAbsFilePath --replace '^'="ccs/$f1/$f2/" --allow-free-size --multipack --size-constraints AnySize || exit 1
            	fi


			# 合图
			# TexturePacker $srcAbsFilePath --data $plistAbsFilePath --sheet $pvrAbsFilePath --replace '^'="ccs/$f1/$f2/" --allow-free-size || exit 1
			# $DIR/mali/bin/etcpack $pvrAbsFilePath "$DIR/../res/ccs/plist/$f1/" -c etc1 -as
			# rm "$pvrAbsFilePath"
			# mv $DIR/../res/ccs/plist/$f1/$f2"_alpha.pkm" $DIR/../res/ccs/plist/$f1/$f2".pkm@alpha"
			# TexturePacker $srcAbsFilePath --data $plistAbsFilePath --sheet $pvrAbsFilePath --replace '^'="ccs/$f1/$f2/" --allow-free-size --multipack  || exit 1

#			if [[ "$f1"x = "animation"x ]]; then
				# TexturePacker $srcAbsFilePath --data $plistAbsFilePath --sheet $pvrAbsFilePath --replace '^'="ccs/$f1/$f2/" --allow-free-size --multipack || exit 1
#			elif [[ "$f2"x = "mapTile"x ]]; then
#				TexturePacker $srcAbsFilePath --data $plistAbsFilePath --sheet $pvrAbsFilePath --replace '^'="ccs/$f1/$f2/" --allow-free-size --content-protection "a6bada9636ada74895fa5197eeebd45a" || exit 1
#			else
#				TexturePacker $srcAbsFilePath --data $plistAbsFilePath --sheet $pvrAbsFilePath --replace '^'="ccs/$f1/$f2/" --allow-free-size --multipack --content-protection "a6bada9636ada74895fa5197eeebd45a" || exit 1
#			fi
			# TexturePacker $srcAbsFilePath --data $plistAbsFilePath --sheet $pvrAbsFilePath --replace '^'="ccs/$f1/$f2/" --max-size 1024 --multipack --content-protection "a6bada9636ada74895fa5197eeebd45a" || exit 1
	        # 删除smartupdate
	        for (( i = 0; i < 10; i++ )); do
	        	if [[ -f $DIR/../res/ccs/plist/$f1/$f2.$i.plist ]]; then
			        sed -i '' "/smartupdate/d"  $DIR/../res/ccs/plist/$f1/$f2.$i.plist || exit 1
			        sed -i '' "/TexturePacker:SmartUpdate/d"  $DIR/../res/ccs/plist/$f1/$f2.$i.plist || exit 1
		        fi
	        done
	        # sed -i '' "s/>$f2.png</>$f2.pkm</g"  $plistAbsFilePath || exit 1
	        if [[ "$oldMd5"x == ""x ]]; then
				echo "$srcAbsFilePath	$newMd5" >> ./fileChangeMd5/fileMd5.txt || exit 1
			else
				file2="$(echo $srcAbsFilePath | sed 's/\//\\\//g' | sed 's/\./\\\./g')"
				sed -i '' "s/$file2	.*/$file2	$newMd5/g" ./fileChangeMd5/fileMd5.txt || exit 1
			fi
	    fi
	done
done
