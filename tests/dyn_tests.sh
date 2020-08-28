#!/bin/bash
# test for ReFS Filesystem.

# pooling File System

baseDir=".."

# basic tests
<<COMMENT
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
        assertNotNull "TSK File $fileName empty unit_sizee" "$tsk"
	assertEquals 'Unit size of partition does not match' "$src" "$tsk"

	src=$(jq '.partition.first_unit // empty' <<< "$srcJson" | tr -d '"')
	tsk=$(jq '.partition.first_unit // empty' <<< "$tskJson" | tr -d '"')
	assertNotNull "Source File $fileName empty first_unit" "$src"
        assertNotNull "TSK File $fileName empty first_unit" "$tsk"
	assertEquals 'First unit of partition does not match' "$src" "$tsk"
}

# filesystem information
testFILESYSTEM(){
	src=$(jq '.fs.type // empty' <<< "$srcJson" | tr -d '"')
	tsk=$(jq '.fs.type // empty' <<< "$tskJson" | tr -d '"')
	assertNotNull "Source File $fileName empty fs.type" "$src"
        assertNotNull "TSK File $fileName empty fs.type" "$tsk"
	assertEquals 'Type of filesystem does not match' "$src" "$tsk"

	src=$(jq '.fs.name // empty' <<< "$srcJson" | tr -d '"')
	tsk=$(jq '.fs.name // empty' <<< "$tskJson" | tr -d '"')
	assertNotNull "Source File $fileName empty fs.name" "$src"
        assertNotNull "TSK File $fileName empty fs.name" "$tsk"
	assertEquals 'Name of fs does not match' "$src" "$tsk"

	src=$(jq '.fs.id // empty' <<< "$srcJson" | tr -d '"')
	tsk=$(jq '.fs.id // empty' <<< "$tskJson" | tr -d '"')
	assertNotNull "Source File $fileName empty fs.id" "$src"
        assertNotNull "TSK File $fileName empty fs.id" "$tsk"
	assertEquals 'ID of fs does not match' "$src" "$tsk"
}

# file

