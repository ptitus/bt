#!/bin/bash

# define Variables
myDevice='/dev/sdb'
myPartition='/dev/sdb1'
mountPath='/media/hdd'
resultFile='/media/sf_data/test.json'

# create json files
#  partition information
$(jshon)

# write file
#echo "$myJson" > "$resultFile"


exit 0
