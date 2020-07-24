#!/bin/bash
# test for btrfs Filesystem.

# pooling File System

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

# file system information
testFILESYSTEM-TYPE(){
	src=$(jq '.fs.type' <<< "$srcJson")
	tsk=$(jq '.fs.type' <<< "$tskJson")
	assertEquals 'Type of filesystem does not match' "$src" "$tsk"

	src=$(jq '.fs.label' <<< "$srcJson")
	tsk=$(jq '.fs.label' <<< "$tskJson")
	assertEquals 'Label of fs does not match' "$src" "$tsk"

	src=$(jq '.fs.id' <<< "$srcJson")
	tsk=$(jq '.fs.id' <<< "$tskJson")
	assertEquals 'ID of fs does not match' "$src" "$tsk"

	src=$(jq '.fs.device_count' <<< "$srcJson")
	tsk=$(jq '.fs.device_count' <<< "$tskJson")
	assertEquals 'Device count of fs does not match' "$src" "$tsk"
}

# files
INSERT_FILE_TESTS

oneTimeSetUp() {
	originalPath=$PATH
	PATH=$PWD:$PATH
	# Variables
	myDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"	
	genMachineName="generator_lnx"
	tskMachineName="sleuthkit_fkiecad"
	srcScript="btrfs_generate.sh"
	tskScript="btrfs_analyze.sh"

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
	srcJson=$(jq . < ${baseDir}/data/btrfssrc.json)
	tskJson=$(jq . < ${baseDir}/data/btrfstsk.json)
	
	# back to original directory
	cd $myDir
}

oneTimeTearDown() {
  PATH=$originalPath
}

# Load and run shUnit2.
. ${baseDir}/shunit2/shunit2
