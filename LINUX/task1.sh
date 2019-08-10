#!/bin/bash
function usage
{
    echo "picBatch IMproved 1.0 (2018 Martch 28)"
    echo "-------------------------------------------------------------------------------------------------------------------------------------------------"
	echo "Notice：before using this tool, please install ImageMagick first."
	echo "usage: picBatch.sh [Arguments]"
    echo ""
    echo "[Arguments]:"
	#路径
    echo "  -f,   <directory>     The filename or directory"
	#图片压缩
    echo "  -i,   <percent>                Image compression(jpeg)"
    #压缩分辨率
	echo "  -C,   <percent>                Compression of the resolution while maintaining the original aspect ratio(jpeg/png/svg)"
    #图片转码
	echo "  -c,                            Change image format to jpg(png/svg)"
    #添加水印
	echo "  -w,   <text>                   Add a custom text watermark"
	#重命名
    echo "  -s,   <pro_rename>             Add pro_name"
    echo "  -p,   <pre_rename>             Add pre_name"
	#打印帮助信息
    echo "  -h,                            Print Help(this message)"
}



#支持对jpeg格式图片进行图片质量压缩
function compress_quality
{
	filelist=`ls $2`
	for fileName in $filelist
	do 
    case $(file $2/$fileName) in
        *jpeg*)
                $(convert $2/$fileName -quality $1 "$2/compress_quality_"$fileName)
                ;;
        *JPEG*)
                $(convert $2/$fileName -quality $1 "$2/compress_quality_"$fileName)
                ;;
	esac
	done
    echo "Quality compress finished!"       
}

#支持对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率
function compress_resolution
{
	filelist=`ls $2`
	for fileName in $filelist
	do 
    case $(file $2/$fileName) in
        *jpeg*)
                $(convert $2/$fileName -resize $1%x$1% "$2/compress_resolution_"$fileName)
                ;;
        *svg*)
                $(convert $2/$fileName -resize $1%x$1% "$2/compress_resolution_"$fileName)
                ;;
		*png*)
                $(convert $2/$fileName -resize $1%x$1% "$2/compress_resolution_"$fileName)
                ;;				
	esac
	done
    echo "Resolution compress finished!"        
}


#支持对图片批量添加自定义文本水印
function add_watermark
{ 
	filelist=`ls $2`
	for fileName in $filelist
	do 
    case $(file $2/$fileName) in
        *jpeg*)
                $(convert -size 140x80 xc:none -fill grey \
			-gravity NorthWest -draw "text 10,10 $1" \
			-gravity SouthEast -draw "text 5,15 $1" \
			miff:- |\
			composite -tile - $2/$fileName  $2/watermark_$fileName)
                ;;
        *svg*)
                $(convert -size 140x80 xc:none -fill grey \
			-gravity NorthWest -draw "text 10,10 $1" \
			-gravity SouthEast -draw "text 5,15 $1" \
			miff:- |\
			composite -tile - $2/$fileName  $2/watermark_$fileName)
                ;;
		*png*)
                $(convert -size 140x80 xc:none -fill grey \
			-gravity NorthWest -draw "text 10,10 $1" \
			-gravity SouthEast -draw "text 5,15 $1" \
			miff:- |\
			composite -tile - $2/$fileName  $2/watermark_$fileName)
                ;;	
		*bmp*)
                $(convert -size 140x80 xc:none -fill grey \
			-gravity NorthWest -draw "text 10,10 $1" \
			-gravity SouthEast -draw "text 5,15 $1" \
			miff:- |\
			composite -tile - $2/$fileName  $2/watermark_$fileName)
                ;;	
	esac
	done
    
    echo "Add watermark finished!"
}

#支持批量重命名（统一添加文件名前缀或后缀，不影响原始文件扩展名）
function pre_rename
{
    for file in `ls $1`
        do
            name=${file%.*}
            mv ${1}${file} ${1}${2}${name}.${file##*.}
    done
    
    echo " Pre rename finished!"
}

function pro_rename
{
    for file in `ls $1`
        do
            name=${file%.*}
            mv ${1}${file} ${1}${name}${2}.${file##*.}
    done
    
    echo " Pro rename finished!"

}

#支持将png/svg图片统一转换为jpg格式图片
function change_format
{
    filelist=`ls $1`
	for fileName in $filelist
	do 
    case $(file $1/$fileName) in
        *svg*)
		FILE=$fileName
                $(convert $1/$fileName $1/change_format_${FILE##*/}.jpg)
                ;;
		*png*)
		FILE=$fileName
                $(convert $1/$fileName $1/change_format_${FILE##*/}.jpg)
                ;;				
	esac
	done
    echo "Format change finished!"
}

filename=`pwd`
while getopts 'f:s:p:w:C:i:ch' OPT; do
	case $OPT in
		h)
			usage;;
		f)
			filepath="$OPTARG";;
		s)
			is_pro_rename=1
			newName=$OPTARG;;
		p)
			is_pre_rename=1
			newName=$OPTARG;;
		c)
			is_change_format=1;;
		w)
			is_add_watermark=1
			watermark=$OPTARG;;
		i)
			is_compression=1
			quality=$OPTARG;;
		C)
			is_compression_resolution=1
			compressRatio=$OPTARG;;
	esac
done


if [[ $is_compression && $quality && $filepath ]]
then
	compress_quality $quality $filepath
fi
if [[ $is_compression_resolution &&  $compressRatio && $filepath ]]
then
	compress_resolution $compressRatio $filepath
fi
if [[ $is_add_watermark && $filepath && $watermark ]]
then
	add_watermark $watermark $filepath 
fi
if [[ $is_pre_rename && $filepath && $newName ]]
then
	pre_rename $filepath $newName
fi
	
if [[ $is_pro_rename && $filepath && $newName ]]
then
	pro_rename $filepath $newName
fi
if [[ $is_change_format && $filepath ]]
then
	change_format $filepath
fi


