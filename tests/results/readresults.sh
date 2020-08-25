#!/bin/bash

#for fs in ext4 ntfs zfs btrfs refs apfs
for fs in refs 
do
	echo "FS: $fs"
	echo "Files: $(ls -1 "$fs" | wc -l)"
	echo "File tests: $(grep -P 'testFILE-(?!DELETED)' $fs/* | wc -l)"
        echo "Timestamp ASSERTS: $(grep 'ASSERT:.*Timestamp.*not match' $fs/* | wc -l)"
	for file in file.0 file.binary file.txt subdir file2.txt delfile.txt
	do
		for tst in Accessed Creation Modified Change
		do
			echo "File $file ASSERT ${tst}: $(grep "ASSERT:${tst} Timestamp of ${file} does not match" $fs/* | wc -l)"
		done
	done

	echo "#######################################################################"
done

echo "done"
