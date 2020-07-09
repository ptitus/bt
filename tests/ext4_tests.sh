#!/bin/bash
# test for Ext4 Filesystem.

# non pooling File System

#File System Category

baseDir=".."

testWHOAMI(){
	result=$(whoami)
	rtrn=$?
	assertEquals  'Fehler bei Aufruf von whoami' 0 ${rtrn}
	assertContains 'Ergebnis von whoami' "$result" "peter"
}

oneTimeSetUp() {
	originalPath=$PATH
	PATH=$PWD:$PATH
	# Variables
	basedir="../../../.."
	genMachineName="generator_lnx"
	tskMachineName="sleuthkit_49"
	# find vagrant machines
	vagrantStatus=$(vagrant global-status)
	genMachineId=$(echo "$vagrantStatus" | grep "$genMachineName" | cut -d " " -f 1)  
	if [[ -z "$genMachineId" ]]
	then
		echo "Vagrant machine $genMachineName not found"
		exit 1
	fi
	#[[ -z "$genMachineId" ]] || $(echo "Vagrant machine ${genMachineName} not found"; exit 1)
	tskMachineId=$(echo "$vagrantStatus" | grep $tskMachineName | cut -d " " -f 1) 
	if [[ -z "$tskMachineId" ]]
	then
		echo "Vagrant machine ${tskMachineName} not found"
	       	exit 1
	fi
	# shutdown generator machine to mount vmdk
  	genMachineState=$( echo "$vagrantStatus" | grep $genMachineName | sed -e 's/ \+/;/g' | cut -d ";" -f 4)
	echo "$genMachineState"
	[[ "$genMachineState" == running ]] && vagrant halt "$genMachineId"
	# generate .vmdk
	vmdkFilePath="${baseDir}/data/ext4.vmdk"
	vmdkFileId=$(vboxmanage list hdds | grep -B4 "$vmdkFilePath" | grep -oP '(?<=^UUID\: ).*' | sed 's/^ *//g')
	echo "$vmdkFileId"
	if [[ -n "$vmdkFileId" ]] 
	then
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
}

oneTimeTearDown() {
  PATH=$originalPath
}

# Load and run shUnit2.
. ${baseDir}/shunit2/shunit2
