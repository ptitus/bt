#!/bin/bash

dynTestFile="./dyn_tests.sh"
fsPart=$(cat $1_tests.sh)
filePart=$(cat file_tests.txt)
dynTestFileContent=$(echo "${fsPart/INSERT_FILE_TESTS/$filePart}")

echo "$dynTestFileContent" > "$dynTestFile"
chmod 755 "$dynTestFile"
echo "running Tests for $1 ...."
"$dynTestFile" | tee results/${1}_rawresult.txt
datetime=$(date +"%Y-%m-%d_%H-%M-%S")
cat results/${1}_rawresult.txt | sed 's/\x1B\[[0-9;]*[JKmsu]//g' | grep -P '^(test|ASSERT|FAILED )' > results/${1}/${1}_"$datetime"_result.txt 
echo "done"
