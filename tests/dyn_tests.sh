#!/bin/bash
# test for zfs Filesystem.

# pooling File System

baseDir=".."

# basic tests
<<COMMENT
no_testJQ(){
	result=$(jq --version)
	rtrn=$?
	assertEquals  'Error calling jq' 0 ${rtrn}
	assertContains 'jq version 1.5*' "$result" "jq-1.5"
}

no_testOBJCOUNT(){
	src=$(jq '. | length // empty' <<< "$srcJson")
	tsk=$(jq '. | length // empty' <<< "$tskJson")
	assertNotNull "Source File $fileName no objects" "$src"
        assertNotNull "TSK File $fileName no objects" "$tsk"
	assertEquals 'Json object count is not equal' "$src" "$tsk"
}
COMMENT
# file system information
testFILESYSTEM(){
	src=$(jq '.fs.type // empty' <<< "$srcJson" | tr -d '"')
	tsk=$(jq '.fs.type // empty' <<< "$tskJson" | tr -d '"')
	assertNotNull "Source File $fileName empty fs.type" "$src"
        assertNotNull "TSK File $fileName empty fs.type" "$tsk"
	assertEquals 'Type of filesystem does not match' "$src" "$tsk"
	
	src=$(jq '.fs.label // empty' <<< "$srcJson" | tr -d '"')
	tsk=$(jq '.fs.label // empty' <<< "$tskJson" | tr -d '"')
	assertNotNull "Source File $fileName empty fs.label" "$src"
        assertNotNull "TSK File $fileName empty fs.label" "$tsk"
	assertEquals 'Label of fs does not match' "$src" "$tsk"

	src=$(jq '.fs.id // empty' <<< "$srcJson" | tr -d '"')
	tsk=$(jq '.fs.id // empty' <<< "$tskJson" | tr -d '"')
	assertNotNull "Source File $fileName empty fs.id" "$src"
        assertNotNull "TSK File $fileName empty fs.id" "$tsk"
	assertEquals 'ID of fs does not match' "$src" "$tsk"

	src=$(jq '.fs.device_count // empty' <<< "$srcJson" | tr -d '"')
	tsk=$(jq '.fs.device_count // empty' <<< "$tskJson" | tr -d '"')
	assertNotNull "Source File $fileName empty fs.device_count" "$src"
        assertNotNull "TSK File $fileName empty fs.device_count" "$tsk"
	assertEquals 'Device count of fs does not match' "$src" "$tsk"
}

# files

