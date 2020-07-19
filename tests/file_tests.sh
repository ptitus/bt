#!/bin/bash

# Echo provided arguments.
#[ $# -gt 0 ] && echo "#:$# 1:$1 2:$2 3:$3"
srcJson=$(jq . < "$1")
tskJson=$(jq . < "$2")

test_date_cmd() {
  ( date '+%a' >/dev/null 2>&1 )
  local rtrn=$?
  assertTrue "unexpected date error; ${rtrn}" ${rtrn}
}

testFILE-ZEROLENGTH(){
        fileName='file.0'
        fileSrcObj=$(jq --arg sel "$fileName" '.files[] | .[$sel] | select(length > 0)' <<< "$srcJson")
        fileTskObj=$(jq --arg sel "$fileName" '.files[] | .[$sel] | select(length > 0)' <<< "$tskJson")
        assertNotNull "File $fileName not found" "$fileTskObj"
        
	[[ -z "$fileTskObj" ]] && startSkipping

        src=$(jq '.filepath' <<< "$fileSrcObj")
        tsk=$(jq '.filepath' <<< "$fileTskObj")
        assertEquals 'Path of file does not match' "$src" "$tsk"

        src=$(jq '.inode' <<< "$fileSrcObj")
        tsk=$(jq '.inode' <<< "$fileTskObj")
        assertEquals 'Inode of file does not match' "$src" "$tsk"

        src=$(jq '.file_type' <<< "$fileSrcObj")
        tsk=$(jq '.file_type' <<< "$fileTskObj")
        assertEquals 'Type of file does not match' "$src" "$tsk"

        src=$(jq '.mode' <<< "$fileSrcObj")
        tsk=$(jq '.mode' <<< "$fileTskObj")
        assertEquals 'Mode of file does not match' "$src" "$tsk"

        src=$(jq '.size' <<< "$fileSrcObj")
        tsk=$(jq '.size' <<< "$fileTskObj")
        assertEquals 'Size of file does not match' "$src" "$tsk"

        src=$(jq '.modified' <<< "$fileSrcObj")
        tsk=$(jq '.modified' <<< "$fileTskObj")
        assertEquals 'Modified Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.accessed' <<< "$fileSrcObj")
        tsk=$(jq '.accessed' <<< "$fileTskObj")
        assertEquals 'Accessed Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.changed' <<< "$fileSrcObj")
        tsk=$(jq '.changed' <<< "$fileTskObj")
        assertEquals 'Change Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.created' <<< "$fileSrcObj")
        tsk=$(jq '.created' <<< "$fileTskObj")
        assertEquals 'Creation Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.sha256' <<< "$fileSrcObj")
        tsk=$(jq '.sha256' <<< "$fileTskObj")
        assertEquals 'Sha256 Checksum of file does not match' "$src" "$tsk"
}

# binary file
testFILE-BINARY() {
        fileName='file.binary'
        fileSrcObj=$(jq --arg sel "$fileName" '.files[] | .[$sel] | select(length > 0)' <<< "$srcJson")
        fileTskObj=$(jq --arg sel "$fileName" '.files[] | .[$sel] | select(length > 0)' <<< "$tskJson")
        assertNotNull "File $fileNames not found" "$fileTskObj"

        [[ -z "$fileTskObj" ]] && startSkipping

        src=$(jq '.filepath' <<< "$fileSrcObj")
        tsk=$(jq '.filepath' <<< "$fileTskObj")
        assertEquals 'Path of file does not match' "$src" "$tsk"

        src=$(jq '.inode' <<< "$fileSrcObj")
        tsk=$(jq '.inode' <<< "$fileTskObj")
        assertEquals 'Inode of file does not match' "$src" "$tsk"

        src=$(jq '.file_type' <<< "$fileSrcObj")
        tsk=$(jq '.file_type' <<< "$fileTskObj")
        assertEquals 'Type of file does not match' "$src" "$tsk"

        src=$(jq '.mode' <<< "$fileSrcObj")
        tsk=$(jq '.mode' <<< "$fileTskObj")
        assertEquals 'Mode of file does not match' "$src" "$tsk"

        src=$(jq '.size' <<< "$fileSrcObj")
        tsk=$(jq '.size' <<< "$fileTskObj")
        assertEquals 'Size of file does not match' "$src" "$tsk"

        src=$(jq '.modified' <<< "$fileSrcObj")
        tsk=$(jq '.modified' <<< "$fileTskObj")
        assertEquals 'Modified Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.accessed' <<< "$fileSrcObj")
        tsk=$(jq '.accessed' <<< "$fileTskObj")
        assertEquals 'Accessed Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.changed' <<< "$fileSrcObj")
        tsk=$(jq '.changed' <<< "$fileTskObj")
        assertEquals 'Change Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.created' <<< "$fileSrcObj")
        tsk=$(jq '.created' <<< "$fileTskObj")
        assertEquals 'Creation Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.sha256' <<< "$fileSrcObj")
        tsk=$(jq '.sha256' <<< "$fileTskObj")
        assertEquals 'Sha256 Checksum of file does not match' "$src" "$tsk"
}

