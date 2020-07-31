#!/bin/bash

# define Variables
imgFolder='apfsimg'
homeFolder='/Users/user'
deviceFolder="${homeFolder}/${imgFolder}"
#sharedFolder='/media/sf_data'
fsLabel='apfs-single'
#rawFile1='drive1'
imgFile='apfs.dmg'
#loopDevice1='/dev/loop1'
#loopDevice2='/dev/loop2'
#mountPath='/media/hdd'
resultJson="{}"
resultFile="${sharedFolder}/apfssrc.json"

# define functions

function get_crtime() {
    for target in "${@}"; do
        tinode=$(stat -c '%i' "${target}")
        fs=$(df  --output=source "${target}"  | tail -1)
        crtimehex=$(debugfs -R 'stat <'"${inode}"'>' "${fs}" 2>/dev/null | grep crtime:  | grep -oP '0x\w{8}')
        crtime=$(echo $(($crtimehex)))
        printf "%i" "${crtime}"
    done
}

function get_fileinfo() {
	for mypath in "${@}"; do
		filePath=${mypath/#$mountPath}
		cd "$myPath"
		name="$filePath:t"
		inode=$(stat -f %i "$name")
		fileType=$(stat -f %T "$name")
		mode=$(stat --format=%A "${mypath}")
		#tsk meldet - als r = regular File
		if [[ "$fileType" == "-" ]]
		then
			fileType="r"
			mode=$(echo "$mode" | sed 's/^./r/' )
		fi
		modified=$(stat --format=%Y "${mypath}")
		accessed=$(stat --format=%X "${mypath}")
		changed=$(stat --format=%Z "${mypath}")
		created=$(get_crtime "${mypath}")
		size=$(stat --format=%s "${mypath}")
		if [[ "$fileType" == "d" ]]
		then
			sha256=""
		else	
			sha256=$(sha256sum "${mypath}" | cut -d " " -f 1)
		fi
		resultJson=$(echo "$resultJson" | jq \
			--arg n "$name" \
			--arg fP "$filePath" \
			--arg i "$inode" \
			--arg fT "$fileType" \
			--arg m "$mode" \
			--arg s "$size" \
			--arg mo "$modified" \
			--arg ac "$accessed" \
			--arg ch "$changed" \
			--arg cr "$created" \
			--arg sh "$sha256" \
			'.files += {($n):{"filepath": $fP, "inode": $i, "file_type": $fT, "mode": $m, "size": $s, "modified": $mo, "accessed": $ac, "changed": $ch, "created": $cr, "sha256": $sh}}')

	done
}


# create mage with apfs filesystem
[[ -d "$deviceFolder" ]] && rm -r "$deviceFolder"
[[ -d "$deviceFolder" ]] || mkdir "$deviceFolder"
hdiutil create -megabytes 1000 -layout GPTSPUD -fs apfs -volname "$fsLabel" "${deviceFolder}/${imgFile}" 

# attach filesystem
sleep 2s
attachResult=hdiutil attach "${deviceFolder}/${imgFile}" 
mountPath=$(echo "$attachResult" | grep -o '/Volumes.*')
deviceFile=$(echo "$attachResult" | grep '/Volumes.*' | cut -f 1)

# partition
imageInfo=$(hdiutil imageinfo "${deviceFolder}/${imgFile}")
apfsPartNo=$(echo "$imageInfo" | sed -n '/partitions:/,/APFS:/p' | grep -o '[[:digit:]]:' | tail -1)
apfsLines=$(echo "$imageInfo" | sed -n "/${apfsPartNo}/,/APFS:/p") 
partType=$(echo "$imageInfo" | grep partition-scheme | cut -d " " -f 2)
unitSize=$(echo "$imageInfo" | grep block-size | cut -d " " -f 2)
firstUnit=$(echo "$apfsLines" | grep partition-start | grep -Eo '[[:digit:]]+')
resultJson=$(echo "$resultJson" | jq \
        --arg pT "$partType" \
        --arg uS "$unitSize" \
        --arg fU "$firstUnit" \
        ' . * {"partition": {"part_type": $pT, "unit_size": $uS, "first_unit": $fU}}')
# file system
mountResult=$(mount)
apfsResult=$(hdiutil apfs info)
devFileName=$(echo "$devFile" | cut -d "/" -f 3
fsType=$(echo "$mountResult" | grep "$deviceFile" | grep -Eo '\(.*\)' | grep -oE '\([[:alpha:]]+' | tr -d "(")
fsLabel=$(echo "$apfsResult" | grep -A 6 "\+-> Volume ${devFileName}" | grep "Name: " | grep -Eo ' [[:alpha:]]+ ' | tr -d " ")
fsId=$(echo "$apfsResult" | grep "\+-> Volume $devFileName" | cut -d " " -f 8)
resultJson=$(echo "$resultJson" | jq \
        --arg t "$fsType" \
        --arg l "$fsLabel" \
        --arg s "$fsSectorSize" \
        --arg i "$fsId" \
        ' . * {"fs": {"type": $t, "label": $l, "sector_size": $s, "id": $i}}')

# create objects in fs, record infos in json
resultJson=$(echo "$resultJson" | jq ' . + {'files':{}}')

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
 
# write json file
echo "$resultJson" > "$resultFile"

# dismount filesystem
hdiutil detach "$devFile"

exit 0
