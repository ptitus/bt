#!/bin/bash
# test for Ext4 Filesystem.

# non pooling File System

#while getopts n option
#do
#	case "${option}"
#	in
#	n) noGenerate=$true;;
#	esac
#done

baseDir=".."

# basic tests
testJQ(){
	result=$(jq --version)
	rtrn=$?
	assertEquals  'Error calling jq' 0 ${rtrn}
	assertContains 'jq version 1.5*' "$result" "jq-1.5"
}

testSRC(){
	result=$(jq '. | length' <<< "$srcJson")
	rtrn=$?
	assertEquals 'Error loading source .json file' 0 ${rtrn}
	assertEquals 'Json object count in source .json file = 3' "$result" "3"
}

testTSK(){
	result=$(jq '. | length' <<< "$srcJson")
	rtrn=$?
	assertEquals 'Error loading sleuthkit(tsk) .json file' 0 ${rtrn}
	assertEquals 'Json object count in tsk .json file = 3' "$result" "3"
}

# partition information
testPARTITION-TYPE(){
	src=$(jq '.partition.part_type' <<< "$srcJson")
	tsk=$(jq '.partition.part_type' <<< "$tskJson")
	assertEquals 'Type of partition does not match' "$src" "$tsk"
}

testPARTITION-UNITSIZE(){
	src=$(jq '.partition.unit_size' <<< "$srcJson")
	tsk=$(jq '.partition.unit_size' <<< "$tskJson")
	assertEquals 'Unit size of partition does not match' "$src" "$tsk"
}

testPARTITION-FIRSTUNIT(){
	src=$(jq '.partition.first_unit' <<< "$srcJson")
	tsk=$(jq '.partition.first_unit' <<< "$tskJson")
	assertEquals 'First unit of partition does not match' "$src" "$tsk"
}

# only available in mmls?
#testPARTITION-DESCRIPTION(){
#	src=$(jq '.partition.description' <<< "$srcJson")
#	tsk=$(jq '.partition.description' <<< "$tskJson")
#	assertEquals 'Description of partition does not match' "$src" "$tsk"
#}

# filesystem information
testFILESYSTEM-TYPE(){
	src=$(jq '.fs.type' <<< "$srcJson")
	tsk=$(jq '.fs.type' <<< "$tskJson")
	assertEquals 'Type of filesystem does not match' "$src" "$tsk"
}

testFILESYSTEM-NAME(){
	src=$(jq '.fs.name' <<< "$srcJson")
	tsk=$(jq '.fs.name' <<< "$tskJson")
	assertEquals 'Name of fs does not match' "$src" "$tsk"
}

testFILESYSTEM-ID(){
	src=$(jq '.fs.id' <<< "$srcJson")
	tsk=$(jq '.fs.id' <<< "$tskJson")
	assertEquals 'ID of fs does not match' "$src" "$tsk"
}

testFILESYSTEM-OS(){
	src=$(jq '.fs.os' <<< "$srcJson")
	tsk=$(jq '.fs.os' <<< "$tskJson")
	assertEquals 'Source OS of fs does not match' "$src" "$tsk"
}

# files
# Zero length file
testFILE-ZEROLENGTH-PATH(){
	src=$(jq '.files[] | select( ."file.0" ) | ."file.0".filepath ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file.0" ) | ."file.0".filepath ' <<< "$tskJson")
	assertEquals 'Path of file does not match' "$src" "$tsk"
}

testFILE-ZEROLENGTH-INODE(){
	src=$(jq '.files[] | select( ."file.0" ) | ."file.0".inode ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file.0" ) | ."file.0".inode ' <<< "$tskJson")
	assertEquals 'Inode of file does not match' "$src" "$tsk"
}

