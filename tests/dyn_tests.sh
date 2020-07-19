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
	assertEquals 'Json object count is not equal' "$src" "$tsk"
}

# file system information
testFILESYSTEM-TYPE(){
	src=$(jq '.fs.type' <<< "$srcJson")
	tsk=$(jq '.fs.type' <<< "$tskJson")
	assertEquals 'Type of filesystem does not match' "$src" "$tsk"
}

testFILESYSTEM-LABEL(){
	src=$(jq '.fs.label' <<< "$srcJson")
	tsk=$(jq '.fs.label' <<< "$tskJson")
	assertEquals 'Label of fs does not match' "$src" "$tsk"
}

testFILESYSTEM-ID(){
	src=$(jq '.fs.id' <<< "$srcJson")
	tsk=$(jq '.fs.id' <<< "$tskJson")
	assertEquals 'ID of fs does not match' "$src" "$tsk"
}

testFILESYSTEM-DEVICECOUNT(){
	src=$(jq '.fs.device_count' <<< "$srcJson")
	tsk=$(jq '.fs.device_count' <<< "$tskJson")
	assertEquals 'Device count of fs does not match' "$src" "$tsk"
}

# files

testFILE-ZEROLENGTH(){
        fileName='file.0'
        fileSrcObj=$(jq --arg sel "$fileName" '.files[] | .[$sel] | select(length > 0)' <<< "$srcJson")
        fileTskObj=$(jq --arg sel "$fileName" '.files[] | .[$sel] | select(length > 0)' <<< "$tskJson")
        assertNotNull "File $fileName not found" "$fileTskObj"
        
	[[ -z "$fileTskObj" ]] && startSkipping

        src=$(jq '.filepath' <<< "$fileSrcObj")
        tsk=$(jq '.filepath' <<< "$fileTskObj")
        assertEquals 'Path of file does not match' "$src" "$tsk"

        src=$(jq '.inode' <<< "$fileSrcObj")
        tsk=$(jq '.inode' <<< "$fileTskObj")
        assertEquals 'Inode of file does not match' "$src" "$tsk"

        src=$(jq '.file_type' <<< "$fileSrcObj")
        tsk=$(jq '.file_type' <<< "$fileTskObj")
        assertEquals 'Type of file does not match' "$src" "$tsk"

        src=$(jq '.mode' <<< "$fileSrcObj")
        tsk=$(jq '.mode' <<< "$fileTskObj")
        assertEquals 'Mode of file does not match' "$src" "$tsk"

        src=$(jq '.size' <<< "$fileSrcObj")
        tsk=$(jq '.size' <<< "$fileTskObj")
        assertEquals 'Size of file does not match' "$src" "$tsk"

        src=$(jq '.modified' <<< "$fileSrcObj")
        tsk=$(jq '.modified' <<< "$fileTskObj")
        assertEquals 'Modified Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.accessed' <<< "$fileSrcObj")
        tsk=$(jq '.accessed' <<< "$fileTskObj")
        assertEquals 'Accessed Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.changed' <<< "$fileSrcObj")
        tsk=$(jq '.changed' <<< "$fileTskObj")
        assertEquals 'Change Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.created' <<< "$fileSrcObj")
        tsk=$(jq '.created' <<< "$fileTskObj")
        assertEquals 'Creation Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.sha256' <<< "$fileSrcObj")
        tsk=$(jq '.sha256' <<< "$fileTskObj")
        assertEquals 'Sha256 Checksum of file does not match' "$src" "$tsk"
}

