#!/bin/bash
# test for NTFS Filesystem.

# non pooling File System

baseDir=".."

# basic tests
testJQ(){
	result=$(jq --version)
	rtrn=$?
	assertEquals  'Error calling jq' 0 ${rtrn}
	assertContains 'jq version 1.5*' "$result" "jq-1.5"
}

testJSONOBJCOUNT(){
	src=$(jq '. | length' <<< "$srcJson")
	tsk=$(jq '. | length' <<< "$tskJson")
	assertEquals 'Json object count is not equal' "$src" "$tsk"
}

# partition information
testPARTITION(){
	src=$(jq '.partition.part_type' <<< "$srcJson" | tr '[:upper:]' '[:lower:]' | tr -d '"')
	tsk=$(jq '.partition.part_type' <<< "$tskJson" | tr '[:upper:]' '[:lower:]' | tr -d '"')
	assertEquals 'Type of partition does not match' "$src" "$tsk"

	src=$(jq '.partition.unit_size' <<< "$srcJson" | tr '[:upper:]' '[:lower:]' | tr -d '"')
	tsk=$(jq '.partition.unit_size' <<< "$tskJson" | tr '[:upper:]' '[:lower:]' | tr -d '"')
	assertEquals 'Unit size of partition does not match' "$src" "$tsk"

	src=$(jq '.partition.first_unit' <<< "$srcJson" | tr '[:upper:]' '[:lower:]' | tr -d '"')
	tsk=$(jq '.partition.first_unit' <<< "$tskJson" | tr '[:upper:]' '[:lower:]' | tr -d '"')
	assertEquals 'First unit of partition does not match' "$src" "$tsk"

	# only available in mmls?
	#testPARTITION-DESCRIPTION(){
	#src=$(jq '.partition.description' <<< "$srcJson")
	#tsk=$(jq '.partition.description' <<< "$tskJson")
	#assertEquals 'Description of partition does not match' "$src" "$tsk"
}

# filesystem information
testFILESYSTEM(){
	src=$(jq '.fs.type' <<< "$srcJson" | tr '[:upper:]' '[:lower:]' | tr -d '"')
	tsk=$(jq '.fs.type' <<< "$tskJson" | tr '[:upper:]' '[:lower:]' | tr -d '"')
	assertEquals 'Type of filesystem does not match' "$src" "$tsk"

	src=$(jq '.fs.name' <<< "$srcJson" | tr '[:upper:]' '[:lower:]' | tr -d '"')
	tsk=$(jq '.fs.name' <<< "$tskJson" | tr '[:upper:]' '[:lower:]' | tr -d '"')
	assertEquals 'Name of fs does not match' "$src" "$tsk"

	src=$(jq '.fs.id' <<< "$srcJson" | tr '[:upper:]' '[:lower:]' | tr -d '"')
	tsk=$(jq '.fs.id' <<< "$tskJson" | tr '[:upper:]' '[:lower:]' | tr -d '"')
	assertEquals 'ID of fs does not match' "$src" "$tsk"
	
	src=$(jq '.fs.os' <<< "$srcJson" | tr '[:upper:]' '[:lower:]' | tr -d '"')
	tsk=$(jq '.fs.os' <<< "$tskJson" | tr '[:upper:]' '[:lower:]' | tr -d '"')
	assertEquals 'Source OS of fs does not match' "$src" "$tsk"
}

# file

