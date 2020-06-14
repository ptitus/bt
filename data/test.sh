#!/bin/sh
# Example unit test for the git version.

testGetGitVersion() {
  result=$(${gitCmd} ${versionParam})
  rtrn=$?
  assertEquals 'Returncode 0' 0 ${rtrn}
  assertContains 'Aktuelle Git Version' "$result" ${actualVersion}
}

oneTimeSetUp() {
  originalPath=$PATH
  PATH=$PWD:$PATH
  gitCmd='git'  # save command name in variable to make future changes easy
  versionParam='--version'
  actualVersion='2.17.1'
}

oneTimeTearDown() {
  PATH=$originalPath
}

# Load and run shUnit2.
. /home/user/shunit2/shunit2