# binary file
testFILE-BINARY() {
        fileName='file.binary'
        fileSrcObj=$(jq --arg sel "$fileName" '.files[] | .[$sel] | select(length > 0)' <<< "$srcJson")
        fileTskObj=$(jq --arg sel "$fileName" '.files[] | .[$sel] | select(length > 0)' <<< "$tskJson")
        assertNotNull "File $fileNames not found" "$fileTskObj"

        [[ -z "$fileTskObj" ]] && startSkipping

        src=$(jq '.filepath' <<< "$fileSrcObj")
        tsk=$(jq '.filepath' <<< "$fileTskObj")
        assertEquals 'Path of file does not match' "$src" "$tsk"

        src=$(jq '.inode' <<< "$fileSrcObj")
        tsk=$(jq '.inode' <<< "$fileTskObj")
        assertEquals 'Inode of file does not match' "$src" "$tsk"

        src=$(jq '.file_type' <<< "$fileSrcObj")
        tsk=$(jq '.file_type' <<< "$fileTskObj")
        assertEquals 'Type of file does not match' "$src" "$tsk"

        src=$(jq '.mode' <<< "$fileSrcObj")
        tsk=$(jq '.mode' <<< "$fileTskObj")
        assertEquals 'Mode of file does not match' "$src" "$tsk"

        src=$(jq '.size' <<< "$fileSrcObj")
        tsk=$(jq '.size' <<< "$fileTskObj")
        assertEquals 'Size of file does not match' "$src" "$tsk"

        src=$(jq '.modified' <<< "$fileSrcObj")
        tsk=$(jq '.modified' <<< "$fileTskObj")
        assertEquals 'Modified Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.accessed' <<< "$fileSrcObj")
        tsk=$(jq '.accessed' <<< "$fileTskObj")
        assertEquals 'Accessed Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.changed' <<< "$fileSrcObj")
        tsk=$(jq '.changed' <<< "$fileTskObj")
        assertEquals 'Change Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.created' <<< "$fileSrcObj")
        tsk=$(jq '.created' <<< "$fileTskObj")
        assertEquals 'Creation Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.sha256' <<< "$fileSrcObj")
        tsk=$(jq '.sha256' <<< "$fileTskObj")
        assertEquals 'Sha256 Checksum of file does not match' "$src" "$tsk"
}

# text file
testFILE-TEXT(){
        fileName='file.txt'
        fileSrcObj=$(jq --arg sel "$fileName" '.files[] | .[$sel] | select(length > 0)' <<< "$srcJson")
        fileTskObj=$(jq --arg sel "$fileName" '.files[] | .[$sel] | select(length > 0)' <<< "$tskJson")
        assertNotNull "File $fileNames not found" "$fileTskObj"

        [[ -z "$fileTskObj" ]] && startSkipping

        src=$(jq '.filepath' <<< "$fileSrcObj")
        tsk=$(jq '.filepath' <<< "$fileTskObj")
        assertEquals 'Path of file does not match' "$src" "$tsk"

        src=$(jq '.inode' <<< "$fileSrcObj")
        tsk=$(jq '.inode' <<< "$fileTskObj")
        assertEquals 'Inode of file does not match' "$src" "$tsk"

        src=$(jq '.file_type' <<< "$fileSrcObj")
        tsk=$(jq '.file_type' <<< "$fileTskObj")
        assertEquals 'Type of file does not match' "$src" "$tsk"

        src=$(jq '.mode' <<< "$fileSrcObj")
        tsk=$(jq '.mode' <<< "$fileTskObj")
        assertEquals 'Mode of file does not match' "$src" "$tsk"

        src=$(jq '.size' <<< "$fileSrcObj")
        tsk=$(jq '.size' <<< "$fileTskObj")
        assertEquals 'Size of file does not match' "$src" "$tsk"

        src=$(jq '.modified' <<< "$fileSrcObj")
        tsk=$(jq '.modified' <<< "$fileTskObj")
        assertEquals 'Modified Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.accessed' <<< "$fileSrcObj")
        tsk=$(jq '.accessed' <<< "$fileTskObj")
        assertEquals 'Accessed Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.changed' <<< "$fileSrcObj")
        tsk=$(jq '.changed' <<< "$fileTskObj")
        assertEquals 'Change Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.created' <<< "$fileSrcObj")
        tsk=$(jq '.created' <<< "$fileTskObj")
        assertEquals 'Creation Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.sha256' <<< "$fileSrcObj")
        tsk=$(jq '.sha256' <<< "$fileTskObj")
        assertEquals 'Sha256 Checksum of file does not match' "$src" "$tsk"
}

