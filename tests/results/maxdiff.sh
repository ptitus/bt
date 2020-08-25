#!/bin/bash

for fs in ext4 ntfs btrfs refs apfs
do
	maxdiff=0
	echo "FS: $fs"
	echo "Files: $(ls -1 "$fs" | wc -l)"
	lines=$(grep 'ASSERT:.* Timestamp' $fs/* | grep -oP '<.{2,10}> but was:<.+>')
	while IFS= read -r  line
	do
		soll=$(echo "$line" | grep -oP '(?<=^<).+(?=> )')
		ist=$(echo "$line" | grep -oP '(?<=:<).+(?=>$)')
		dif=$(($soll-$ist))
		dif=${dif#-}
		if [ "$dif" -gt "$maxdiff" ]
		then
			maxdiff=${dif#-}
		fi
	done <<< "$lines"
	echo "maxDiff: $maxdiff"
done

echo "done"