# text file
testFILE-TEXT(){
        fileName='file.txt'
        fileSrcObj=$(jq --arg sel "$fileName" '.files[] | .[$sel] | select(length > 0)' <<< "$srcJson")
        fileTskObj=$(jq --arg sel "$fileName" '.files[] | .[$sel] | select(length > 0)' <<< "$tskJson")
        assertNotNull "File $fileNames not found" "$fileTskObj"

        [[ -z "$fileTskObj" ]] && startSkipping

        src=$(jq '.filepath' <<< "$fileSrcObj")
        tsk=$(jq '.filepath' <<< "$fileTskObj")
        assertEquals 'Path of file does not match' "$src" "$tsk"

        src=$(jq '.inode' <<< "$fileSrcObj")
        tsk=$(jq '.inode' <<< "$fileTskObj")
        assertEquals 'Inode of file does not match' "$src" "$tsk"

        src=$(jq '.file_type' <<< "$fileSrcObj")
        tsk=$(jq '.file_type' <<< "$fileTskObj")
        assertEquals 'Type of file does not match' "$src" "$tsk"

        src=$(jq '.mode' <<< "$fileSrcObj")
        tsk=$(jq '.mode' <<< "$fileTskObj")
        assertEquals 'Mode of file does not match' "$src" "$tsk"

        src=$(jq '.size' <<< "$fileSrcObj")
        tsk=$(jq '.size' <<< "$fileTskObj")
        assertEquals 'Size of file does not match' "$src" "$tsk"

        src=$(jq '.modified' <<< "$fileSrcObj")
        tsk=$(jq '.modified' <<< "$fileTskObj")
        assertEquals 'Modified Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.accessed' <<< "$fileSrcObj")
        tsk=$(jq '.accessed' <<< "$fileTskObj")
        assertEquals 'Accessed Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.changed' <<< "$fileSrcObj")
        tsk=$(jq '.changed' <<< "$fileTskObj")
        assertEquals 'Change Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.created' <<< "$fileSrcObj")
        tsk=$(jq '.created' <<< "$fileTskObj")
        assertEquals 'Creation Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.sha256' <<< "$fileSrcObj")
        tsk=$(jq '.sha256' <<< "$fileTskObj")
        assertEquals 'Sha256 Checksum of file does not match' "$src" "$tsk"
}

# subdirectory
testFILE-SUBDIR(){
        fileName='subdir'
        fileSrcObj=$(jq --arg sel "$fileName" '.files[] | .[$sel] | select(length > 0)' <<< "$srcJson")
        fileTskObj=$(jq --arg sel "$fileName" '.files[] | .[$sel] | select(length > 0)' <<< "$tskJson")
        assertNotNull "File $fileNames not found" "$fileTskObj"

        [[ -z "$fileTskObj" ]] && startSkipping

        src=$(jq '.filepath' <<< "$fileSrcObj")
        tsk=$(jq '.filepath' <<< "$fileTskObj")
        assertEquals 'Path of file does not match' "$src" "$tsk"

        src=$(jq '.inode' <<< "$fileSrcObj")
        tsk=$(jq '.inode' <<< "$fileTskObj")
        assertEquals 'Inode of file does not match' "$src" "$tsk"

        src=$(jq '.file_type' <<< "$fileSrcObj")
        tsk=$(jq '.file_type' <<< "$fileTskObj")
        assertEquals 'Type of file does not match' "$src" "$tsk"

        src=$(jq '.mode' <<< "$fileSrcObj")
        tsk=$(jq '.mode' <<< "$fileTskObj")
        assertEquals 'Mode of file does not match' "$src" "$tsk"

        src=$(jq '.size' <<< "$fileSrcObj")
        tsk=$(jq '.size' <<< "$fileTskObj")
        assertEquals 'Size of file does not match' "$src" "$tsk"

        src=$(jq '.modified' <<< "$fileSrcObj")
        tsk=$(jq '.modified' <<< "$fileTskObj")
        assertEquals 'Modified Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.accessed' <<< "$fileSrcObj")
        tsk=$(jq '.accessed' <<< "$fileTskObj")
        assertEquals 'Accessed Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.changed' <<< "$fileSrcObj")
        tsk=$(jq '.changed' <<< "$fileTskObj")
        assertEquals 'Change Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.created' <<< "$fileSrcObj")
        tsk=$(jq '.created' <<< "$fileTskObj")
        assertEquals 'Creation Timestamp of file does not match' "$src" "$tsk"
}

