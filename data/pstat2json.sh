#!/bin/bash
# pstat für eine Datei aufrufen und Ergebnis in .json exportieren

# $1 ist das zu untersuchende Image, erforderlich
imagefile=$1

#$2 ist das Offset der Partition mit den APFS Volumes, erforderlich
offset=$2

#$3 ist der Name der Ausgabedatei, default ist pstat.json
filename="${3-'pstat.json'}"

pstat_result=$(pstat -o "$2" "$1")
echo "$pstat_result"
vol_id=$(echo "$pstat_result" | grep -oP '(?<=^\+-\> Volume )[[:word:]-]+')
apsb_nr=$(echo "$pstat_result" | grep -oP '(?<=APSB Block Number: )[[:digit:]]+')

cat <<myEOF > $filename
{ 
   "vol_id" : "$vol_id",
   "apsb_nr" : "$apsb_nr"
}
myEOF

echo "$filename"
cat $filename

exit 0
