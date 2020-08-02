#!/bin/bash
# test for apfs Filesystem.

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
	assertNotNull "Source File $fileName no objects" "$src"
        assertNotNull "TSK File $fileName no objects" "$tsk"
	assertEquals 'Json object count is not equal' "$src" "$tsk"
}

# partition informatio
testPARTITION(){
	src=$(jq '.partition.type' <<< "$srcJson" | tr -d '"')
	tsk=$(jq '.partition.type' <<< "$tskJson" | tr -d '"')
	assertNotNull "Source File $fileName empty partition.type" "$src"
        assertNotNull "TSK File $fileName empty partition.type" "$tsk"
	assertEquals 'Type of partition does not match' "$src" "$tsk"

	src=$(jq '.partition.unit_size' <<< "$srcJson" | tr -d '"')
	tsk=$(jq '.partition.unit_size' <<< "$tskJson" | tr -d '"')
	assertNotNull "Source File $fileName empty partition.unit_size" "$src"
        assertNotNull "TSK File $fileName empty partition.unit_size" "$tsk"
	assertEquals 'Partition unit Size does not match' "$src" "$tsk"

	src=$(jq '.partition.first_unit' <<< "$srcJson" | tr -d '"')
	tsk=$(jq '.partition.first_unit' <<< "$tskJson" | tr -d '"')
	assertNotNull "Source File $fileName emty partition.first_unit" "$src"
        assertNotNull "TSK File $fileName empty partition.first_unit" "$tsk"
	assertEquals 'First unit od Partition does not match' "$src" "$tsk"
}

# Filesystem Information
testFILESYSTEM(){
	src=$(jq '.fs.type' <<< "$srcJson" | tr '[:upper:]' '[:lower:]' | tr -d '"')
	tsk=$(jq '.fs.type' <<< "$tskJson" | tr '[:upper:]' '[:lower:]' | tr -d '"')
	assertNotNull "Source File $fileName emty fs.type" "$src"
        assertNotNull "TSK File $fileName empty fs.type" "$tsk"
	assertEquals 'Type of filesystem does not match' "$src" "$tsk"

	src=$(jq '.fs.label' <<< "$srcJson" | tr '[:upper:]' '[:lower:]' | tr -d '"')
	tsk=$(jq '.fs.label' <<< "$tskJson" | tr '[:upper:]' '[:lower:]' | tr -d '"')
	assertNotNull "Source File $fileName emty fs.label" "$src"
        assertNotNull "TSK File $fileName empty fs.label" "$tsk"
	assertEquals 'Label of fs does not match' "$src" "$tsk"

	src=$(jq '.fs.id' <<< "$srcJson" | tr '[:upper:]' '[:lower:]' | tr -d '"')
	tsk=$(jq '.fs.id' <<< "$tskJson" | tr '[:upper:]' '[:lower:]' | tr -d '"')
	assertNotNull "Source File $fileName emty fs.id" "$src"
        assertNotNull "TSK File $fileName empty fs.id" "$tsk"
	assertEquals 'ID of fs does not match' "$src" "$tsk"
}

# files
INSERT_FILE_TESTS

oneTimeSetUp() {
	originalPath=$PATH
	PATH=$PWD:$PATH
	# Variables
	myDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"	
	genMachineName="generator_mac"
	genMachineIP="192.168.168.82"
	tskMachineName="sleuthkit_49"
	srcScript="apfs_generate.sh"
	tskScript="apfs_analyze.sh"

	# generate VM Names
	vmGenMachineName=$(echo "$genMachineName" | sed 's/_/-/g')
	vmTskMachineName=$(echo "$tskMachineName" | sed 's/_/-/g')
	
	# find vagrant machines
	vagrantStatus=$(vagrant global-status)
	#Genrator is not managed by vagrant
	tskMachineId=$(echo "$vagrantStatus" | grep $tskMachineName | cut -d " " -f 1) 
	if [[ -z "$tskMachineId" ]]
	then
		echo "Vagrant machine $tskMachineName not found"
	       	exit 1
	fi

        #check if generator machine is running
	if ping -c 2 $genMachineIP &> /dev/null
	then
		echo "Connected Generator Machine under $genMachineIP"
	else
		echo "Generator Machine IP $genMachineIP not reachable, cancelling Script!"
		exit
	fi
	
	# generate evidence
      	cd ${baseDir}/bolt/
	bolt script run ${myDir}/${srcScript} --targets "$vmGenMachineName"

	# copy Image and Json - public key must be in place on generator machine
	scp "user@${genMachineIP}:/Users/user/apfsimg/apfs.dmg" "${baseDir}/data"
	scp "user@${genMachineIP}:/Users/user/apfssrc.json" "${baseDir}/data"

	# eventually bring tsk machine up
        tskMachineState=$( echo "$vagrantStatus" | grep $tskMachineName | sed -e 's/ \+/;/g' | cut -d ";" -f 4)
        [[ "$tskMachineState" == running ]] || vagrant up "$tskMachineId"

	# analyze evidence
	bolt script run ${myDir}/${tskScript} --targets "$vmTskMachineName"

	# shutdown tsk machine
	vagrant halt $tskMachineId

	# load .json files in variables
	srcJson=$(jq . < ${baseDir}/data/apfssrc.json | tr '[:upper:]' '[:lower:]' | sed -e 's/ null / "" /g')
	tskJson=$(jq . < ${baseDir}/data/apfstsk.json | tr '[:upper:]' '[:lower:]' | sed -e 's/ null / "" /g')
	
	# back to original directory
	cd $myDir
}

oneTimeTearDown() {
  PATH=$originalPath
}

# Load and run shUnit2.
. ${baseDir}/shunit2/shunit2
