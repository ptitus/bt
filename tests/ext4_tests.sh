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

testJSONOBJCOUNT(){
	src=$(jq '. | length' <<< "$srcJson")
	tsk=$(jq '. | length' <<< "$tskJson")
	assertEquals 'Json object count is not equal' "$src" "$tsk"
}

# partition information
testPARTITION(){
	src=$(jq '.partition.part_type' <<< "$srcJson")
	tsk=$(jq '.partition.part_type' <<< "$tskJson")
	assertEquals 'Type of partition does not match' "$src" "$tsk"

	src=$(jq '.partition.unit_size' <<< "$srcJson")
	tsk=$(jq '.partition.unit_size' <<< "$tskJson")
	assertEquals 'Unit size of partition does not match' "$src" "$tsk"

	src=$(jq '.partition.first_unit' <<< "$srcJson")
	tsk=$(jq '.partition.first_unit' <<< "$tskJson")
	assertEquals 'First unit of partition does not match' "$src" "$tsk"

	# only available in mmls?
	#testPARTITION-DESCRIPTION(){
	#src=$(jq '.partition.description' <<< "$srcJson")
	#tsk=$(jq '.partition.description' <<< "$tskJson")
	#assertEquals 'Description of partition does not match' "$src" "$tsk"
}

# filesystem information
testFILESYSTEM(){
	src=$(jq '.fs.type' <<< "$srcJson")
	tsk=$(jq '.fs.type' <<< "$tskJson")
	assertEquals 'Type of filesystem does not match' "$src" "$tsk"

	src=$(jq '.fs.name' <<< "$srcJson")
	tsk=$(jq '.fs.name' <<< "$tskJson")
	assertEquals 'Name of fs does not match' "$src" "$tsk"

	src=$(jq '.fs.id' <<< "$srcJson")
	tsk=$(jq '.fs.id' <<< "$tskJson")
	assertEquals 'ID of fs does not match' "$src" "$tsk"
	
	src=$(jq '.fs.os' <<< "$srcJson")
	tsk=$(jq '.fs.os' <<< "$tskJson")
	assertEquals 'Source OS of fs does not match' "$src" "$tsk"
}

# file
INSERT_FILE_TESTS

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
