#!/bin/bash

# define Variables
imgFolder='zfsimg'
homeFolder='/home/user'
deviceFolder="${homeFolder}/${imgFolder}"
sharedFolder='/media/sf_data'
rawFile1='disk1'
rawFile2='disk2'
resultJsonFile='{}'
resultFile="${sharedFolder}/zfstsk.json"

# define functions

function get_fileinfo() {
        while IFS= read -r line; do
		fileType=$(echo "$line" | grep -oP '[[:word:]]{1}(?=/[[:word:]] )')
		inode=$(echo "$line" | grep -oP '[[:digit:]]+(?=: )')
		mode="" #not implemented
		fileName=$(echo "$line" |  sed -e 's/ \+/ /g' | grep -oP '(?<=[[:digit:]]{1}: ).*')
		istatResult=$(istat -P "./${imgFolder}" "${inode}")
		case "$fileType" in
			(d|r|-)
				filePath="" #not implemented
				modified=$(echo "$istatResult" | grep -oP '(?<=Modified time: ).+' | sed -e 's/^ *//g' | date "+%s")
				accessed=$(echo "$istatResult" | grep -oP '(?<=Access time: ).+' | sed -e 's/^ *//g' | date "+%s")
        		        changed=""
				created=$(echo "$istatResult" | grep -oP '(?<=Modified time: ).+' | sed -e 's/^ *//g'| date "+%s")
	        	        size=$(echo "$istatResult" | grep -oP '(?<=Size: )[[:digit:]]+')
				case "$fileType" in
					(d)
						mkdir "restoredir/${fileName}"
						sha256=""
						;;
	
					(r|-)
					icat -P  "./${imgFolder}" "$inode" > "restoredir/${fileName}" 
					sha256=$(sha256sum "restoredir/${fileName}"| cut -d " " -f 1)
					;;
				esac					
                resultJson=$(echo "$resultJson" | jq \
				--arg n "$fileName" \
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

	done < <(echo "$1")
}
# move device files
[[ -d "${homeFolder}/${imgFolder}" ]] && rm -r "${homeFolder}/${imgFolder}"
mv "${sharedFolder}/${imgFolder}" "$homeFolder"

# file system analysis
cd "$homeFolder"
plsResult=$(pls "./${imgFolder}")
fsstatResult=$(fsstat -P "./${imgFolder}")
fsType=""
fsLabel=$(echo "$plsResult" | grep -oP '(?<=Name: ).+')
fsId=$(echo "$plsResult" | grep -oP '(?<=GUID: ).+')
fsDeviceCount=$(echo "$plsResult" | grep -P '^    .+\(ID: .+\)' | wc -l)
resultJson=$(echo "{}" | jq \
        --arg t "$fsType" \
	--arg l "$fsLabel" \
        --arg i "$fsId" \
        --arg d "$fsDeviceCount" \
        ' . * {"fs": {"type": $t, "label": $l, "id": $i, "device_count": $d}}' )

# files analysis
resultJson=$(echo "$resultJson" | jq ' . + {'files':{}}')
flsResult=$(fls -P "./${imgFolder}")
if ! [[  -d "restoredir" ]] 
then
	mkdir "restoredir"
fi
get_fileinfo "$flsResult"
# recover file 
# not implemented

# cleanup
rm -r restoredir

# write json file
echo "$resultJson" > "$resultFile"

exit 0
