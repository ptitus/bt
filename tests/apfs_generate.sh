#!/bin/bash

# define Variables
imgFolder='apfsimg'
homeFolder='/Users/user'
deviceFolder="${homeFolder}/${imgFolder}"
fsLabel='apfs-single'
imgFile='apfs.dmg'
resultJson="{}"
resultFile="/Users/user/apfssrc.json"

# define functions

function get_fileinfo() {
	for myPath in "${@}"; do
		filePath="${myPath/#$mountPath}"
		name=$(basename "$myPath")
		inode=$(stat -f %i "$myPath")
		fileType=$(ls -ld "$myPath" | head -c 1)
		mode=$(ls -ld "$myPath" | cut -d " " -f 1)
		#tsk meldet - als r = regular File
		if [[ "$fileType" == "-" ]]
		then
			fileType="r"
			mode=$(echo "$mode" | sed 's/^./r/')
		fi
		modified=$(stat -st %s "$myPath" | cut -d " " -f 10 | cut -d "=" -f 2)
		accessed=$(stat -st %s "$myPath" | cut -d " " -f 9 | cut -d "=" -f 2)
		changed=$(stat -st %s "$myPath" | cut -d " " -f 11 | cut -d "=" -f 2)
		created=$(stat -st %s "$myPath" | cut -d " " -f 12 | cut -d "=" -f 2)
		size=$(stat -f %z "$myPath")
		if [[ "$fileType" == "d" ]]
		then
			sha256=""
		else	
			sha256=$(shasum -a 256 "$myPath" | cut -d " " -f 1)
		fi
		resultJson=$(echo "$resultJson" | /usr/local/bin/jq \
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
attachResult=$(hdiutil attach "${deviceFolder}/${imgFile}")
mountPath=$(echo "$attachResult" | grep -o '/Volumes.*')
deviceFile=$(echo "$attachResult" | grep '/Volumes.*' | cut -d " " -f 1)

# partition
imageInfo=$(hdiutil imageinfo "${deviceFolder}/${imgFile}")
apfsPartNo=$(echo "$imageInfo" | sed -n '/partitions:/,/APFS:/p' | grep -o '[[:digit:]]:' | tail -1)
apfsLines=$(echo "$imageInfo" | sed -n "/${apfsPartNo}/,/APFS:/p") 
partType=$(echo "$imageInfo" | grep 'Primary GPT Header' | awk '{print $3}')
unitSize=$(echo "$imageInfo" | grep block-size | cut -d " " -f 2)
firstUnit=$(echo "$apfsLines" | grep partition-start | grep -Eo '[[:digit:]]+')
resultJson=$(echo "$resultJson" | /usr/local/bin/jq \
        --arg pT "$partType" \
        --arg uS "$unitSize" \
        --arg fU "$firstUnit" \
        ' . * {"partition": {"part_type": $pT, "unit_size": $uS, "first_unit": $fU}}')
# file system
mountResult=$(mount)
apfsResult=$(diskutil apfs list)
devFileName=$(echo "$deviceFile" | cut -d "/" -f 3)
fsType=$(echo "$mountResult" | grep "$deviceFile" | grep -Eo '\(.*\)' | grep -oE '\([[:alpha:]]+' | tr -d "(")
fsLabel=$(echo "$apfsResult" | grep -A 6 "\+-> Volume $devFileName" | grep "Name: " | awk '{print $2}')
fsId=$(echo "$apfsResult" | grep "\+-> Volume $devFileName" | awk '{print $4}')
resultJson=$(echo "$resultJson" | /usr/local/bin/jq \
        --arg t "$fsType" \
        --arg l "$fsLabel" \
        --arg i "$fsId" \
        ' . * {"fs": {"type": $t, "label": $l, "id": $i}}')

# create objects in fs, record infos in json
resultJson=$(echo "$resultJson" | /usr/local/bin/jq ' . + {'files':{}}')

touch "${mountPath}/file.0"
get_fileinfo "${mountPath}/file.0"

cat < /dev/urandom | head -c 10000000 > "${mountPath}/file.binary"
get_fileinfo "${mountPath}/file.binary" 

base64 /dev/urandom | head -c 10000000 > "${mountPath}/file.txt"
get_fileinfo "${mountPath}/file.txt"

base64 /dev/urandom | head -c 10000000 > "${mountPath}/delfile.txt" 
get_fileinfo "${mountPath}/delfile.txt"
rm "${mountPath}/delfile.txt"

mkdir ${mountPath}/subdir 
get_fileinfo "${mountPath}/subdir"

base64 /dev/urandom | head -c 10000000 > "${mountPath}/subdir/file2.txt"
get_fileinfo "${mountPath}/subdir/file2.txt"
 
# write json file
echo "$resultJson" > "$resultFile"

# dismount filesystem
hdiutil detach "$deviceFile"

exit 0