testFILE-ZEROLENGTH(){
        fileName='file.0'
        fileSrcObj=$(jq '.files."file.0" // empty' <<< "$srcJson")
        fileTskObj=$(jq '.files."file.0" // empty' <<< "$tskJson")

        assertNotNull "Source File $fileName not found" "$fileSrcObj"
        assertNotNull "TSK File $fileName not found" "$fileTskObj"

	[[ -z "$fileSrcObj" ]] && startSkipping
        [[ -z "$fileTskObj" ]] && startSkipping

        src=$(jq '.filepath // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.filepath // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty filepath" "$src"
        assertNotNull "TSK File $fileName empty filepath" "$tsk"
        assertEquals "Path of $fileName does not match" "$src" "$tsk"

        src=$(jq '.inode // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.inode // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty inode" "$src"
        assertNotNull "TSK File $fileName empty inode" "$tsk"
        assertEquals "Inode of $fileName does not match" "$src" "$tsk"

        src=$(jq '.file_type // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.file_type // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty file_type" "$src"
        assertNotNull "TSK File $fileName empty file_type" "$tsk"
        assertEquals "Type of $fileName does not match" "$src" "$tsk"

        src=$(jq '.mode // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.mode // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty mode" "$src"
        assertNotNull "TSK File $fileName empty mode" "$tsk"
        assertEquals "Mode of $fileName does not match" "$src" "$tsk"

        src=$(jq '.size // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.size // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty size" "$src"
        assertNotNull "TSK File $fileName empty size" "$tsk"
        assertEquals "Size of $fileName does not match" "$src" "$tsk"

        src=$(jq '.modified // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.modified // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty modified" "$src"
        assertNotNull "TSK File $fileName empty modified" "$tsk"
        assertEquals "Modified Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.accessed // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.accessed // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty accessed" "$src"
        assertNotNull "TSK File $fileName empty accessed" "$tsk"
        assertEquals "Accessed Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.changed // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.changed // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty changed" "$src"
        assertNotNull "TSK File $fileName empty changed" "$tsk"
        assertEquals "Change Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.created // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.created // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty created" "$src"
        assertNotNull "TSK File $fileName empty created" "$tsk"
        assertEquals "Creation Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.sha256 // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.sha256 // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty sha256" "$src"
        assertNotNull "TSK File $fileName empty sha256" "$tsk"
        assertEquals "Sha256 Checksum of $fileName does not match" "$src" "$tsk"
}

# binary file
testFILE-BINARY() {
        fileName='file.binary'
        fileSrcObj=$(jq '.files."file.binary" // empty' <<< "$srcJson")
        fileTskObj=$(jq '.files."file.binary" // empty' <<< "$tskJson")

        assertNotNull "Source File $fileName not found" "$fileSrcObj"
        assertNotNull "TSK File $fileName not found" "$fileTskObj"

	[[ -z "$fileSrcObj" ]] && startSkipping
        [[ -z "$fileTskObj" ]] && startSkipping

        src=$(jq '.filepath // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.filepath // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty filepath" "$src"
        assertNotNull "TSK File $fileName empty filepath" "$tsk"
        assertEquals "Path of $fileName does not match" "$src" "$tsk"

        src=$(jq '.inode // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.inode // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty inode" "$src"
        assertNotNull "TSK File $fileName empty inode" "$tsk"
        assertEquals "Inode of $fileName does not match" "$src" "$tsk"

        src=$(jq '.file_type // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.file_type // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty file_type" "$src"
        assertNotNull "TSK File $fileName empty file_type" "$tsk"
        assertEquals "Type of $fileName does not match" "$src" "$tsk"

        src=$(jq '.mode // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.mode // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty mode" "$src"
        assertNotNull "TSK File $fileName empty mode" "$tsk"
        assertEquals "Mode of $fileName does not match" "$src" "$tsk"

        src=$(jq '.size // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.size // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty size" "$src"
        assertNotNull "TSK File $fileName empty size" "$tsk"
        assertEquals "Size of $fileName does not match" "$src" "$tsk"

        src=$(jq '.modified // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.modified // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty modified" "$src"
        assertNotNull "TSK File $fileName empty modified" "$tsk"
        assertEquals "Modified Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.accessed // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.accessed // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty accessed" "$src"
        assertNotNull "TSK File $fileName empty accessed" "$tsk"
        assertEquals "Accessed Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.changed // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.changed // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty changed" "$src"
        assertNotNull "TSK File $fileName empty changed" "$tsk"
        assertEquals "Change Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.created // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.created // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty created" "$src"
        assertNotNull "TSK File $fileName empty created" "$tsk"
        assertEquals "Creation Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.sha256 // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.sha256 // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty sha256" "$src"
        assertNotNull "TSK File $fileName empty sha256" "$tsk"
        assertEquals "Sha256 Checksum of $fileName does not match" "$src" "$tsk"
}

# text file
testFILE-TEXT(){
        fileName='file.txt'
        fileSrcObj=$(jq '.files."file.txt" // empty' <<< "$srcJson")
        fileTskObj=$(jq '.files."file.txt" // empty' <<< "$tskJson")
        
	assertNotNull "Source File $fileName not found" "$fileSrcObj"
        assertNotNull "TSK File $fileName not found" "$fileTskObj"

	[[ -z "$fileSrcObj" ]] && startSkipping
        [[ -z "$fileTskObj" ]] && startSkipping

        src=$(jq '.filepath // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.filepath // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty filepath" "$src"
        assertNotNull "TSK File $fileName empty filepath" "$tsk"
        assertEquals "Path of $fileName does not match" "$src" "$tsk"

        src=$(jq '.inode // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.inode // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty inode" "$src"
        assertNotNull "TSK File $fileName empty inode" "$tsk"
        assertEquals "Inode of $fileName does not match" "$src" "$tsk"

        src=$(jq '.file_type // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.file_type // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty file_type" "$src"
        assertNotNull "TSK File $fileName empty file_type" "$tsk"
        assertEquals "Type of $fileName does not match" "$src" "$tsk"

        src=$(jq '.mode // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.mode // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty mode" "$src"
        assertNotNull "TSK File $fileName empty mode" "$tsk"
        assertEquals "Mode of $fileName does not match" "$src" "$tsk"

        src=$(jq '.size // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.size // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty size" "$src"
        assertNotNull "TSK File $fileName empty size" "$tsk"
        assertEquals "Size of $fileName does not match" "$src" "$tsk"

        src=$(jq '.modified // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.modified // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty modified" "$src"
        assertNotNull "TSK File $fileName empty modified" "$tsk"
        assertEquals "Modified Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.accessed // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.accessed // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty accessed" "$src"
        assertNotNull "TSK File $fileName empty accessed" "$tsk"
        assertEquals "Accessed Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.changed // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.changed // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty changed" "$src"
        assertNotNull "TSK File $fileName empty changed" "$tsk"
        assertEquals "Change Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.created // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.created // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty created" "$src"
        assertNotNull "TSK File $fileName empty created" "$tsk"
        assertEquals "Creation Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.sha256 // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.sha256 // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty sha256" "$src"
        assertNotNull "TSK File $fileName empty sha256" "$tsk"
        assertEquals "Sha256 Checksum of $fileName does not match" "$src" "$tsk"
}

# subdirectory
testFILE-SUBDIR(){
	fileName='subdir'
	fileSrcObj=$(jq '.files."subdir" // empty' <<< "$srcJson")
	fileTskObj=$(jq '.files."subdir" // empty' <<< "$tskJson")
	
	assertNotNull "Source File $fileName not found" "$fileSrcObj"
	assertNotNull "TSK File $fileName not found" "$fileTskObj"

	[[ -z "$fileSrcObj" ]] && startSkipping
        [[ -z "$fileTskObj" ]] && startSkipping
	

        src=$(jq '.filepath // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.filepath // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty filepath" "$src"
        assertNotNull "TSK File $fileName empty filepath" "$tsk"
        assertEquals "Path of $fileName does not match" "$src" "$tsk"

        src=$(jq '.inode // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.inode // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty inode" "$src"
        assertNotNull "TSK File $fileName empty inode" "$tsk"
        assertEquals "Inode of $fileName does not match" "$src" "$tsk"

        src=$(jq '.file_type // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.file_type // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty file_type" "$src"
        assertNotNull "TSK File $fileName empty file_type" "$tsk"
        assertEquals "Type of $fileName does not match" "$src" "$tsk"

        src=$(jq '.mode // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.mode // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty mode" "$src"
        assertNotNull "TSK File $fileName empty mode" "$tsk"
        assertEquals "Mode of $fileName does not match" "$src" "$tsk"

        #subdir has no size to compare

        src=$(jq '.modified // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.modified // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty modified" "$src"
        assertNotNull "TSK File $fileName empty modified" "$tsk"
        assertEquals "Modified Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.accessed // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.accessed // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty accessed" "$src"
        assertNotNull "TSK File $fileName empty accessed" "$tsk"
        assertEquals "Accessed Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.changed // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.changed // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty changed" "$src"
        assertNotNull "TSK File $fileName empty changed" "$tsk"
        assertEquals "Change Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.created // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.created // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty created" "$src"
        assertNotNull "TSK File $fileName empty created" "$tsk"
        assertEquals "Creation Timestamp of $fileName does not match" "$src" "$tsk"

	#subdir has no content to hash
}

# file in subdirectory
testFILE-SUBFILE(){
        fileName='file2.txt'
        fileSrcObj=$(jq '.files."file2.txt" // empty' <<< "$srcJson")
        fileTskObj=$(jq '.files."file2.txt" // empty' <<< "$tskJson")

	assertNotNull "Source File $fileName not found" "$fileSrcObj"
        assertNotNull "TSK File $fileName not found" "$fileTskObj"

	[[ -z "$fileSrcObj" ]] && startSkipping
        [[ -z "$fileTskObj" ]] && startSkipping

        src=$(jq '.filepath // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.filepath // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty filepath" "$src"
        assertNotNull "TSK File $fileName empty filepath" "$tsk"
        assertEquals "Path of $fileName does not match" "$src" "$tsk"

        src=$(jq '.inode // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.inode // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty inode" "$src"
        assertNotNull "TSK File $fileName empty inode" "$tsk"
        assertEquals "Inode of $fileName does not match" "$src" "$tsk"

        src=$(jq '.file_type // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.file_type // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty file_type" "$src"
        assertNotNull "TSK File $fileName empty file_type" "$tsk"
        assertEquals "Type of $fileName does not match" "$src" "$tsk"

        src=$(jq '.mode // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.mode // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty mode" "$src"
        assertNotNull "TSK File $fileName empty mode" "$tsk"
        assertEquals "Mode of $fileName does not match" "$src" "$tsk"

        src=$(jq '.size // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.size // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty size" "$src"
        assertNotNull "TSK File $fileName empty size" "$tsk"
        assertEquals "Size of $fileName does not match" "$src" "$tsk"

        src=$(jq '.modified // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.modified // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty modified" "$src"
        assertNotNull "TSK File $fileName empty modified" "$tsk"
        assertEquals "Modified Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.accessed // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.accessed // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty accessed" "$src"
        assertNotNull "TSK File $fileName empty accessed" "$tsk"
        assertEquals "Accessed Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.changed // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.changed // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty changed" "$src"
        assertNotNull "TSK File $fileName empty changed" "$tsk"
        assertEquals "Change Timestamp of $fileName does not match" "$src" "$tsk"
        
	src=$(jq '.created // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.created // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty created" "$src"
        assertNotNull "TSK File $fileName empty created" "$tsk"
        assertEquals "Creation Timestamp of $fileName does not match" "$src" "$tsk"
        
	src=$(jq '.sha256 // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.sha256 // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty sha256" "$src"
        assertNotNull "TSK File $fileName empty sha256" "$tsk"
        assertEquals "Sha256 Checksum of $fileName does not match" "$src" "$tsk"
}


# deleted file
testFILE-DELETED(){
	fileName="delfile.txt"
	fileSrcObj=$(jq '.files."delfile.txt" // empty' <<< "$srcJson")
	delInode=$(jq --arg f "$fileName" '.files | select( .[$f] ) | .[$f].inode  // empty' <<< "$srcJson" | tr -d '"')
	fileTskObj=$(jq --arg reg_exp ".*${delInode}.*" '.files | with_entries(select(.key | match($reg_exp))) | [.[]|select(length > 0)][0] // empty' <<< "$tskJson")
	assertNotNull "Source File $fileName not found" "$fileSrcObj"
        assertNotNull "TSK File $fileName not found" "$fileTskObj"

	[[ -z "$fileSrcObj" ]] && startSkipping
        [[ -z "$fileTskObj" ]] && startSkipping

        src=$(jq '.filepath // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.filepath // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty filepath" "$src"
        assertNotNull "TSK File $fileName empty filepath" "$tsk"
        assertEquals "Path of $fileName does not match" "$src" "$tsk"

        src=$(jq '.inode // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.inode // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty inode" "$src"
        assertNotNull "TSK File $fileName empty inode" "$tsk"
        assertEquals "Inode of $fileName does not match" "$src" "$tsk"

        src=$(jq '.file_type // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.file_type // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty file_type" "$src"
        assertNotNull "TSK File $fileName empty file_type" "$tsk"
        assertEquals "Type of $fileName does not match" "$src" "$tsk"

        src=$(jq '.mode // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.mode // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty mode" "$src"
        assertNotNull "TSK File $fileName empty mode" "$tsk"
        assertEquals "Mode of $fileName does not match" "$src" "$tsk"

        src=$(jq '.size // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.size // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty size" "$src"
        assertNotNull "TSK File $fileName empty size" "$tsk"
        assertEquals "Size of $fileName does not match" "$src" "$tsk"

        src=$(jq '.modified // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.modified // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty modified" "$src"
        assertNotNull "TSK File $fileName empty modified" "$tsk"
        assertEquals "Modified Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.accessed // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.accessed // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty accessed" "$src"
        assertNotNull "TSK File $fileName empty accessed" "$tsk"
        assertEquals "Accessed Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.changed // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.changed // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty changed" "$src"
        assertNotNull "TSK File $fileName empty changed" "$tsk"
        assertEquals "Change Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.created // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.created // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty created" "$src"
        assertNotNull "TSK File $fileName empty created" "$tsk"
        assertEquals "Creation Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.sha256 // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.sha256 // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty sha256" "$src"
        assertNotNull "TSK File $fileName empty sha256" "$tsk"
        assertEquals "Sha256 Checksum of $fileName does not match" "$src" "$tsk"
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
	srcJson=$(jq . < ${baseDir}/data/zfssrc.json | tr '[:upper:]' '[:lower:]' | sed -e 's/ null / "" /g')
	tskJson=$(jq . < ${baseDir}/data/zfstsk.json | tr '[:upper:]' '[:lower:]' | sed -e 's/ null / "" /g')
	
	# back to original directory
	cd $myDir
}

oneTimeTearDown() {
  PATH=$originalPath
}

# Load and run shUnit2.
. ${baseDir}/shunit2/shunit2
