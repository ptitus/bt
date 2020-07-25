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
		myJson=$(echo "$myJson" | jq \
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

# create partition 
parted -s $myDevice mklabel gpt
parted -s -a optimal $myDevice mkpart primary ext4 0% 100%

# create filesystem
sleep 2s
mkfs -t ext4 "$myPartition" > /dev/null 2>&1

# mount filesystem
[[ -d "$mountPath" ]] || mkdir $mountPath 
mount $myPartition $mountPath 

# create json files
#  partition information
fdiskResult=$(fdisk -l ${myDevice})
partType=$(echo $fdiskResult | grep -oP '(?<=Disklabel type: )[[:alpha:]]{3}')
unitSize=$(echo $fdiskResult | grep -oP '(?<= = )[[:digit:]]{1,10}')
firstUnit=$(echo "$fdiskResult" | grep -oP '^\/.*' | grep -oP '(?<= )[[:digit:]]+(?=[[:blank:]]+[[:digit:]]+[[:blank:]]+[[:digit:]]+[[:blank:]]+[[:digit:]]+)')
myJson=$(echo '{}' | jq \
	--arg pT "$partType" \
	--arg uS "$unitSize" \
	--arg fU "$firstUnit" \
	' . * {"partition": {"part_type": $pT, "unit_size": $uS, "first_unit": $fU}}')

# file system 
fileResult=$(file -sL $myPartition)
fsType=$(echo $fileResult | grep -oP '[[:word:]]*(?= filesystem data)'| tr '[:upper:]' '[:lower:]')
fsName=""
fsId=$(echo $fileResult | grep -oP '(?<=UUID\=)([[:word:]]|-)*')
fsSourceOs=$(echo $fileResult | grep -oP "(?<=${1}: )[[:word:]]*")
features=$(echo $fileResult | grep -oP "\(([[:word:]]| )*\)" | tr '(' '"' | tr ')' '"')
myJson=$(echo "$myJson" | jq \
        --arg t "$fsType" \
        --arg n "$fsName" \
        --arg i "$fsId" \
        --arg o "$fsSourceOs" \
        ' . * {"fs": {"type": $t, "name": $n, "id": $i, "os": $o, features:[]}}' )

#fill array with features
while IFS= read -r line
do
	feature=$(echo "$line" | tr -d '"')
	myJson=$(echo "$myJson" | jq --arg f "$feature" '.fs.features += [$f]')
done < <(echo "$features")

# create objects in fs, record infos in json
myJson=$(echo "$myJson" | jq ' . + {'files':{}}')

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
echo "$myJson" > "$resultFile"

# dismount filesystem
umount $mountPath

exit 0