testFILE-ZEROLENGTH(){
        fileName='file.0'
        fileSrcObj=$(jq --arg sel "$fileName" '.files."$sel"' <<< "$srcJson")
        fileTskObj=$(jq --arg sel "$fileName" '.files."$sel"' <<< "$tskJson")
        assertNotNull "File $fileName not found" "$fileTskObj"
        
	[[ -z "$fileTskObj" ]] && startSkipping

        src=$(jq '.filepath' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.filepath' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Path of file does not match' "$src" "$tsk"

        src=$(jq '.inode' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.inode' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Inode of file does not match' "$src" "$tsk"

        src=$(jq '.file_type' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.file_type' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Type of file does not match' "$src" "$tsk"

        src=$(jq '.mode' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.mode' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Mode of file does not match' "$src" "$tsk"

        src=$(jq '.size' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.size' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Size of file does not match' "$src" "$tsk"

        src=$(jq '.modified' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.modified' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Modified Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.accessed' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.accessed' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Accessed Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.changed' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.changed' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Change Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.created' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.created' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Creation Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.sha256' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.sha256' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Sha256 Checksum of file does not match' "$src" "$tsk"
}

# binary file
testFILE-BINARY() {
        fileName='file.binary'
        fileSrcObj=$(jq --arg sel "$fileName" '.files."$sel"' <<< "$srcJson")
        fileTskObj=$(jq --arg sel "$fileName" '.files."$sel"' <<< "$tskJson")
        assertNotNull "File $fileNames not found" "$fileTskObj"

        [[ -z "$fileTskObj" ]] && startSkipping

        src=$(jq '.filepath' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.filepath' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Path of file does not match' "$src" "$tsk"

        src=$(jq '.inode' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.inode' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Inode of file does not match' "$src" "$tsk"

        src=$(jq '.file_type' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.file_type' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Type of file does not match' "$src" "$tsk"

        src=$(jq '.mode' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.mode' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Mode of file does not match' "$src" "$tsk"

        src=$(jq '.size' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.size' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Size of file does not match' "$src" "$tsk"

        src=$(jq '.modified' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.modified' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Modified Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.accessed' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.accessed' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Accessed Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.changed' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.changed' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Change Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.created' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.created' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Creation Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.sha256' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.sha256' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Sha256 Checksum of file does not match' "$src" "$tsk"
}

# text file
testFILE-TEXT(){
        fileName='file.txt'
        fileSrcObj=$(jq --arg sel "$fileName" '.files."$sel"' <<< "$srcJson")
        fileTskObj=$(jq --arg sel "$fileName" '.files."$sel"' <<< "$tskJson")
        assertNotNull "File $fileNames not found" "$fileTskObj"

        [[ -z "$fileTskObj" ]] && startSkipping

        src=$(jq '.filepath' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.filepath' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Path of file does not match' "$src" "$tsk"

        src=$(jq '.inode' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.inode' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Inode of file does not match' "$src" "$tsk"

        src=$(jq '.file_type' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.file_type' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Type of file does not match' "$src" "$tsk"

        src=$(jq '.mode' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.mode' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Mode of file does not match' "$src" "$tsk"

        src=$(jq '.size' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.size' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Size of file does not match' "$src" "$tsk"

        src=$(jq '.modified' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.modified' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Modified Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.accessed' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.accessed' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Accessed Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.changed' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.changed' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Change Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.created' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.created' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Creation Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.sha256' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.sha256' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Sha256 Checksum of file does not match' "$src" "$tsk"
}

# subdirectory
testFILE-SUBDIR(){
        fileName='subdir'
        fileSrcObj=$(jq --arg sel "$fileName" '.files."$sel"' <<< "$srcJson")
        fileTskObj=$(jq --arg sel "$fileName" '.files."$sel"' <<< "$tskJson")
        assertNotNull "File $fileNames not found" "$fileTskObj"

        [[ -z "$fileTskObj" ]] && startSkipping

        src=$(jq '.filepath' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.filepath' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Path of file does not match' "$src" "$tsk"

        src=$(jq '.inode' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.inode' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Inode of file does not match' "$src" "$tsk"

        src=$(jq '.file_type' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.file_type' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Type of file does not match' "$src" "$tsk"

        src=$(jq '.mode' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.mode' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Mode of file does not match' "$src" "$tsk"

        src=$(jq '.size' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.size' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Size of file does not match' "$src" "$tsk"

        src=$(jq '.modified' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.modified' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Modified Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.accessed' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.accessed' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Accessed Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.changed' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.changed' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Change Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.created' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.created' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Creation Timestamp of file does not match' "$src" "$tsk"
}

# file in subdirectory
testFILE-SUBFILE(){
        fileName='file2.txt'
        fileSrcObj=$(jq --arg sel "$fileName" '.files."$sel"' <<< "$srcJson")
        fileTskObj=$(jq --arg sel "$fileName" '.files."$sel"' <<< "$tskJson")
        assertNotNull "File $fileNames not found" "$fileTskObj"

        [[ -z "$fileTskObj" ]] && startSkipping

        src=$(jq '.filepath' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.filepath' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Path of file does not match' "$src" "$tsk"

        src=$(jq '.inode' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.inode' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Inode of file does not match' "$src" "$tsk"

        src=$(jq '.file_type' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.file_type' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Type of file does not match' "$src" "$tsk"

        src=$(jq '.mode' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.mode' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Mode of file does not match' "$src" "$tsk"

        src=$(jq '.size' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.size' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Size of file does not match' "$src" "$tsk"

        src=$(jq '.modified' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.modified' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Modified Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.accessed' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.accessed' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Accessed Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.changed' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.changed' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Change Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.created' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.created' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Creation Timestamp of file does not match' "$src" "$tsk"
        
	src=$(jq '.sha256' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.sha256' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
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
        assertNotNull "File $fileName not found" "$fileTskObj"

        [[ -z "$fileTskObj" ]] && startSkipping

        src=$(jq '.filepath' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.filepath' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Path of file does not match' "$src" "$tsk"

        src=$(jq '.inode' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.inode' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Inode of file does not match' "$src" "$tsk"

	src=$(jq '.file_type' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.file_type' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Type of file does not match' "$src" "$tsk"

        src=$(jq '.mode' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.mode' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Mode of file does not match' "$src" "$tsk"

        src=$(jq '.size' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.size' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Size of file does not match' "$src" "$tsk"

        src=$(jq '.modified' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.modified' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Modified Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.accessed' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.accessed' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Accessed Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.changed' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.changed' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Change Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.created' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        tsk=$(jq '.created' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Creation Timestamp of file does not match' "$src" "$tsk"
        
	src=$(jq '.sha256' <<< "$fileSrcObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
	tsk=$(jq '.sha256' <<< "$fileTskObj" | tr '[:upper:]' '[:lower:]' | tr -d '"')
        assertEquals 'Sha256 Checksum of file does not match' "$src" "$tsk"
}

oneTimeSetUp() {
	originalPath=$PATH
	PATH=$PWD:$PATH
	# Variables
	myDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"	
	genMachineName="generator_win"
	tskMachineName="sleuthkit_49"
	srcScript="ntfs_generate.ps1"
	tskScript="ntfs_analyze.sh"
#<<COMMENT
	# generate VM Names
	vmGenMachineName=$(echo "$genMachineName" | sed 's/_/-/g')
	vmTskMachineName=$(echo "$tskMachineName" | sed 's/_/-/g')
	
	# find vagrant machines
	vagrantStatus=$(vagrant global-status)
	#Generator is not manageb by vagrant
	tskMachineId=$(echo "$vagrantStatus" | grep $tskMachineName | cut -d " " -f 1) 
	if [[ -z "$tskMachineId" ]]
	then
		echo "Vagrant machine $tskMachineName not found"
	       	exit 1
	fi
	
	# eventually shutdown generator machine to mount vmdk
  	genMachineState=$(vboxmanage list runningvms | grep "$vmGenMachineName" | wc -l)
	[[ "$genMachineState" == 1 ]] && $(shutdown_vm.sh "$vmGenMachineName"; sleep 60s)
	
	# generate .vmdk
	vmdkFilePath="${baseDir}/data/ntfs.vmdk"
	vmdkFileId=$(vboxmanage list hdds | grep -B4 "$vmdkFilePath" | grep -oP '(?<=^UUID\: ).*' | sed 's/^ *//g')

	if [[ -n "$vmdkFileId" ]] 
	then
		vboxmanage storageattach $vmGenMachineName --storagectl 'SATA' --port 2 --type hdd --medium none
		vboxmanage closemedium disk ${vmdkFileId} --delete
		echo "removed $vmdkFilePath from VirtualBox"
	fi

	if [[ -e "$vmdkFilePath" ]]
	then
		rm $vmdkFilePath  
		echo "File $vmdkFilePath deleted"
	fi

	vboxmanage createmedium disk --filename ${vmdkFilePath} --size 10000 --format VMDK

	if [[ $? -ne 0 ]] 
	then
		echo "Unable to create $vmdkFilePath"
		exit 1
	fi
	
	# connect to Storagecontroller
	vboxmanage storageattach $vmGenMachineName --storagectl 'SATA' --port 2 --type hdd --medium $vmdkFilePath --comment 'Evidence Drive' --nonrotational on
	
	# bring up generator machine
	startup_vm.sh $vmGenMachineName
	echo "Wait 30s for generator machine to boot..."
	sleep 30s

	# generate evidence
	cd ${baseDir}/bolt/
	bolt script run ${myDir}/${srcScript} --targets "$vmGenMachineName"

	# shutdown generator machine
	shutdown_vm.sh $vmGenMachineName
	echo "Wait 45 Second for generator machine to shut down..."
	sleep 45s

	# eventually bring tsk machine up
	tskMachineState=$( echo "$vagrantStatus" | grep $tskMachineName | sed -e 's/ \+/;/g' | cut -d ";" -f 4)
       [[ "$tskMachineState" == running ]] || vagrant up "$tskMachineId"

	# analyze evidence
	bolt script run ${myDir}/${tskScript} --targets "$vmTskMachineName"

	# shutdown tsk machine
	vagrant halt "$tskMachineId"


#COMMENT
	# load .json files in variables
	#fromdos ${baseDir}/data/ntfssrc.json # file comes from a Windows system	
	srcJson=$(jq . < ${baseDir}/data/ntfssrc.json)
	tskJson=$(jq . < ${baseDir}/data/ntfstsk.json)

	# back to original directory
	cd $myDir
}

oneTimeTearDown() {
	PATH=$originalPath
}

# Load and run shUnit2.
. ${baseDir}/shunit2/shunit2
