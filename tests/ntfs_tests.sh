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
INSERT_FILE_TESTS

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
