#!/bin/bash
# Dateisystemeigenschaften in .json exportieren
file_result=$(file -sL $1)
os=$(echo $file_result | grep -oP "(?<=${1}: )[[:word:]]*")
fs_type=$(echo $file_result | grep -oP '[[:word:]]*(?= filesystem data)')
features=$(echo $file_result | grep -oP "\(([[:word:]]| )*\)" | tr '(' '"' | tr ')' '"' | awk '{print}' ORS=', ' | grep -oP '.+(?=\,)')
cat <<myEOF > filesystem.json
{
	"os":"$os",
	"fs_type":"$fs_type",
	"features":{$features}
}
myEOF

exit 0
