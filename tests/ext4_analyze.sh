#!/bin/bash

# define Variables
imageFile='/media/sf_data/ext4.vmdk'
jsonFile='/media/sf_data/ext4src.json'
resultFile='/media/sf_data/ext4tsk.json'
partitionSlot='000'

# define functions

function get_fileinfo() {
	if ! [[  -d "restoredir" ]] 
	then
		mkdir "restoredir"
	fi
        for line in "${@}"; do
		mode=$(echo "$line" | cut -d "|" -f 4 | grep -oP '(?<=/).*')
		echo "$mode"
		fileType=$(echo "$line" | cut -d "|" -f 4 | grep -oP '.{1}(?=/)')
		case "$fileType" in
			(d|r)
				filePath=$(echo "$line" | cut -d "|" -f 2 | grep -oP '/.*')
		                name=$(basename -a "$filePath")
		       		inode=$(echo "$line" | cut -d "|" -f 3)
				echo "$inode"
	                	modified=$(echo "$line" | cut -d "|" -f 9)
		                accessed==$(echo "$line" | cut -d "|" -f 9)
        		        changed==$(echo "$line" | cut -d "|" -f 9)
		       		created==$(echo "$line" | cut -d "|" -f 9)
	        	        size=$(echo "$line" | cut -d "|" -f 7)
				if [[ "$fileType"=="d" ]]
				then
					mkdir "restoredir${filePath}"
					sha256=""
				else
					icat -o "$firstUnit" "$imageFile" "$inode" > "restoredir${filePath}" 
					sha256=$(sha256sum "restoredir${filePath}"| cut -d " " -f 1)
				fi
       			        cat <<myEOF >> $resultFile

	        "file_${name}":{ 
	                "file_path":"$filePath",
        	       	"name":"$name",
                	"inode":"$inode",
	                "file_type":"$fileType",
	                "mode":"$mode",
       		        "size":"$size",
			"modified":"$modified",
	                "accessed":"$accessed",
       		        "changed":"$changed",
               		"created":"$created",
	                "size":"$size",
        	        "sha256":"$sha256"
                }
myEOF
		;;

		esac

	done
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

cat <<myEOF > $resultFile
{ 
	"partition":{
		"part_type":"$partType",
		"unit_size":"$unitSize",
		"first_unit":"$firstUnit",
		"description":"$description"
	}
myEOF

# file system analysis
fsstatResult=$(fsstat -o "$firstUnit" "$imageFile")
fsType=$(echo "$fsstatResult" | grep -oP "(?<=File System Type: ).*" )
fsName=$(echo "$fsstatResult" | grep -oP "(?<=Volume Name: ).*" )
fsId=$(echo "$fsstatResult" | grep -oP "(?<=Volume ID: ).*" )
fsSourceOs=$(echo "$fsstatResult" | grep -oP "(?<=Source OS: ).*" )
fsLastMount=$(echo "$fsstatResult" | grep -oP "(?<=Source OS: ).*" )

cat <<myEOF >> $resultFile
	"fs":{
		"fs_type":"$fsType",
		"fs_name":"$fsName",
		"fs_id":"$fsId",
		"fs_source_os":"$fsSourceOs"
	}
myEOF

# files analysis
cat <<myEOF >> $resultFile
        "files": {
myEOF

flsResult=$(fls -m -p -r -o "$firstUnit" "$imageFile")
get_fileinfo $flsResult

# close file
cat <<myEOF >> $resultFile
	}
}
myEOF

exit 0