testFILE-ZEROLENGTH(){
        fileName='file.0'
        fileSrcObj=$(jq '.files."file.0" // empty' <<< "$srcJson")
        fileTskObj=$(jq '.files."file.0" // empty' <<< "$tskJson")

        assertNotNull "Source File $fileName not found" "$fileSrcObj"
        assertNotNull "TSK File $fileName not found" "$fileTskObj"

	[[ -z "$fileSrcObj" ]] && startSkipping
        [[ -z "$fileTskObj" ]] && startSkipping

        src=$(jq '.filepath // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.filepath // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty filepath" "$src"
        assertNotNull "TSK File $fileName empty filepath" "$tsk"
        assertEquals "Path of $fileName does not match" "$src" "$tsk"

        src=$(jq '.inode // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.inode // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty inode" "$src"
        assertNotNull "TSK File $fileName empty inode" "$tsk"
        assertEquals "Inode of $fileName does not match" "$src" "$tsk"

        src=$(jq '.file_type // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.file_type // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty file_type" "$src"
        assertNotNull "TSK File $fileName empty file_type" "$tsk"
        assertEquals "Type of $fileName does not match" "$src" "$tsk"

        src=$(jq '.mode // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.mode // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty mode" "$src"
        assertNotNull "TSK File $fileName empty mode" "$tsk"
        assertEquals "Mode of $fileName does not match" "$src" "$tsk"

        src=$(jq '.size // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.size // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty size" "$src"
        assertNotNull "TSK File $fileName empty size" "$tsk"
        assertEquals "Size of $fileName does not match" "$src" "$tsk"

        src=$(jq '.modified // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.modified // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty modified" "$src"
        assertNotNull "TSK File $fileName empty modified" "$tsk"
        assertEquals "Modified Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.accessed // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.accessed // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty accessed" "$src"
        assertNotNull "TSK File $fileName empty accessed" "$tsk"
        assertEquals "Accessed Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.changed // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.changed // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty changed" "$src"
        assertNotNull "TSK File $fileName empty changed" "$tsk"
        assertEquals "Change Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.created // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.created // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty created" "$src"
        assertNotNull "TSK File $fileName empty created" "$tsk"
        assertEquals "Creation Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.sha256 // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.sha256 // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty sha256" "$src"
        assertNotNull "TSK File $fileName empty sha256" "$tsk"
        assertEquals "Sha256 Checksum of $fileName does not match" "$src" "$tsk"
}

# binary file
testFILE-BINARY() {
        fileName='file.binary'
        fileSrcObj=$(jq '.files."file.binary" // empty' <<< "$srcJson")
        fileTskObj=$(jq '.files."file.binary" // empty' <<< "$tskJson")

        assertNotNull "Source File $fileName not found" "$fileSrcObj"
        assertNotNull "TSK File $fileName not found" "$fileTskObj"

	[[ -z "$fileSrcObj" ]] && startSkipping
        [[ -z "$fileTskObj" ]] && startSkipping

        src=$(jq '.filepath // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.filepath // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty filepath" "$src"
        assertNotNull "TSK File $fileName empty filepath" "$tsk"
        assertEquals "Path of $fileName does not match" "$src" "$tsk"

        src=$(jq '.inode // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.inode // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty inode" "$src"
        assertNotNull "TSK File $fileName empty inode" "$tsk"
        assertEquals "Inode of $fileName does not match" "$src" "$tsk"

        src=$(jq '.file_type // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.file_type // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty file_type" "$src"
        assertNotNull "TSK File $fileName empty file_type" "$tsk"
        assertEquals "Type of $fileName does not match" "$src" "$tsk"

        src=$(jq '.mode // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.mode // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty mode" "$src"
        assertNotNull "TSK File $fileName empty mode" "$tsk"
        assertEquals "Mode of $fileName does not match" "$src" "$tsk"

        src=$(jq '.size // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.size // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty size" "$src"
        assertNotNull "TSK File $fileName empty size" "$tsk"
        assertEquals "Size of $fileName does not match" "$src" "$tsk"

        src=$(jq '.modified // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.modified // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty modified" "$src"
        assertNotNull "TSK File $fileName empty modified" "$tsk"
        assertEquals "Modified Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.accessed // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.accessed // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty accessed" "$src"
        assertNotNull "TSK File $fileName empty accessed" "$tsk"
        assertEquals "Accessed Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.changed // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.changed // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty changed" "$src"
        assertNotNull "TSK File $fileName empty changed" "$tsk"
        assertEquals "Change Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.created // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.created // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty created" "$src"
        assertNotNull "TSK File $fileName empty created" "$tsk"
        assertEquals "Creation Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.sha256 // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.sha256 // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty sha256" "$src"
        assertNotNull "TSK File $fileName empty sha256" "$tsk"
        assertEquals "Sha256 Checksum of $fileName does not match" "$src" "$tsk"
}

# text file
testFILE-TEXT(){
        fileName='file.txt'
        fileSrcObj=$(jq '.files."file.txt" // empty' <<< "$srcJson")
        fileTskObj=$(jq '.files."file.txt" // empty' <<< "$tskJson")
        
	assertNotNull "Source File $fileName not found" "$fileSrcObj"
        assertNotNull "TSK File $fileName not found" "$fileTskObj"

	[[ -z "$fileSrcObj" ]] && startSkipping
        [[ -z "$fileTskObj" ]] && startSkipping

        src=$(jq '.filepath // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.filepath // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty filepath" "$src"
        assertNotNull "TSK File $fileName empty filepath" "$tsk"
        assertEquals "Path of $fileName does not match" "$src" "$tsk"

        src=$(jq '.inode // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.inode // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty inode" "$src"
        assertNotNull "TSK File $fileName empty inode" "$tsk"
        assertEquals "Inode of $fileName does not match" "$src" "$tsk"

        src=$(jq '.file_type // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.file_type // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty file_type" "$src"
        assertNotNull "TSK File $fileName empty file_type" "$tsk"
        assertEquals "Type of $fileName does not match" "$src" "$tsk"

        src=$(jq '.mode // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.mode // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty mode" "$src"
        assertNotNull "TSK File $fileName empty mode" "$tsk"
        assertEquals "Mode of $fileName does not match" "$src" "$tsk"

        src=$(jq '.size // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.size // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty size" "$src"
        assertNotNull "TSK File $fileName empty size" "$tsk"
        assertEquals "Size of $fileName does not match" "$src" "$tsk"

        src=$(jq '.modified // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.modified // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty modified" "$src"
        assertNotNull "TSK File $fileName empty modified" "$tsk"
        assertEquals "Modified Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.accessed // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.accessed // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty accessed" "$src"
        assertNotNull "TSK File $fileName empty accessed" "$tsk"
        assertEquals "Accessed Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.changed // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.changed // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty changed" "$src"
        assertNotNull "TSK File $fileName empty changed" "$tsk"
        assertEquals "Change Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.created // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.created // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty created" "$src"
        assertNotNull "TSK File $fileName empty created" "$tsk"
        assertEquals "Creation Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.sha256 // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.sha256 // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty sha256" "$src"
        assertNotNull "TSK File $fileName empty sha256" "$tsk"
        assertEquals "Sha256 Checksum of $fileName does not match" "$src" "$tsk"
}

# subdirectory
testFILE-SUBDIR(){
	fileName='subdir'
	fileSrcObj=$(jq '.files."subdir" // empty' <<< "$srcJson")
	fileTskObj=$(jq '.files."subdir" // empty' <<< "$tskJson")
	
	assertNotNull "Source File $fileName not found" "$fileSrcObj"
	assertNotNull "TSK File $fileName not found" "$fileTskObj"

	[[ -z "$fileSrcObj" ]] && startSkipping
        [[ -z "$fileTskObj" ]] && startSkipping
	

        src=$(jq '.filepath // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.filepath // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty filepath" "$src"
        assertNotNull "TSK File $fileName empty filepath" "$tsk"
        assertEquals "Path of $fileName does not match" "$src" "$tsk"

        src=$(jq '.inode // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.inode // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty inode" "$src"
        assertNotNull "TSK File $fileName empty inode" "$tsk"
        assertEquals "Inode of $fileName does not match" "$src" "$tsk"

        src=$(jq '.file_type // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.file_type // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty file_type" "$src"
        assertNotNull "TSK File $fileName empty file_type" "$tsk"
        assertEquals "Type of $fileName does not match" "$src" "$tsk"

        src=$(jq '.mode // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.mode // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty mode" "$src"
        assertNotNull "TSK File $fileName empty mode" "$tsk"
        assertEquals "Mode of $fileName does not match" "$src" "$tsk"

        #subdir has no size to compare

        src=$(jq '.modified // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.modified // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty modified" "$src"
        assertNotNull "TSK File $fileName empty modified" "$tsk"
        assertEquals "Modified Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.accessed // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.accessed // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty accessed" "$src"
        assertNotNull "TSK File $fileName empty accessed" "$tsk"
        assertEquals "Accessed Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.changed // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.changed // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty changed" "$src"
        assertNotNull "TSK File $fileName empty changed" "$tsk"
        assertEquals "Change Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.created // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.created // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty created" "$src"
        assertNotNull "TSK File $fileName empty created" "$tsk"
        assertEquals "Creation Timestamp of $fileName does not match" "$src" "$tsk"

	#subdir has no content to hash
}

# file in subdirectory
testFILE-SUBFILE(){
        fileName='file2.txt'
        fileSrcObj=$(jq '.files."file2.txt" // empty' <<< "$srcJson")
        fileTskObj=$(jq '.files."file2.txt" // empty' <<< "$tskJson")

	assertNotNull "Source File $fileName not found" "$fileSrcObj"
        assertNotNull "TSK File $fileName not found" "$fileTskObj"

	[[ -z "$fileSrcObj" ]] && startSkipping
        [[ -z "$fileTskObj" ]] && startSkipping

        src=$(jq '.filepath // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.filepath // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty filepath" "$src"
        assertNotNull "TSK File $fileName empty filepath" "$tsk"
        assertEquals "Path of $fileName does not match" "$src" "$tsk"

        src=$(jq '.inode // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.inode // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty inode" "$src"
        assertNotNull "TSK File $fileName empty inode" "$tsk"
        assertEquals "Inode of $fileName does not match" "$src" "$tsk"

        src=$(jq '.file_type // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.file_type // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty file_type" "$src"
        assertNotNull "TSK File $fileName empty file_type" "$tsk"
        assertEquals "Type of $fileName does not match" "$src" "$tsk"

        src=$(jq '.mode // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.mode // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty mode" "$src"
        assertNotNull "TSK File $fileName empty mode" "$tsk"
        assertEquals "Mode of $fileName does not match" "$src" "$tsk"

        src=$(jq '.size // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.size // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty size" "$src"
        assertNotNull "TSK File $fileName empty size" "$tsk"
        assertEquals "Size of $fileName does not match" "$src" "$tsk"

        src=$(jq '.modified // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.modified // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty modified" "$src"
        assertNotNull "TSK File $fileName empty modified" "$tsk"
        assertEquals "Modified Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.accessed // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.accessed // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty accessed" "$src"
        assertNotNull "TSK File $fileName empty accessed" "$tsk"
        assertEquals "Accessed Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.changed // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.changed // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty changed" "$src"
        assertNotNull "TSK File $fileName empty changed" "$tsk"
        assertEquals "Change Timestamp of $fileName does not match" "$src" "$tsk"
        
	src=$(jq '.created // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.created // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty created" "$src"
        assertNotNull "TSK File $fileName empty created" "$tsk"
        assertEquals "Creation Timestamp of $fileName does not match" "$src" "$tsk"
        
	src=$(jq '.sha256 // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.sha256 // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty sha256" "$src"
        assertNotNull "TSK File $fileName empty sha256" "$tsk"
        assertEquals "Sha256 Checksum of $fileName does not match" "$src" "$tsk"
}


# deleted file
testFILE-DELETED(){
	fileName="delfile.txt"
	fileSrcObj=$(jq '.files."delfile.txt" // empty' <<< "$srcJson")
	delInode=$(jq --arg f "$fileName" '.files | select( .[$f] ) | .[$f].inode  // empty' <<< "$srcJson" | tr -d '"')
	fileTskObj=$(jq --arg reg_exp ".*${delInode}.*" '.files | with_entries(select(.key | match($reg_exp))) | [.[]|select(length > 0)][0] // empty' <<< "$tskJson")
	assertNotNull "Source File $fileName not found" "$fileSrcObj"
        assertNotNull "TSK File $fileName not found" "$fileTskObj"

	[[ -z "$fileSrcObj" ]] && startSkipping
        [[ -z "$fileTskObj" ]] && startSkipping

        src=$(jq '.filepath // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.filepath // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty filepath" "$src"
        assertNotNull "TSK File $fileName empty filepath" "$tsk"
        assertEquals "Path of $fileName does not match" "$src" "$tsk"

        src=$(jq '.inode // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.inode // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty inode" "$src"
        assertNotNull "TSK File $fileName empty inode" "$tsk"
        assertEquals "Inode of $fileName does not match" "$src" "$tsk"

        src=$(jq '.file_type // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.file_type // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty file_type" "$src"
        assertNotNull "TSK File $fileName empty file_type" "$tsk"
        assertEquals "Type of $fileName does not match" "$src" "$tsk"

        src=$(jq '.mode // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.mode // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty mode" "$src"
        assertNotNull "TSK File $fileName empty mode" "$tsk"
        assertEquals "Mode of $fileName does not match" "$src" "$tsk"

        src=$(jq '.size // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.size // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty size" "$src"
        assertNotNull "TSK File $fileName empty size" "$tsk"
        assertEquals "Size of $fileName does not match" "$src" "$tsk"

        src=$(jq '.modified // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.modified // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty modified" "$src"
        assertNotNull "TSK File $fileName empty modified" "$tsk"
        assertEquals "Modified Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.accessed // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.accessed // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty accessed" "$src"
        assertNotNull "TSK File $fileName empty accessed" "$tsk"
        assertEquals "Accessed Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.changed // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.changed // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty changed" "$src"
        assertNotNull "TSK File $fileName empty changed" "$tsk"
        assertEquals "Change Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.created // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.created // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty created" "$src"
        assertNotNull "TSK File $fileName empty created" "$tsk"
        assertEquals "Creation Timestamp of $fileName does not match" "$src" "$tsk"

        src=$(jq '.sha256 // empty' <<< "$fileSrcObj" | tr -d '"')
        tsk=$(jq '.sha256 // empty' <<< "$fileTskObj" | tr -d '"')
        assertNotNull "Source File $fileName empty sha256" "$src"
        assertNotNull "TSK File $fileName empty sha256" "$tsk"
        assertEquals "Sha256 Checksum of $fileName does not match" "$src" "$tsk"
}

oneTimeSetUp() {
	originalPath=$PATH
	PATH=$PWD:$PATH
	# Variables
	myDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"	
	genMachineName="generator_win"
	tskMachineName="sleuthkit_faui"
	srcScript="refs_generate.ps1"
	tskScript="refs_analyze.sh"
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

        # eventually shutdown generator machine to mount .vmdk
        genMachineState=$( echo "$vagrantStatus" | grep $genMachineName | sed -e 's/ \+/;/g' | cut -d ";" -f 4)
        [[ "$genMachineState" == running ]] && vagrant halt "$genMachineId"

        # generate .vmdk
        vmdkFilePath="${baseDir}/data/refs.vmdk"
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
        vagrant up "$genMachineId"

	# generate evidence
	cd ${baseDir}/bolt/
	bolt script run ${myDir}/${srcScript} --targets "$vmGenMachineName"

	# shutdown generator machine
        vagrant halt $genMachineId

	# eventually bring tsk machine up
	tskMachineState=$( echo "$vagrantStatus" | grep $tskMachineName | sed -e 's/ \+/;/g' | cut -d ";" -f 4)
       [[ "$tskMachineState" == running ]] || vagrant up "$tskMachineId"

	# analyze evidence
	bolt script run ${myDir}/${tskScript} --targets "$vmTskMachineName"

	# shutdown tsk machine
#	vagrant halt "$tskMachineId"


#COMMENT
	# load .json files in variables
	srcJson=$(jq . < ${baseDir}/data/refssrc.json | tr '[:upper:]' '[:lower:]' | sed -e 's/ null / "" /g' )
	tskJson=$(jq . < ${baseDir}/data/refstsk.json | tr '[:upper:]' '[:lower:]' | sed -e 's/ null / "" /g' )

	# back to original directory
	cd $myDir
}

oneTimeTearDown() {
	PATH=$originalPath
}

# Load and run shUnit2.
. ${baseDir}/shunit2/shunit2
