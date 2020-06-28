#!/bin/bash
# Partitionseigenschaften in .json exportieren
function get_crtime() {
    for target in "${@}"; do
        inode=$(stat -c '%i' "${target}")
        fs=$(df  --output=source "${target}"  | tail -1)
	crtimehex=$(debugfs -R 'stat <'"${inode}"'>' "${fs}" 2>/dev/null | grep crtime:  | grep -oP '0x\w{8}')
	crtime=$(echo $(($crtimehex)))
	printf "%i" "${crtime}"
    done
}

filepath=$1
name=$(stat --format=%n $filepath | egrep -o [^/]+$)
inode=$(stat --format=%i $filepath)
uid=$(stat --format=%u $filepath)
gid=$(stat --format=%g $filepath)
mode=$(stat --format=%A $filepath)
size=$(stat --format=%s $filepath)
link_num=$(stat --format=%h $filepath)
modified=$(stat --format=%Y $filepath)
accessed=$(stat --format=%X $filepath)
changed=$(stat --format=%Z $filepath)
created=$(get_crtime $filepath)
size=$(stat --format=%s $filepath)
blocks=$(stat --format=%b $filepath) 

cat <<myEOF > ${name}.json
{ 
   "filepath" : "$filepath"
   "name" : "$name"
   "inode" : "$inode"
   "uid" : "$uid"
   "gid" : "$gid"
   "mode" : "$mode"
   "size" : "$size"
   "link_num : "$link_num"
   "modified" : "$modified"
   "accessed" : "$accessed"
   "changed" : "$changed"
   "created : "$created"
   "size" : "$size"
   "blocks: "$blocks"
}
myEOF

exit 0