# subdirectory
testFILE-SUBDIR(){
        fileName='subdir'
        fileSrcObj=$(jq --arg sel "$fileName" '.files[] | .[$sel] | select(length > 0)' <<< "$srcJson")
        fileTskObj=$(jq --arg sel "$fileName" '.files[] | .[$sel] | select(length > 0)' <<< "$tskJson")
        assertNotNull "File $fileNames not found" "$fileTskObj"

        [[ -z "$fileTskObj" ]] && startSkipping

        src=$(jq '.filepath' <<< "$fileSrcObj")
        tsk=$(jq '.filepath' <<< "$fileTskObj")
        assertEquals 'Path of file does not match' "$src" "$tsk"

        src=$(jq '.inode' <<< "$fileSrcObj")
        tsk=$(jq '.inode' <<< "$fileTskObj")
        assertEquals 'Inode of file does not match' "$src" "$tsk"

        src=$(jq '.file_type' <<< "$fileSrcObj")
        tsk=$(jq '.file_type' <<< "$fileTskObj")
        assertEquals 'Type of file does not match' "$src" "$tsk"

        src=$(jq '.mode' <<< "$fileSrcObj")
        tsk=$(jq '.mode' <<< "$fileTskObj")
        assertEquals 'Mode of file does not match' "$src" "$tsk"

        src=$(jq '.size' <<< "$fileSrcObj")
        tsk=$(jq '.size' <<< "$fileTskObj")
        assertEquals 'Size of file does not match' "$src" "$tsk"

        src=$(jq '.modified' <<< "$fileSrcObj")
        tsk=$(jq '.modified' <<< "$fileTskObj")
        assertEquals 'Modified Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.accessed' <<< "$fileSrcObj")
        tsk=$(jq '.accessed' <<< "$fileTskObj")
        assertEquals 'Accessed Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.changed' <<< "$fileSrcObj")
        tsk=$(jq '.changed' <<< "$fileTskObj")
        assertEquals 'Change Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.created' <<< "$fileSrcObj")
        tsk=$(jq '.created' <<< "$fileTskObj")
        assertEquals 'Creation Timestamp of file does not match' "$src" "$tsk"
}

# file in subdirectory
testFILE-SUBFILE(){
        fileName='file2.txt'
        fileSrcObj=$(jq --arg sel "$fileName" '.files[] | .[$sel] | select(length > 0)' <<< "$srcJson")
        fileTskObj=$(jq --arg sel "$fileName" '.files[] | .[$sel] | select(length > 0)' <<< "$tskJson")
        assertNotNull "File $fileNames not found" "$fileTskObj"

        [[ -z "$fileTskObj" ]] && startSkipping

        src=$(jq '.filepath' <<< "$fileSrcObj")
        tsk=$(jq '.filepath' <<< "$fileTskObj")
        assertEquals 'Path of file does not match' "$src" "$tsk"

        src=$(jq '.inode' <<< "$fileSrcObj")
        tsk=$(jq '.inode' <<< "$fileTskObj")
        assertEquals 'Inode of file does not match' "$src" "$tsk"

        src=$(jq '.file_type' <<< "$fileSrcObj")
        tsk=$(jq '.file_type' <<< "$fileTskObj")
        assertEquals 'Type of file does not match' "$src" "$tsk"

        src=$(jq '.mode' <<< "$fileSrcObj")
        tsk=$(jq '.mode' <<< "$fileTskObj")
        assertEquals 'Mode of file does not match' "$src" "$tsk"

        src=$(jq '.size' <<< "$fileSrcObj")
        tsk=$(jq '.size' <<< "$fileTskObj")
        assertEquals 'Size of file does not match' "$src" "$tsk"

        src=$(jq '.modified' <<< "$fileSrcObj")
        tsk=$(jq '.modified' <<< "$fileTskObj")
        assertEquals 'Modified Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.accessed' <<< "$fileSrcObj")
        tsk=$(jq '.accessed' <<< "$fileTskObj")
        assertEquals 'Accessed Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.changed' <<< "$fileSrcObj")
        tsk=$(jq '.changed' <<< "$fileTskObj")
        assertEquals 'Change Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.created' <<< "$fileSrcObj")
        tsk=$(jq '.created' <<< "$fileTskObj")
        assertEquals 'Creation Timestamp of file does not match' "$src" "$tsk"
        
	src=$(jq '.sha256' <<< "$fileSrcObj")
        tsk=$(jq '.sha256' <<< "$fileTskObj")
        assertEquals 'Sha256 Checksum of file does not match' "$src" "$tsk"
}


