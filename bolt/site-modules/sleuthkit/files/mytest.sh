#!/bin/bash
# test for Ext4 Filesystem.

# non pooling File System

#File System Category

baseDir="../../../.."

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
	tVar="walking"
	if [ ${tVar} == running ]
	then
		echo "$tVar"
	fi
}

oneTimeTearDown() {
  PATH=$originalPath
}

# Load and run shUnit2.
. ${baseDir}/shunit2/shunit2
