#!/bin/bash
# istat für eine Datei aufrufen und Ergebnis in .json exportieren

imagefile='/home/user/evd002.vmdk'
offset='2048'
inode='13'
istat_result=$(istat -o $offset $imagefile $inode)
#echo "$istat_result"
name=$(echo $imagefile | egrep -o [^/]+$)
inode=$(echo $istat_result | grep -oP '(?<=inode: )[[:digit:]]{1,}')
uid=$(echo $istat_result | grep -oP '(?<=uid / gid: )[[:digit:]]{1,}')
#gid=$(stat --format=%g $filepath)
gid=$(echo $istat_result | grep 'uid / gid: ' | grep -oP '(?<=/ )[[:digit:]]{1,}')
mode=$(echo $istat_result | grep -oP '(?<=mode: ).{10}')
size=$(echo $istat_result | grep -oP '(?<=size: )[[:digit:]]{1,}')
link_num=$(echo $istat_result | grep -oP '(?<=num of links: )[[:digit:]]{1,}')
modified=$(date "+%s" -d "$(echo $istat_result | grep -oP '(?<=File Modified: ).{19}')")
accessed=$(date "+%s" -d "$(echo $istat_result | grep -oP '(?<=Accessed: ).{19}')")
changed=$(date "+%s" -d "$(echo $istat_result | grep -oP '(?<=Inode Modified: ).{19}')")
created=$(date "+%s" -d "$(echo $istat_result | grep -oP '(?<=File Created: ).{19}')")

cat <<myEOF > ${name}.json
{ 
   "filepath" : "$imagefile",
   "name" : "$name",
   "inode" : "$inode",
   "uid" : "$uid",
   "gid" : "$gid",
   "mode" : "$mode",
   "size" : "$size",
   "link_num : "$link_num",
   "modified" : "$modified",
   "accessed" : "$accessed",
   "changed" : "$changed",
   "created : "$created",
   "size" : "$size"
}
myEOF

exit 0
