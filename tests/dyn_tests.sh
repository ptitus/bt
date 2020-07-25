#!/bin/bash
# test for zfs Filesystem.

# pooling File System

baseDir=".."

# basic tests
testJQ(){
	result=$(jq --version)
	rtrn=$?
	assertEquals  'Error calling jq' 0 ${rtrn}
	assertContains 'jq version 1.5*' "$result" "jq-1.5"
}

testOBJCOUNT(){
	src=$(jq '. | length' <<< "$srcJson")
	tsk=$(jq '. | length' <<< "$tskJson")
	assertNotNull "Source File $fileName no objects" "$src"
        assertNotNull "TSK File $fileName no objects" "$tsk"
	assertEquals 'Json object count is not equal' "$src" "$tsk"
}

# file system information
testFILESYSTEM-TYPE(){
	src=$(jq '.fs.type' <<< "$srcJson" | tr '[:upper:]' '[:lower:]' | tr -d '"')
	tsk=$(jq '.fs.type' <<< "$tskJson" | tr '[:upper:]' '[:lower:]' | tr -d '"')
	assertNotNull "Source File $fileName emty fs.type" "$src"
        assertNotNull "TSK File $fileName empty fs.type" "$tsk"
	assertEquals 'Type of filesystem does not match' "$src" "$tsk"
}

testFILESYSTEM-LABEL(){
	src=$(jq '.fs.label' <<< "$srcJson" | tr '[:upper:]' '[:lower:]' | tr -d '"')
	tsk=$(jq '.fs.label' <<< "$tskJson" | tr '[:upper:]' '[:lower:]' | tr -d '"')
	assertNotNull "Source File $fileName emty fs.label" "$src"
        assertNotNull "TSK File $fileName empty fs.label" "$tsk"
	assertEquals 'Label of fs does not match' "$src" "$tsk"
}

testFILESYSTEM-ID(){
	src=$(jq '.fs.id' <<< "$srcJson" | tr '[:upper:]' '[:lower:]' | tr -d '"')
	tsk=$(jq '.fs.id' <<< "$tskJson" | tr '[:upper:]' '[:lower:]' | tr -d '"')
	assertNotNull "Source File $fileName emty fs.id" "$src"
        assertNotNull "TSK File $fileName empty fs.id" "$tsk"
	assertEquals 'ID of fs does not match' "$src" "$tsk"
}

testFILESYSTEM-DEVICECOUNT(){
	src=$(jq '.fs.device_count' <<< "$srcJson" | tr '[:upper:]' '[:lower:]' | tr -d '"')
	tsk=$(jq '.fs.device_count' <<< "$tskJson" | tr '[:upper:]' '[:lower:]' | tr -d '"')
	assertNotNull "Source File $fileName emty fs.device_count" "$src"
        assertNotNull "TSK File $fileName empty fs.device_count" "$tsk"
	assertEquals 'Device count of fs does not match' "$src" "$tsk"
}

# files

