#!/bin/bash
# istat für eine Datei aufrufen und Ergebnis in .json exportieren
function get_part_type () {
	typestring=$(echo "$mmls_result" | grep -oP '^[[:word:]]{3,}(?= Partition Table)') 
	case "$typestring" in
		GUID) 
			echo "gpt"
			;;
		DOS)
			echo "dos"
			;;
		*)
			echo "unknown"
			;;

	esac	
}


# $1 ist das zu untersuchende Image, erforderlich
imagefile=$1

#$2 ist der Name der Ausgabedatei, default ist mmls.json
filename="${2-'mmls.json'}"

#$3 ist ggf. der Slot der Partition, default ist 000
slot="${3-'000'}"

mmls_result=$(mmls $imagefile )
part_type=$(get_part_type "$mmls_result")
unit_size=$(echo "$mmls_result" | grep -oP '(?<=Units are in )[[:digit:]]+(?=-)')
if [[ "$part_type" == 'dos' ]]; then
	slot="000:${slot}"
fi
echo $slot
part_line=$(echo "$mmls_result" | grep -P "^[[:digit:]]{3}:  ${slot} " | sed -e 's/ \+/;/g')
echo $part_line
first_unit=$(echo "$part_line" | awk 'BEGIN { FS = ";" } ; { print $3 }' | sed 's/^0*//')
description=$(echo "$part_line" | awk 'BEGIN { FS = ";" } ; { print $6 }') 

cat <<myEOF > $filename
{ 
   "part_type" : "$part_type",
   "unit_size" : "$unit_size",
   "first_unit" : "$first_unit",
   "description" :"$description"
}
myEOF

echo "$filename"
cat $filename

exit 0
