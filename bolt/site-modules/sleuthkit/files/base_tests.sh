#!/bin/sh
# Example unit test for the git version.

testMmlsVersion() {
  result=$(${mmlsCmd} ${versionParam})
  rtrn=$?
  assertEquals 'Returncode 0' 0 ${rtrn}
  assertContains 'mmls Version' "$result" ${actualVersion}
}

oneTimeSetUp() {
  riginalPath=$PATH
  PATH=$PWD:$PATH
  mmlsCmd='mmls'  # save command name in variable to make future changes easy
  versionParam='-V'
  actualVersion='4.9.0'
}

oneTimeTearDown() {
  PATH=$originalPath
}

# Load and run shUnit2.
. /home/user/shunit2/shunit2
