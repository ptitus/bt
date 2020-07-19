#!/bin/bash

# define Variables
imgFolder='zfsimg'
homeFolder='/home/user'
deviceFolder="${homeFolder}/${imgFolder}"
sharedFolder='/media/sf_data'
fsLabel='zfs-2dev-mirror'
rawFile1='drive1'
rawFile2='drive2'
loopDevice1='/dev/loop1'
loopDevice2='/dev/loop2'
mountPath='/media/hdd'
resultJson="{}"
resultFile="${sharedFolder}/zfssrc.json"

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
	for mypath in "${@}"; do
		filePath=${mypath/#$mountPath}
		name=$(stat --format=%n "${mypath}" | egrep -o [^/]+$ | tr -d " ") # ohne Leerzeichen
		inode=$(stat --format=%i "${mypath}")
		fileType=$(stat --format=%A "${mypath}" | cut -c 1 )
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
			'.files += [{($n):{"filepath": $fP, "inode": $i, "file_type": $fT, "mode": $m, "size": $s, "modified": $mo, "accessed": $ac, "changed": $ch, "created": $cr, "sha256": $sh}}]')

	done
}


# creat device files
[[ -d "$deviceFolder" ]] && rm -r "$deviceFolder"
[[ -d "$deviceFolder" ]] || mkdir "$deviceFolder"

dd if=/dev/zero of="$deviceFolder"/"$rawFile1" count=19531250 2> /dev/null
dd if=/dev/zero of="$deviceFolder"/"$rawFile2" count=19531250 2> /dev/null

# create loop Devices
losetup -D
losetup "$loopDevice1" "$deviceFolder"/"$rawFile1"
losetup "$loopDevice2" "$deviceFolder"/"$rawFile2"


# create filesystem
sleep 2s
zpool create "$fsLabel" mirror "$loopDevice1" "$loopDevice2" -m "$mountPath"


# create json files
 
# file system
mountResult=$(mount | grep "$mountPath")
zpoolGetResult=$(zpool get all "$fsLabel")
zpoolListResult=$(zpool list -v)
fsType=$(echo "$mountResult" | grep -oP '(?<=type )[[:word:]]+')
fsLabel=$(echo "$mountResult" | cut -d " " -f 1)
fsId=$(echo "$zpoolGetResult" | grep 'guid' | sed -e 's/ \+/ /g' | cut -d " " -f 3)
fsDevCount=$(echo "$zpoolListResult" | grep -oP '(?<=^    )[[:word:]]+' | wc -l)
resultJson=$(echo "$resultJson" | jq \
        --arg t "$fsType" \
        --arg l "$fsLabel" \
        --arg s "$fsSectorSize" \
        --arg i "$fsId" \
        --arg c "$fsDevCount" \
        ' . * {"fs": {"type": $t, "label": $l, "sector_size": $s, "id": $i, "device_count": $c}}')

# create objects in fs, record infos in json
resultJson=$(echo "$resultJson" | jq ' . + {'files':[]}')

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
zpool export "$fsLabel"
losetup -D

# move evidencefiles to shared dir
[[ -d "$sharedFolder/$imgFolder" ]] && rm -r "$sharedFolder/$imgFolder"
mv "$deviceFolder" "$sharedFolder"

exit 0
