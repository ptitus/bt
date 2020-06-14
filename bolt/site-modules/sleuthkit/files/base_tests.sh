#!/bin/sh
# unit test for The Sleuth Kit.

testSleuthkitModuleTSK_COMPAREDIR(){
	[ ${machine} = 'base' ] && startSkipping
	result=$(tsk_comparedir -V)
	rtrn=$?
	assertEquals  'Fehler bei Aufruf tsk_comparedir' 0 ${rtrn}
	assertContains 'tsk_comparedir Version' "$result" ${tskVersion}
}

testSleuthkitModuleTSK_GETTIMES(){
	[ ${machine} = 'base' ] && startSkipping
	result=$(tsk_gettimes -V)
	rtrn=$?
	assertEquals  'Fehler bei Aufruf tsk_gettimes' 0 ${rtrn}
	assertContains 'tsk_gettimes Version' "$result" ${tskVersion}
}

testSleuthkitModuleTSK_LOADDB(){
	[ ${machine} = 'base' ] && startSkipping
	result=$(tsk_loaddb -V)
	rtrn=$?
	assertEquals  'Fehler bei Aufruf tsk_loaddb' 0 ${rtrn}
	assertContains 'tsk_loaddb Version' "$result" ${tskVersion}
}

testSleuthkitModuleMMLS(){
	[ ${machine} = 'base' ] && startSkipping
	result=$(mmls -V)
	rtrn=$?
	assertEquals  'Fehler bei Aufruf mmls' 0 ${rtrn}
	assertContains 'mmls Version' "$result" ${tskVersion}
}

oneTimeSetUp() {
  originalPath=$PATH
  PATH=$PWD:$PATH
  machine=$(cat /proc/sys/kernel/hostname)
  case ${machine} in
	  (base)  
		  tskVersion='';;

	  (sleuthkit-49)
  		  tskVersion='4.9.0';;

	  (sleuthkit-fkiecad)
  		  tskVersion='4.4.2';;

	  (sleuthkit-refs)
  		  tskVersion='4.6.6';;
 esac
 echo "2"
#  mmlsCmd='mmls'  # save command name in variable to make future changes easy
#  versionParam='-V'
#  actualVersion='4.9.0'
}

oneTimeTearDown() {
  PATH=$originalPath
}

# Load and run shUnit2.
. /home/user/shunit2/shunit2