# file in subdirectory
testFILE-SUBFILE(){
        fileName='file2.txt'
        fileSrcObj=$(jq --arg sel "$fileName" '.files[] | .[$sel] | select(length > 0)' <<< "$srcJson")
        fileTskObj=$(jq --arg sel "$fileName" '.files[] | .[$sel] | select(length > 0)' <<< "$tskJson")
        assertNotNull "File $fileNames not found" "$fileTskObj"

        [[ -z "$fileTskObj" ]] && startSkipping

        src=$(jq '.filepath' <<< "$fileSrcObj")
        tsk=$(jq '.filepath' <<< "$fileTskObj")
        assertEquals 'Path of file does not match' "$src" "$tsk"

        src=$(jq '.inode' <<< "$fileSrcObj")
        tsk=$(jq '.inode' <<< "$fileTskObj")
        assertEquals 'Inode of file does not match' "$src" "$tsk"

        src=$(jq '.file_type' <<< "$fileSrcObj")
        tsk=$(jq '.file_type' <<< "$fileTskObj")
        assertEquals 'Type of file does not match' "$src" "$tsk"

        src=$(jq '.mode' <<< "$fileSrcObj")
        tsk=$(jq '.mode' <<< "$fileTskObj")
        assertEquals 'Mode of file does not match' "$src" "$tsk"

        src=$(jq '.size' <<< "$fileSrcObj")
        tsk=$(jq '.size' <<< "$fileTskObj")
        assertEquals 'Size of file does not match' "$src" "$tsk"

        src=$(jq '.modified' <<< "$fileSrcObj")
        tsk=$(jq '.modified' <<< "$fileTskObj")
        assertEquals 'Modified Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.accessed' <<< "$fileSrcObj")
        tsk=$(jq '.accessed' <<< "$fileTskObj")
        assertEquals 'Accessed Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.changed' <<< "$fileSrcObj")
        tsk=$(jq '.changed' <<< "$fileTskObj")
        assertEquals 'Change Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.created' <<< "$fileSrcObj")
        tsk=$(jq '.created' <<< "$fileTskObj")
        assertEquals 'Creation Timestamp of file does not match' "$src" "$tsk"
        
	src=$(jq '.sha256' <<< "$fileSrcObj")
        tsk=$(jq '.sha256' <<< "$fileTskObj")
        assertEquals 'Sha256 Checksum of file does not match' "$src" "$tsk"
}


# deleted file
testFILE-DELETED(){
	fileName="delfile.txt"
        fileSrcObj=$(jq --arg sel "$fileName" '.files[] | .[$sel] | select(length > 0)' <<< "$srcJson")
	delInode=$(jq --arg f "$fileName" '.files[] | select( .[$f] ) | .[$f].inode ' <<< "$srcJson" | tr -d '"')
	orphanKey=$(jq --arg reg_exp ".*${delInode}.*" '.files[] | with_entries(select(.key | match($reg_exp))) | select(length > 0) | keys [] ' <<< "$tskJson" | tr -d '"')
	fileTskObj=$(jq --arg sel "$orphanKey" '.files[] | .[$sel] | select(length > 0)' <<< "$tskJson")
        assertNotNull "File $fileName not found" "$fileTskObj"

        [[ -z "$fileTskObj" ]] && startSkipping

        src=$(jq '.filepath' <<< "$fileSrcObj")
        tsk=$(jq '.filepath' <<< "$fileTskObj")
        assertEquals 'Path of file does not match' "$src" "$tsk"

        src=$(jq '.inode' <<< "$fileSrcObj")
        tsk=$(jq '.inode' <<< "$fileTskObj")
        assertEquals 'Inode of file does not match' "$src" "$tsk"

	src=$(jq '.file_type' <<< "$fileSrcObj")
        tsk=$(jq '.file_type' <<< "$fileTskObj")
        assertEquals 'Type of file does not match' "$src" "$tsk"

        src=$(jq '.mode' <<< "$fileSrcObj")
        tsk=$(jq '.mode' <<< "$fileTskObj")
        assertEquals 'Mode of file does not match' "$src" "$tsk"

        src=$(jq '.size' <<< "$fileSrcObj")
        tsk=$(jq '.size' <<< "$fileTskObj")
        assertEquals 'Size of file does not match' "$src" "$tsk"

        src=$(jq '.modified' <<< "$fileSrcObj")
        tsk=$(jq '.modified' <<< "$fileTskObj")
        assertEquals 'Modified Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.accessed' <<< "$fileSrcObj")
        tsk=$(jq '.accessed' <<< "$fileTskObj")
        assertEquals 'Accessed Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.changed' <<< "$fileSrcObj")
        tsk=$(jq '.changed' <<< "$fileTskObj")
        assertEquals 'Change Timestamp of file does not match' "$src" "$tsk"

        src=$(jq '.created' <<< "$fileSrcObj")
        tsk=$(jq '.created' <<< "$fileTskObj")
        assertEquals 'Creation Timestamp of file does not match' "$src" "$tsk"
        
	src=$(jq '.sha256' <<< "$fileSrcObj")
	tsk=$(jq '.sha256' <<< "$fileTskObj")
        assertEquals 'Sha256 Checksum of file does not match' "$src" "$tsk"
}
# Eat all command-line arguments before calling shunit2.
shift $#
. ../shunit2/shunit2