testFILE-ZEROLENGTH-TYPE(){
	src=$(jq '.files[] | select( ."file.0" ) | ."file.0".file_type ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file.0" ) | ."file.0".file_type ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}

testFILE-ZEROLENGTH-MODE(){
	src=$(jq '.files[] | select( ."file.0" ) | ."file.0".mode ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file.0" ) | ."file.0".mode ' <<< "$tskJson")
	assertEquals 'Mode of file does not match' "$src" "$tsk"
}

testFILE-ZEROLENGTH-SIZE(){
	src=$(jq '.files[] | select( ."file.0" ) | ."file.0".size ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file.0" ) | ."file.0".size ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}

testFILE-ZEROLENGTH-MODIFIED(){
	src=$(jq '.files[] | select( ."file.0" ) | ."file.0".modified ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file.0" ) | ."file.0".modified ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}

testFILE-ZEROLENGTH-ACCESSED(){
	src=$(jq '.files[] | select( ."file.0" ) | ."file.0".accessed ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file.0" ) | ."file.0".accessed ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}

testFILE-ZEROLENGTH-CHANGED(){
	src=$(jq '.files[] | select( ."file.0" ) | ."file.0".changed ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file.0" ) | ."file.0".changed ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}

testFILE-ZEROLENGTH-CREATED(){
	src=$(jq '.files[] | select( ."file.0" ) | ."file.0".created ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file.0" ) | ."file.0".created ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}

testFILE-ZEROLENGTH-SHA256(){
	src=$(jq '.files[] | select( ."file.0" ) | ."file.0".sha256 ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file.0" ) | ."file.0".sha256 ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}

# binary file
testFILE-BINARY-PATH(){
	src=$(jq '.files[] | select( ."file.binary" ) | ."file.binary".filepath ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file.binary" ) | ."file.binary".filepath ' <<< "$tskJson")
	assertEquals 'Path of file does not match' "$src" "$tsk"
}

testFILE-BINARY-INODE(){
	src=$(jq '.files[] | select( ."file.binary" ) | ."file.binary".inode ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file.binary" ) | ."file.binary".inode ' <<< "$tskJson")
	assertEquals 'Inode of file does not match' "$src" "$tsk"
}

testFILE-BINARY-TYPE(){
	src=$(jq '.files[] | select( ."file.binary" ) | ."file.binary".file_type ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file.binary" ) | ."file.binary".file_type ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}

testFILE-BINARY-MODE(){
	src=$(jq '.files[] | select( ."file.binary" ) | ."file.binary".mode ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file.binary" ) | ."file.binary".mode ' <<< "$tskJson")
	assertEquals 'Mode of file does not match' "$src" "$tsk"
}

testFILE-BINARY-SIZE(){
	src=$(jq '.files[] | select( ."file.binary" ) | ."file.binary".size ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file.binary" ) | ."file.binary".size ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}

testFILE-BINARY-MODIFIED(){
	src=$(jq '.files[] | select( ."file.binary" ) | ."file.binary".modified ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file.binary" ) | ."file.binary".modified ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}

testFILE-BINARY-ACCESSED(){
	src=$(jq '.files[] | select( ."file.binary" ) | ."file.binary".accessed ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file.binary" ) | ."file.binary".accessed ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}

testFILE-BINARY-CHANGED(){
	src=$(jq '.files[] | select( ."file.binary" ) | ."file.binary".changed ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file.binary" ) | ."file.binary".changed ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}

testFILE-BINARY-CREATED(){
	src=$(jq '.files[] | select( ."file.binary" ) | ."file.binary".created ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file.binary" ) | ."file.binary".created ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}

testFILE-BINARY-SHA256(){
	src=$(jq '.files[] | select( ."file.binary" ) | ."file.binary".sha256 ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file.binary" ) | ."file.binary".sha256 ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}

# text file
testFILE-TEXT-PATH(){
	src=$(jq '.files[] | select( ."file.txt" ) | ."file.txt".filepath ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file.txt" ) | ."file.txt".filepath ' <<< "$tskJson")
	assertEquals 'Path of file does not match' "$src" "$tsk"
}

testFILE-TEXT-INODE(){
	src=$(jq '.files[] | select( ."file.txt" ) | ."file.txt".inode ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file.txt" ) | ."file.txt".inode ' <<< "$tskJson")
	assertEquals 'Inode of file does not match' "$src" "$tsk"
}

testFILE-TEXT-TYPE(){
	src=$(jq '.files[] | select( ."file.txt" ) | ."file.txt".file_type ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file.txt" ) | ."file.txt".file_type ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}

testFILE-TEXT-MODE(){
	src=$(jq '.files[] | select( ."file.txt" ) | ."file.txt".mode ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file.txt" ) | ."file.txt".mode ' <<< "$tskJson")
	assertEquals 'Mode of file does not match' "$src" "$tsk"
}

testFILE-TEXT-SIZE(){
	src=$(jq '.files[] | select( ."file.txt" ) | ."file.txt".size ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file.txt" ) | ."file.txt".size ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}

testFILE-TEXT-MODIFIED(){
	src=$(jq '.files[] | select( ."file.txt" ) | ."file.txt".modified ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file.txt" ) | ."file.txt".modified ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}

testFILE-TEXT-ACCESSED(){
	src=$(jq '.files[] | select( ."file.txt" ) | ."file.txt".accessed ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file.txt" ) | ."file.txt".accessed ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}

testFILE-TEXT-CHANGED(){
	src=$(jq '.files[] | select( ."file.txt" ) | ."file.txt".changed ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file.txt" ) | ."file.txt".changed ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}

testFILE-TEXT-CREATED(){
	src=$(jq '.files[] | select( ."file.txt" ) | ."file.txt".created ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file.txt" ) | ."file.txt".created ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}

testFILE-TEXT-SHA256(){
	src=$(jq '.files[] | select( ."file.txt" ) | ."file.txt".sha256 ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file.txt" ) | ."file.txt".sha256 ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}

# subdirectory
testFILE-SUBDIR-PATH(){
	src=$(jq '.files[] | select( ."subdir" ) | ."subdir".filepath ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."subdir" ) | ."subdir".filepath ' <<< "$tskJson")
	assertEquals 'Path of file does not match' "$src" "$tsk"
}

testFILE-SUBDIR-INODE(){
	src=$(jq '.files[] | select( ."subdir" ) | ."subdir".inode ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."subdir" ) | ."subdir".inode ' <<< "$tskJson")
	assertEquals 'Inode of file does not match' "$src" "$tsk"
}

testFILE-SUBDIR-TYPE(){
	src=$(jq '.files[] | select( ."subdir" ) | ."subdir".file_type ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."subdir" ) | ."subdir".file_type ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}

testFILE-SUBDIR-MODE(){
	src=$(jq '.files[] | select( ."subdir" ) | ."subdir".mode ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."subdir" ) | ."subdir".mode ' <<< "$tskJson")
	assertEquals 'Mode of file does not match' "$src" "$tsk"
}

testFILE-SUBDIR-SIZE(){
	src=$(jq '.files[] | select( ."subdir" ) | ."subdir".size ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."subdir" ) | ."subdir".size ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}

testFILE-SUBDIR-MODIFIED(){
	src=$(jq '.files[] | select( ."subdir" ) | ."subdir".modified ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."subdir" ) | ."subdir".modified ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}

testFILE-SUBDIR-ACCESSED(){
	src=$(jq '.files[] | select( ."subdir" ) | ."subdir".accessed ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."subdir" ) | ."subdir".accessed ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}

testFILE-SUBDIR-CHANGED(){
	src=$(jq '.files[] | select( ."subdir" ) | ."subdir".changed ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."subdir" ) | ."subdir".changed ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}

testFILE-SUBDIR-CREATED(){
	src=$(jq '.files[] | select( ."subdir" ) | ."subdir".created ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."subdir" ) | ."subdir".created ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}

testFILE-SUBDIR-SHA256(){
	src=$(jq '.files[] | select( ."subdir" ) | ."subdir".sha256 ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."subdir" ) | ."subdir".sha256 ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}

# file in file2.txtectory
testFILE-SUBFILE-PATH(){
	src=$(jq '.files[] | select( ."file2.txt" ) | ."file2.txt".filepath ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file2.txt" ) | ."file2.txt".filepath ' <<< "$tskJson")
	assertEquals 'Path of file does not match' "$src" "$tsk"
}

testFILE-SUBFILE-INODE(){
	src=$(jq '.files[] | select( ."file2.txt" ) | ."file2.txt".inode ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file2.txt" ) | ."file2.txt".inode ' <<< "$tskJson")
	assertEquals 'Inode of file does not match' "$src" "$tsk"
}

testFILE-SUBFILE-TYPE(){
	src=$(jq '.files[] | select( ."file2.txt" ) | ."file2.txt".file_type ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file2.txt" ) | ."file2.txt".file_type ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}

testFILE-SUBFILE-MODE(){
	src=$(jq '.files[] | select( ."file2.txt" ) | ."file2.txt".mode ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file2.txt" ) | ."file2.txt".mode ' <<< "$tskJson")
	assertEquals 'Mode of file does not match' "$src" "$tsk"
}

testFILE-SUBFILE-SIZE(){
	src=$(jq '.files[] | select( ."file2.txt" ) | ."file2.txt".size ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file2.txt" ) | ."file2.txt".size ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}

testFILE-SUBFILE-MODIFIED(){
	src=$(jq '.files[] | select( ."file2.txt" ) | ."file2.txt".modified ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file2.txt" ) | ."file2.txt".modified ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}

testFILE-SUBFILE-ACCESSED(){
	src=$(jq '.files[] | select( ."file2.txt" ) | ."file2.txt".accessed ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file2.txt" ) | ."file2.txt".accessed ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}

testFILE-SUBFILE-CHANGED(){
	src=$(jq '.files[] | select( ."file2.txt" ) | ."file2.txt".changed ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file2.txt" ) | ."file2.txt".changed ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}

testFILE-SUBFILE-CREATED(){
	src=$(jq '.files[] | select( ."file2.txt" ) | ."file2.txt".created ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file2.txt" ) | ."file2.txt".created ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}

testFILE-SUBFILE-SHA256(){
	src=$(jq '.files[] | select( ."file2.txt" ) | ."file2.txt".sha256 ' <<< "$srcJson")
	tsk=$(jq '.files[] | select( ."file2.txt" ) | ."file2.txt".sha256 ' <<< "$tskJson")
	assertEquals 'Type of file does not match' "$src" "$tsk"
}


oneTimeSetUp() {
	originalPath=$PATH
	PATH=$PWD:$PATH
	# Variables
	myDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"	
	genMachineName="generator_lnx"
	tskMachineName="sleuthkit_49"
	srcScript="ext4_generate.sh"
	tskScript="ext4_analyze.sh"
#<<COMMENT
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
	
	# eventually shutdown generator machine to mount vmdk
  	genMachineState=$( echo "$vagrantStatus" | grep $genMachineName | sed -e 's/ \+/;/g' | cut -d ";" -f 4)
	[[ "$genMachineState" == running ]] && vagrant halt "$genMachineId"
	
	# generate .vmdk
	vmdkFilePath="${baseDir}/data/ext4.vmdk"
	vmdkFileId=$(vboxmanage list hdds | grep -B4 "$vmdkFilePath" | grep -oP '(?<=^UUID\: ).*' | sed 's/^ *//g')
	if [[ -n "$vmdkFileId" ]] 
	then
		vboxmanage storageattach $vmGenMachineName --storagectl 'SATA Controller' --port 2 --type hdd --medium none
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
	vboxmanage storageattach $vmGenMachineName --storagectl 'SATA Controller' --port 2 --type hdd --medium $vmdkFilePath --comment 'Evidence Drive' --nonrotational on
	
	# bring up generator machine
	vagrant up $genMachineId

	# generate evidence
	cd ${baseDir}/bolt/
	bolt script run ${myDir}/${srcScript} --targets "$vmGenMachineName"

	# analyze evidence
	bolt script run ${myDir}/${tskScript} --targets "$vmTskMachineName"
#COMMENT
	# load .json files in variables
	srcJson=$(jq . < ${baseDir}/data/ext4src.json)
	tskJson=$(jq . < ${baseDir}/data/ext4tsk.json)
	
	# back to original directory
	cd $myDir
}

oneTimeTearDown() {
  PATH=$originalPath
}

# Load and run shUnit2.
. ${baseDir}/shunit2/shunit2