testFILE-ZEROLENGTH(){
        fileName='file.0'
        fileSrcObj=$(jq '.files."file.0"' <<< "$srcJson")
        fileTskObj=$(jq '.files."file.0"' <<< "$tskJson")

        assertNotNull "Source File $fileName not found" "$fileSrcObj"
        assertNotNull "TSK File $fileName not found" "$fileTskObj"

	[[ -z "$fileSrcObj" ]] && startSkipping
        [[ -z "$fileTskObj" ]] && startSkipping

        src=$(jq '.filepath' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.filepath' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty filepath" "$src"
        assertNotNull "TSK File $fileName empty filepath" "$tsk"
        assertEquals 'Path of file does not match' "$src" "$tsk"

        src=$(jq '.inode' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.inode' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty inode" "$src"
        assertNotNull "TSK File $fileName empty inode" "$tsk"
        assertEquals 'Inode of file does not match' "$src" "$tsk"

        src=$(jq '.file_type' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.file_type' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty file_type" "$src"
        assertNotNull "TSK File $fileName empty file_type" "$tsk"
        assertEquals 'Type of file does not match' "$src" "$tsk"

        src=$(jq '.mode' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.mode' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty mode" "$src"
        assertNotNull "TSK File $fileName empty mode" "$tsk"
        assertEquals 'Mode of file does not match' "$src" "$tsk"

        src=$(jq '.size' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.size' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty size" "$src"
        assertNotNull "TSK File $fileName empty size" "$tsk"
        assertEquals 'Size of file does not match' "$src" "$tsk"

        src=$(jq '.modified' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.modified' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty modified" "$src"
        assertNotNull "TSK File $fileName empty modified" "$tsk"
        assertEquals 'Modified Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.accessed' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.accessed' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty accessed" "$src"
        assertNotNull "TSK File $fileName empty accessed" "$tsk"
        assertEquals 'Accessed Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.changed' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.changed' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty changed" "$src"
        assertNotNull "TSK File $fileName empty changed" "$tsk"
        assertEquals 'Change Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.created' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.created' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty created" "$src"
        assertNotNull "TSK File $fileName empty created" "$tsk"
        assertEquals 'Creation Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.sha256' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.sha256' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty sha256" "$src"
        assertNotNull "TSK File $fileName empty sha256" "$tsk"
        assertEquals 'Sha256 Checksum of file does not match' "$src" "$tsk"
}

# binary file
testFILE-BINARY() {
        fileName='file.binary'
        fileSrcObj=$(jq '.files."file.binary"' <<< "$srcJson")
        fileTskObj=$(jq '.files."file.binary"' <<< "$tskJson")

        assertNotNull "Source File $fileName not found" "$fileSrcObj"
        assertNotNull "TSK File $fileName not found" "$fileTskObj"

	[[ -z "$fileSrcObj" ]] && startSkipping
        [[ -z "$fileTskObj" ]] && startSkipping

        src=$(jq '.filepath' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.filepath' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty filepath" "$src"
        assertNotNull "TSK File $fileName empty filepath" "$tsk"
        assertEquals 'Path of file does not match' "$src" "$tsk"

        src=$(jq '.inode' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.inode' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty inode" "$src"
        assertNotNull "TSK File $fileName empty inode" "$tsk"
        assertEquals 'Inode of file does not match' "$src" "$tsk"

        src=$(jq '.file_type' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.file_type' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty file_type" "$src"
        assertNotNull "TSK File $fileName empty file_type" "$tsk"
        assertEquals 'Type of file does not match' "$src" "$tsk"

        src=$(jq '.mode' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.mode' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty mode" "$src"
        assertNotNull "TSK File $fileName empty mode" "$tsk"
        assertEquals 'Mode of file does not match' "$src" "$tsk"

        src=$(jq '.size' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.size' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty size" "$src"
        assertNotNull "TSK File $fileName empty size" "$tsk"
        assertEquals 'Size of file does not match' "$src" "$tsk"

        src=$(jq '.modified' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.modified' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty modified" "$src"
        assertNotNull "TSK File $fileName empty modified" "$tsk"
        assertEquals 'Modified Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.accessed' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.accessed' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty accessed" "$src"
        assertNotNull "TSK File $fileName empty accessed" "$tsk"
        assertEquals 'Accessed Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.changed' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.changed' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty changed" "$src"
        assertNotNull "TSK File $fileName empty changed" "$tsk"
        assertEquals 'Change Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.created' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.created' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty created" "$src"
        assertNotNull "TSK File $fileName empty created" "$tsk"
        assertEquals 'Creation Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.sha256' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.sha256' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty sha256" "$src"
        assertNotNull "TSK File $fileName empty sha256" "$tsk"
        assertEquals 'Sha256 Checksum of file does not match' "$src" "$tsk"
}

# text file
testFILE-TEXT(){
        fileName='file.txt'
        fileSrcObj=$(jq '.files."file.txt"' <<< "$srcJson")
        fileTskObj=$(jq '.files."file.txt"' <<< "$tskJson")
        
	assertNotNull "Source File $fileName not found" "$fileSrcObj"
        assertNotNull "TSK File $fileName not found" "$fileTskObj"

	[[ -z "$fileSrcObj" ]] && startSkipping
        [[ -z "$fileTskObj" ]] && startSkipping

        src=$(jq '.filepath' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.filepath' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty filepath" "$src"
        assertNotNull "TSK File $fileName empty filepath" "$tsk"
        assertEquals 'Path of file does not match' "$src" "$tsk"

        src=$(jq '.inode' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.inode' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty inode" "$src"
        assertNotNull "TSK File $fileName empty inode" "$tsk"
        assertEquals 'Inode of file does not match' "$src" "$tsk"

        src=$(jq '.file_type' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.file_type' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty file_type" "$src"
        assertNotNull "TSK File $fileName empty file_type" "$tsk"
        assertEquals 'Type of file does not match' "$src" "$tsk"

        src=$(jq '.mode' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.mode' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty mode" "$src"
        assertNotNull "TSK File $fileName empty mode" "$tsk"
        assertEquals 'Mode of file does not match' "$src" "$tsk"

        src=$(jq '.size' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.size' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty size" "$src"
        assertNotNull "TSK File $fileName empty size" "$tsk"
        assertEquals 'Size of file does not match' "$src" "$tsk"

        src=$(jq '.modified' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.modified' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty modified" "$src"
        assertNotNull "TSK File $fileName empty modified" "$tsk"
        assertEquals 'Modified Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.accessed' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.accessed' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty accessed" "$src"
        assertNotNull "TSK File $fileName empty accessed" "$tsk"
        assertEquals 'Accessed Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.changed' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.changed' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty changed" "$src"
        assertNotNull "TSK File $fileName empty changed" "$tsk"
        assertEquals 'Change Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.created' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.created' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty created" "$src"
        assertNotNull "TSK File $fileName empty created" "$tsk"
        assertEquals 'Creation Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.sha256' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.sha256' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty sha256" "$src"
        assertNotNull "TSK File $fileName empty sha256" "$tsk"
        assertEquals 'Sha256 Checksum of file does not match' "$src" "$tsk"
}

# subdirectory
testFILE-SUBDIR(){
        fileName='subdir'
        fileSrcObj=$(jq '.files."subdir"' <<< "$srcJson")
        fileTskObj=$(jq '.files."subdir"' <<< "$tskJson")
	
	assertNotNull "Source File $fileName not found" "$fileSrcObj"
        assertNotNull "TSK File $fileName not found" "$fileTskObj"

	[[ -z "$fileSrcObj" ]] && startSkipping
        [[ -z "$fileTskObj" ]] && startSkipping

        src=$(jq '.filepath' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.filepath' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty filepath" "$src"
        assertNotNull "TSK File $fileName empty filepath" "$tsk"
        assertEquals 'Path of file does not match' "$src" "$tsk"

        src=$(jq '.inode' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.inode' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty inode" "$src"
        assertNotNull "TSK File $fileName empty inode" "$tsk"
        assertEquals 'Inode of file does not match' "$src" "$tsk"

        src=$(jq '.file_type' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.file_type' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty file_type" "$src"
        assertNotNull "TSK File $fileName empty file_type" "$tsk"
        assertEquals 'Type of file does not match' "$src" "$tsk"

        src=$(jq '.mode' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.mode' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty mode" "$src"
        assertNotNull "TSK File $fileName empty mode" "$tsk"
        assertEquals 'Mode of file does not match' "$src" "$tsk"

        src=$(jq '.size' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.size' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty size" "$src"
        assertNotNull "TSK File $fileName empty size" "$tsk"
        assertEquals 'Size of file does not match' "$src" "$tsk"

        src=$(jq '.modified' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.modified' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty modified" "$src"
        assertNotNull "TSK File $fileName empty modified" "$tsk"
        assertEquals 'Modified Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.accessed' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.accessed' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty accessed" "$src"
        assertNotNull "TSK File $fileName empty accessed" "$tsk"
        assertEquals 'Accessed Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.changed' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.changed' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty changed" "$src"
        assertNotNull "TSK File $fileName empty changed" "$tsk"
        assertEquals 'Change Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.created' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.created' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty created" "$src"
        assertNotNull "TSK File $fileName empty created" "$tsk"
        assertEquals 'Creation Timestamp of file does not match' "$src" "$tsk"

	#subdir has no content to hash
        #src=$(jq '.sha256' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        #tsk=$(jq '.sha256' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        #assertNotNull "Source File $fileName empty sha256" "$src"
        #assertNotNull "TSK File $fileName empty sha256" "$tsk"
        #assertEquals 'Sha256 Checksum of file does not match' "$src" "$tsk"
}

# file in subdirectory
testFILE-SUBFILE(){
        fileName='file2.txt'
        fileSrcObj=$(jq '.files."file2.txt"' <<< "$srcJson")
        fileTskObj=$(jq '.files."file2.txt"' <<< "$tskJson")

	assertNotNull "Source File $fileName not found" "$fileSrcObj"
        assertNotNull "TSK File $fileName not found" "$fileTskObj"

	[[ -z "$fileSrcObj" ]] && startSkipping
        [[ -z "$fileTskObj" ]] && startSkipping

        src=$(jq '.filepath' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.filepath' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty filepath" "$src"
        assertNotNull "TSK File $fileName empty filepath" "$tsk"
        assertEquals 'Path of file does not match' "$src" "$tsk"

        src=$(jq '.inode' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.inode' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty inode" "$src"
        assertNotNull "TSK File $fileName empty inode" "$tsk"
        assertEquals 'Inode of file does not match' "$src" "$tsk"

        src=$(jq '.file_type' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.file_type' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty file_type" "$src"
        assertNotNull "TSK File $fileName empty file_type" "$tsk"
        assertEquals 'Type of file does not match' "$src" "$tsk"

        src=$(jq '.mode' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.mode' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty mode" "$src"
        assertNotNull "TSK File $fileName empty mode" "$tsk"
        assertEquals 'Mode of file does not match' "$src" "$tsk"

        src=$(jq '.size' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.size' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty size" "$src"
        assertNotNull "TSK File $fileName empty size" "$tsk"
        assertEquals 'Size of file does not match' "$src" "$tsk"

        src=$(jq '.modified' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.modified' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty modified" "$src"
        assertNotNull "TSK File $fileName empty modified" "$tsk"
        assertEquals 'Modified Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.accessed' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.accessed' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty accessed" "$src"
        assertNotNull "TSK File $fileName empty accessed" "$tsk"
        assertEquals 'Accessed Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.changed' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.changed' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty changed" "$src"
        assertNotNull "TSK File $fileName empty changed" "$tsk"
        assertEquals 'Change Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.created' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.created' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty created" "$src"
        assertNotNull "TSK File $fileName empty created" "$tsk"
        assertEquals 'Creation Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.sha256' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.sha256' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty sha256" "$src"
        assertNotNull "TSK File $fileName empty sha256" "$tsk"
        assertEquals 'Sha256 Checksum of file does not match' "$src" "$tsk"
}


# deleted file
testFILE-DELETED(){
	fileName="delfile.txt"
        fileSrcObj=$(jq --arg sel "$fileName" '.files."$sel"' <<< "$srcJson")
	delInode=$(jq --arg f "$fileName" '.files | select( .[$f] ) | .[$f].inode ' <<< "$srcJson" | tr -d '"')
	#delInode=$(jq --arg f "$fileName" '.files[] | select( .[$f] ) | .[$f].inode ' <<< "$srcJson" | tr -d '"')
	orphanKey=$(jq --arg reg_exp ".*${delInode}.*" '.files | with_entries(select(.key | match($reg_exp))) | select(length > 0) | keys [] ' <<< "$tskJson" | tr -d '"')
	fileTskObj=$(jq --arg sel "$orphanKey" '.files[] | .[$sel] | select(length > 0)' <<< "$tskJson")
	
	assertNotNull "Source File $fileName not found" "$fileSrcObj"
        assertNotNull "TSK File $fileName not found" "$fileTskObj"

	[[ -z "$fileSrcObj" ]] && startSkipping
        [[ -z "$fileTskObj" ]] && startSkipping

        src=$(jq '.filepath' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.filepath' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty filepath" "$src"
        assertNotNull "TSK File $fileName empty filepath" "$tsk"
        assertEquals 'Path of file does not match' "$src" "$tsk"

        src=$(jq '.inode' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.inode' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty inode" "$src"
        assertNotNull "TSK File $fileName empty inode" "$tsk"
        assertEquals 'Inode of file does not match' "$src" "$tsk"

        src=$(jq '.file_type' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.file_type' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty file_type" "$src"
        assertNotNull "TSK File $fileName empty file_type" "$tsk"
        assertEquals 'Type of file does not match' "$src" "$tsk"

        src=$(jq '.mode' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.mode' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty mode" "$src"
        assertNotNull "TSK File $fileName empty mode" "$tsk"
        assertEquals 'Mode of file does not match' "$src" "$tsk"

        src=$(jq '.size' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.size' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty size" "$src"
        assertNotNull "TSK File $fileName empty size" "$tsk"
        assertEquals 'Size of file does not match' "$src" "$tsk"

        src=$(jq '.modified' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.modified' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty modified" "$src"
        assertNotNull "TSK File $fileName empty modified" "$tsk"
        assertEquals 'Modified Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.accessed' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.accessed' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty accessed" "$src"
        assertNotNull "TSK File $fileName empty accessed" "$tsk"
        assertEquals 'Accessed Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.changed' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.changed' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty changed" "$src"
        assertNotNull "TSK File $fileName empty changed" "$tsk"
        assertEquals 'Change Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.created' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.created' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty created" "$src"
        assertNotNull "TSK File $fileName empty created" "$tsk"
        assertEquals 'Creation Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.sha256' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.sha256' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertNotNull "Source File $fileName empty sha256" "$src"
        assertNotNull "TSK File $fileName empty sha256" "$tsk"
        assertEquals 'Sha256 Checksum of file does not match' "$src" "$tsk"
}

oneTimeSetUp() {
	originalPath=$PATH
	PATH=$PWD:$PATH
	# Variables
	myDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"	
	genMachineName="generator_lnx"
	tskMachineName="sleuthkit_fkiecad"
	srcScript="zfs_generate.sh"
	tskScript="zfs_analyze.sh"

	# generate VM Names
	vmGenMachineName=$(echo "$genMachineName" | sed 's/_/-/g')
	vmTskMachineName=$(echo "$tskMachineName" | sed 's/_/-/g')
	
	# find vagrant machines
	vagrantStatus=$(vagrant global-status)
	genMachineId=$(echo "$vagrantStatus" | grep "$genMachineName" | cut -d " " -f 1)  
	if [[ -z "$genMachineId" ]]
	then
		echo "Vagrant machine $genMachineName not found"
		exit 1
	fi
	tskMachineId=$(echo "$vagrantStatus" | grep $tskMachineName | cut -d " " -f 1) 
	if [[ -z "$tskMachineId" ]]
	then
		echo "Vagrant machine $tskMachineName not found"
	       	exit 1
	fi
	
        # eventually bring generator machine up
        genMachineState=$( echo "$vagrantStatus" | grep $genMachineName | sed -e 's/ \+/;/g' | cut -d ";" -f 4)
        [[ "$genMachineState" == running ]] || vagrant up "$genMachineId"

	# generate evidence
	cd ${baseDir}/bolt/
	bolt script run ${myDir}/${srcScript} --targets "$vmGenMachineName"

	# shutdown generator
	vagrant halt $genMachineId

	# eventually bring tsk machine up
        tskMachineState=$( echo "$vagrantStatus" | grep $tskMachineName | sed -e 's/ \+/;/g' | cut -d ";" -f 4)
        [[ "$tskMachineState" == running ]] || vagrant up "$tskMachineId"

	# analyze evidence
	bolt script run ${myDir}/${tskScript} --targets "$vmTskMachineName"

	# shutdown tsk machine
	vagrant halt $tskMachineId

	# load .json files in variables
	srcJson=$(jq . < ${baseDir}/data/zfssrc.json | sed -e 's/ null / "" /g')
	tskJson=$(jq . < ${baseDir}/data/zfstsk.json | sed -e 's/ null / "" /g')
	
	# back to original directory
	cd $myDir
}

oneTimeTearDown() {
  PATH=$originalPath
}

# Load and run shUnit2.
. ${baseDir}/shunit2/shunit2
