#!/bin/bash
# test for Ext4 Filesystem.

# non pooling File System

baseDir=".."
<<COMMENT
# basic tests
no_testJQ(){
	result=$(jq --version)
	rtrn=$?
	assertEquals  'Error calling jq' 0 ${rtrn}
	assertContains 'jq version 1.5*' "$result" "jq-1.5"
}

no_testJSONOBJCOUNT(){
	src=$(jq '. | length // empty' <<< "$srcJson")
	tsk=$(jq '. | length // empty' <<< "$tskJson")
        assertNotNull "Source File $fileName no objects" "$src"
        assertNotNull "TSK File $fileName no objects" "$tsk"
	assertEquals 'Json object count is not equal' "$src" "$tsk"
}
COMMENT
# partition information
testPARTITION(){
	src=$(jq '.partition.part_type // empty' <<< "$srcJson" | tr -d '"')
	tsk=$(jq '.partition.part_type // empty' <<< "$tskJson" | tr -d '"')
	assertNotNull "Source File $fileName empty part_type" "$src"
        assertNotNull "TSK File $fileName empty part_type" "$tsk"
	assertEquals 'Type of partition does not match' "$src" "$tsk"

	src=$(jq '.partition.unit_size // empty' <<< "$srcJson" | tr -d '"')
	tsk=$(jq '.partition.unit_size // empty' <<< "$tskJson" | tr -d '"')
	assertNotNull "Source File $fileName empty unit_size" "$src"
        assertNotNull "TSK File $fileName empty unit_size" "$tsk"
	assertEquals 'Unit size of partition does not match' "$src" "$tsk"

	src=$(jq '.partition.first_unit // empty' <<< "$srcJson"| tr -d '"')
	tsk=$(jq '.partition.first_unit // empty' <<< "$tskJson"| tr -d '"')
	assertNotNull "Source File $fileName empty first_unit" "$src"
        assertNotNull "TSK File $fileName empty first_unit" "$tsk"
	assertEquals 'Type of partition does not match' "$src" "$tsk"
	assertEquals 'First unit of partition does not match' "$src" "$tsk"
}

# filesystem information
testFILESYSTEM(){
	src=$(jq '.fs.type // empty' <<< "$srcJson"| tr -d '"')
	tsk=$(jq '.fs.type // empty' <<< "$tskJson"| tr -d '"')
	assertNotNull "Source File $fileName empty fs.type" "$src"
        assertNotNull "TSK File $fileName empty fs.type" "$tsk"
	assertEquals 'Type of filesystem does not match' "$src" "$tsk"

	src=$(jq '.fs.name // empty' <<< "$srcJson"| tr -d '"')
	tsk=$(jq '.fs.name // empty' <<< "$tskJson"| tr -d '"')
	assertNotNull "Source File $fileName empty fs.name" "$src"
        assertNotNull "TSK File $fileName empty fs.name" "$tsk"
	assertEquals 'Name of fs does not match' "$src" "$tsk"

	src=$(jq '.fs.id // empty' <<< "$srcJson"| tr -d '"')
	tsk=$(jq '.fs.id // empty' <<< "$tskJson"| tr -d '"')
	assertNotNull "Source File $fileName empty fs.id" "$src"
        assertNotNull "TSK File $fileName empty fs.id" "$tsk"
	assertEquals 'ID of fs does not match' "$src" "$tsk"
	
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

	# shutdown generator
	vagrant halt $genMachineId

        # eventually bring tsk machine up
        tskMachineState=$( echo "$vagrantStatus" | grep $tskMachineName | sed -e 's/ \+/;/g' | cut -d ";" -f 4)
        [[ "$tskMachineState" == running ]] || vagrant up "$tskMachineId"

	# analyze evidence
	bolt script run ${myDir}/${tskScript} --targets "$vmTskMachineName"

	# shutdown tsk machine
	vagrant halt $tskMachineId

#COMMENT
	# load .json files in variables
	srcJson=$(jq . < ${baseDir}/data/ext4src.json | tr '[:upper:]' '[:lower:]' | sed -e 's/ null / "" /g')
	tskJson=$(jq . < ${baseDir}/data/ext4tsk.json | tr '[:upper:]' '[:lower:]' | sed -e 's/ null / "" /g')
	
	# back to original directory
	cd $myDir
}

oneTimeTearDown() {
	PATH=$originalPath
}

# Load and run shUnit2.
. ${baseDir}/shunit2/shunit2
