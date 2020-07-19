#!/bin/bash

dynTestFile="./dyn_tests.sh"
fsPart=$(cat $1_tests.sh)
filePart=$(cat file_tests.txt)
dynTestFileContent=$(echo "${fsPart/INSERT_FILE_TESTS/$filePart}")

echo "$dynTestFileContent" > "$dynTestFile"
chmod 755 "$dynTestFile"
echo "running Tests for $1 ...."
"$dynTestFile"
echo "done"
