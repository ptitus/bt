#!/bin/bash

# define Variables
imageFile='/media/sf_data/refs.vmdk'
jsonFile='/media/sf_data/refssrc.json'
resultFile='/media/sf_data/refstsk.json'
partitionSlot='001'

# define functions

function get_fileinfo() {
	if ! [[  -d "restoredir" ]] 
	then
		mkdir "restoredir"
	fi
        while IFS= read -r line; do
		if [[ ! "$line" == *'File System Metadata'* ]] 
		then
			mode=$(echo "$line" | cut -d "|" -f 4 | grep -oP '(?<=/).*')
			fileType=$(echo "$line" | cut -d "|" -f 4 | grep -oP '.{1}(?=/)')
			case "$fileType" in
				(d|r|-)
					filePath=$(echo "$line" | cut -d "|" -f 2 | grep -oP '/.*')
					if [[ "$fileType" == "-" ]]
					then
						name=$(basename -a "$filePath" | grep -oP '.*(?= \(.*\))') # ohne (deleted)
					else
						name=$(basename -a "$filePath" | tr -d " ") # ohne Leerzeichen
					fi
					#tsk for ReFS doesn't display full inode in body-file format
					inode=$(fls -p -r -o "$firstUnit" "$imageFile" | grep $name | cut -d " " -f 2 | grep -oP '.*(?=:)') 
					#inode=$(echo "$line" | cut -d "|" -f 3)
					modified=$(echo "$line" | cut -d "|" -f 9)
					accessed=$(echo "$line" | cut -d "|" -f 9)
					changed=$(echo "$line" | cut -d "|" -f 9)
					created=$(echo "$line" | cut -d "|" -f 9)
					size=$(echo "$line" | cut -d "|" -f 7)
					case "$fileType" in
						(d)
							mkdir "restoredir${filePath}"
							sha256=""
							;;
		
						(r|-)
						icat -o "$firstUnit" "$imageFile" "$inode" > "restoredir${filePath}" 
						sha256=$(sha256sum "restoredir${filePath}"| cut -d " " -f 1)
						;;
					esac					
					#if [[ "$fileType" == "d" ]]
					#then
					#	mkdir "restoredir${filePath}"
					#	sha256=""
					#else
					#	icat -o "$firstUnit" "$imageFile" "$inode" > "restoredir${filePath}" 
					#	sha256=$(sha256sum "restoredir${filePath}"| cut -d " " -f 1)
					#fi
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
					;;
				
			esac
		fi
		done < <(echo "$1")
	rm -r restoredir/*	
}

# volume system analysis
mmstatResult=$(mmstat $imageFile)
mmlsResult=$(mmls $imageFile)
partType="$mmstatResult"
unitSize=$(echo "$mmlsResult" | grep -oP '(?<=Units are in )[[:digit:]]+(?=-)')
if [[ "$partType" == 'dos' ]]; then
        partitionSlot="000:${partitionSlot}"
fi
partLine=$(echo "$mmlsResult" | grep -P "^[[:digit:]]{3}:  ${partitionSlot} " | sed -e 's/ \+/;/g')
firstUnit=$(echo "$partLine" | awk 'BEGIN { FS = ";" } ; { print $3 }' | sed 's/^0*//')
description=$(echo "$partLine" | awk 'BEGIN { FS = ";" } ; { print $6 }')
myJson=$(echo '{}' | jq \
        --arg pT "$partType" \
        --arg uS "$unitSize" \
        --arg fU "$firstUnit" \
        ' . * {"partition": {"part_type": $pT, "unit_size": $uS, "first_unit": $fU}}')

# file system analysis
fsstatResult=$(fsstat -o "$firstUnit" "$imageFile")
fsType=$(echo "$fsstatResult" | grep -oP "(?<=File System Type: ).*")
fsName=$(echo "$fsstatResult" | grep 'Volume Label:' | awk '{print $3}' | tr -d '"')
fsId=$(echo "$fsstatResult" | grep -oP "(?<=Volume Serial Number: ).*" )
myJson=$(echo "$myJson" | jq \
        --arg t "$fsType" \
	--arg n "$fsName" \
        --arg i "$fsId" \
        ' . * {"fs": {"type": $t, "name": $n, "id": $i}}' )

# files analysis
myJson=$(echo "$myJson" | jq ' . + {'files':{}}')

flsResult=$(fls -pro "$firstUnit" -m / "$imageFile")
get_fileinfo "$flsResult"

# recover file

# write json file
echo "$myJson" > "$resultFile"

exit 0
