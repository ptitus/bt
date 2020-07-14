#!/bin/bash

# define Variables
myDevice='/dev/sdb'
myPartition='/dev/sdb1'
mountPath='/media/hdd'
resultFile='/media/sf_data/test.json'

# create json files
#  partition information
#jq -n --arg key0 'test' --arg value0 'testvalue'[3~
jq -n --arg eins 'Test' --arg zwei "Test2" '{erstes: $eins, zweites:$zwei}'


# write file
#echo "$myJson" > "$resultFile"


exit 0
