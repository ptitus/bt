#!/bin/bash
# Pertitionseigenschaften in .json exportieren
devpath=$1
fdisk_result=$(fdisk -l $1)
part_type=$(echo $fdisk_result | grep -oP '(?<=Festplattenbezeichnungstyp: )[[:alpha:]]{3}')
unit_size=$(echo $fdisk_result | grep -oP '(?<= = )[[:digit:]]{1,10}')
#part=$(echo "$fdisk_result" | grep -oP '^\/[[:word:]]*\/[[:word:]]*')
first_unit=$(echo "$fdisk_result" | grep -oP '^\/.*' | grep -oP '(?<= )[[:digit:]]+(?=[[:blank:]]+[[:digit:]]+[[:blank:]]+[[:digit:]]+[[:blank:]]+[[:digit:]]+)')
cat <<myEOF > partition.json
{
	"part_type":"$part_type",
	"unit_size":"$unit_size",
	"first_unit":"$first_unit"
}
myEOF

exit 0