# deleted file
testFILE-DELETED(){
	fileName="delfile.txt"
        fileSrcObj=$(jq --arg sel "$fileName" '.files[] | .[$sel] | select(length > 0)' <<< "$srcJson")
	delInode=$(jq --arg f "$fileName" '.files[] | select( .[$f] ) | .[$f].inode ' <<< "$srcJson" | tr -d '"')
	orphanKey=$(jq --arg reg_exp ".*${delInode}.*" '.files[] | with_entries(select(.key | match($reg_exp))) | select(length > 0) | keys [] ' <<< "$tskJson" | tr -d '"')
	fileTskObj=$(jq --arg sel "$orphanKey" '.files[] | .[$sel] | select(length > 0)' <<< "$tskJson")
        assertNotNull "File $fileName not found" "$fileTskObj"

        [[ -z "$fileTskObj" ]] && startSkipping

        src=$(jq '.filepath' <<< "$fileSrcObj")
        tsk=$(jq '.filepath' <<< "$fileTskObj")
        assertEquals 'Path of file does not match' "$src" "$tsk"

        src=$(jq '.inode' <<< "$fileSrcObj")
        tsk=$(jq '.inode' <<< "$fileTskObj")
        assertEquals 'Inode of file does not match' "$src" "$tsk"

	src=$(jq '.file_type' <<< "$fileSrcObj")
        tsk=$(jq '.file_type' <<< "$fileTskObj")
        assertEquals 'Type of file does not match' "$src" "$tsk"

        src=$(jq '.mode' <<< "$fileSrcObj")
        tsk=$(jq '.mode' <<< "$fileTskObj")
        assertEquals 'Mode of file does not match' "$src" "$tsk"

        src=$(jq '.size' <<< "$fileSrcObj")
        tsk=$(jq '.size' <<< "$fileTskObj")
        assertEquals 'Size of file does not match' "$src" "$tsk"

        src=$(jq '.modified' <<< "$fileSrcObj")
        tsk=$(jq '.modified' <<< "$fileTskObj")
        assertEquals 'Modified Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.accessed' <<< "$fileSrcObj")
        tsk=$(jq '.accessed' <<< "$fileTskObj")
        assertEquals 'Accessed Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.changed' <<< "$fileSrcObj")
        tsk=$(jq '.changed' <<< "$fileTskObj")
        assertEquals 'Change Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.created' <<< "$fileSrcObj")
        tsk=$(jq '.created' <<< "$fileTskObj")
        assertEquals 'Creation Timestamp of file does not match' "$src" "$tsk"
        
	src=$(jq '.sha256' <<< "$fileSrcObj")
	tsk=$(jq '.sha256' <<< "$fileTskObj")
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
	
	# generate evidence
	cd ${baseDir}/bolt/
	bolt script run ${myDir}/${srcScript} --targets "$vmGenMachineName"

	# analyze evidence
	bolt script run ${myDir}/${tskScript} --targets "$vmTskMachineName"

	# load .json files in variables
	srcJson=$(jq . < ${baseDir}/data/zfssrc.json)
	tskJson=$(jq . < ${baseDir}/data/zfstsk.json)
	
	# back to original directory
	cd $myDir
}

oneTimeTearDown() {
  PATH=$originalPath
}

# Load and run shUnit2.
. ${baseDir}/shunit2/shunit2
