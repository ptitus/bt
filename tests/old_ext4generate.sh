#!/bin/bash

# define Variables
myDevice='/dev/sdb'
myPartition='/dev/sdb1'
mountPath='/media/hdd'
resultFile='/media/sf_data/ext4src.json'

# define functions

function get_crtime() {
    for target in "${@}"; do
        inode=$(stat -c '%i' "${target}")
        fs=$(df  --output=source "${target}"  | tail -1)
        crtimehex=$(debugfs -R 'stat <'"${inode}"'>' "${fs}" 2>/dev/null | grep crtime:  | grep -oP '0x\w{8}')
        crtime=$(echo $(($crtimehex)))
        printf "%i" "${crtime}"
    done
}

function get_fileinfo() {
	wc -l "${@}"
	for mypath in "${@}"; do
		name=$(stat --format=%n "${mypath}" | egrep -o [^/]+$)
		inode=$(stat --format=%i "${mypath}")
		fileType=$(stat --format=%A "${mypath}" | cut -c 1 )
		mode=$(stat --format=%A "${mypath}")
		modified=$(stat --format=%Y "${mypath}")
		accessed=$(stat --format=%X "${mypath}")
		changed=$(stat --format=%Z "${mypath}")
		created=$(get_crtime "${mypath}")
		size=$(stat --format=%s "${mypath}")
		if [[ "$fileType"=="d"   ]]
		then
			sha256=""
		else	
			sha256=$(sha256sum "${mypath}" | cut -d " " -f 1)
		fi
		myJson=$(echo "$myJson" |jshon \
			-n {} \
	 		        -s "$filePath" -i 'file_path' \
				-s "$inode" -i 'inode' \
			-s "$fileType" -i 'file_type' \
			-s "$mode" -i 'mode' \
			-s "$size" -i 'size' \
			-s "$modified" -i 'modified' \
			-s "$accessed" -i 'accessed' \
			-s "$changed" -i 'changed' \
			-s "$created" -i 'created' \
			-s "$sha256" -i 'sha256' \
	                -i "$name" \
        	-i  'files' )

#		cat <<myEOF >> $myFile
#
#		"file_${name}":{	
#			"file_path":"$mypath",
#			"name":"$name",
#			"inode":"$inode",
#			"file_type":"$fileType",
#			"mode":"$mode",
#			"size":"$size",
#			"modified":"$modified",
#			"accessed":"$accessed",
#			"changed":"$changed",
#			"created":"$created",
#			"size":"$size",
#			"sha256":"$sha256"
#		},
#myEOF
	done
}

# create partition 
parted -s $myDevice mklabel gpt
parted -s -a optimal $myDevice mkpart primary ext4 0% 100%

# create filesystem
sleep 2s
mkfs -t ext4 "$myPartition"

# mount filesystem
[[ -d "$mountPath" ]] || mkdir $mountPath 
mount $myPartition $mountPath 

# create json files
#  partition information
fdiskResult=$(fdisk -l ${myDevice})
partType=$(echo $fdiskResult | grep -oP '(?<=Disklabel type: )[[:alpha:]]{3}')
unitSize=$(echo $fdiskResult | grep -oP '(?<= = )[[:digit:]]{1,10}')
firstUnit=$(echo "$fdiskResult" | grep -oP '^\/.*' | grep -oP '(?<= )[[:digit:]]+(?=[[:blank:]]+[[:digit:]]+[[:blank:]]+[[:digit:]]+[[:blank:]]+[[:digit:]]+)')
myJson=$(jshon -Q -n {} \
	-n {} \
       		-s "$partType" -i 'part_type' \
		-n "$unitSize" -i 'unit_size' \
		-n "$firstUnit" -i 'first_unit' \
		-i 'partition')
#cat <<myEOF > $myFile
#{
#	"partition": {
#		"part_type":"$partType",
#		"unit_size":"$unitSize",
#		"first_unit":"$firstUnit"
#	},
#myEOF

# file system 
fileResult=$(file -sL $myPartition)
fsType=$(echo $fileResult | grep -oP '[[:word:]]*(?= filesystem data)')
uuid=$(echo $fileResult | grep -oP '(?<=UUID\=)[[:word:]]*')
echo "$uuid"
os=$(echo $fileResult | grep -oP "(?<=${1}: )[[:word:]]*")
#features=$(echo $fileResult | grep -oP "\(([[:word:]]| )*\)" | tr '(' '"' | tr ')' '"' | awk '{print}' ORS=', ' | grep -oP '.+(?=\,)')
features=$(echo $fileResult | grep -oP "\(([[:word:]]| )*\)" | tr '(' '"' | tr ')' '"')
myJson=$(echo "$myJson" |jshon \
	-n {} \
		-s "$fsType" -i 'fs_type' \
		-s "$uuid" -i 'uuid' \
		-s "$os" -i 'os' \
		-n [] \
		$(echo "$features" | while read feature; do echo "-s $(echo ${feature}) -i append " ; done) 
		-i 'features' \
	-i  'fs' )
#cat <<myEOF >> $myFile
#	"fs": {
#        	"fs_type":"$fsType",
#		"uuid":"$uuid",
#	        "os":"$os",
#	        "features":[$features]
#	},
#myEOF

# create objects in fs, record infos
myJson=$(echo "$myJson" |jshon 	\
	-n [] -i 'files')
#	cat <<myEOF >> $myFile
#	"files": {
#myEOF


touch ${mountPath}/file.0
get_fileinfo ${mountPath}/file.0 

cat < /dev/urandom | head -c 10000000 > ${mountPath}/file.binary 
get_fileinfo  ${mountPath}/file.binary 

base64 /dev/urandom | head -c 10000000 > ${mountPath}/file.txt 
get_fileinfo ${mountPath}/file.txt

base64 /dev/urandom | head -c 10000000 > ${mountPath}/delfile.txt 
get_fileinfo  ${mountPath}/delfile.txt
rm ${mountPath}/delfile.txt

mkdir ${mountPath}/subdir 
get_fileinfo  ${mountPath}/subdir

base64 /dev/urandom | head -c 10000000 > ${mountPath}/subdir/file2.txt
get_fileinfo  ${mountPath}/subdir/file2.txt
 
# write file
echo "$myJson" > $resultFile

#cat <<myEOF >> $myFile
#	}
#}
#myEOF

# dismount filesystem
umount $mountPath

exit 0
