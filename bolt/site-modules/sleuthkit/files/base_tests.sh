#!/bin/bash
# unit test for The Sleuth Kit.

#Fully Automated Tools
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

testSleuthkitModuleTSK_RECOVER(){
	[ ${machine} = 'base' ] && startSkipping
	result=$(tsk_recover -V)
	rtrn=$?
	assertEquals  'Fehler bei Aufruf tsk_recover' 0 ${rtrn}
	assertContains 'tsk_recover Version' "$result" ${tskVersion}
}

#File System Layer Tools

testSleuthkitModuleFSSTAT(){
	[ ${machine} = 'base' ] && startSkipping
	result=$(fsstat -V)
	rtrn=$?
	assertEquals  'Fehler bei Aufruf fsstat' 0 ${rtrn}
	assertContains 'fsstat Version' "$result" ${tskVersion}
}

#File Name LAyer Tools

testSleuthkitModuleFFIND(){
	[ ${machine} = 'base' ] && startSkipping
	result=$(ffind -V)
	rtrn=$?
	assertEquals  'Fehler bei Aufruf ffind' 0 ${rtrn}
	assertContains 'ffind Version' "$result" ${tskVersion}
}

testSleuthkitModuleFLS(){
	[ ${machine} = 'base' ] && startSkipping
	result=$(fls -V)
	rtrn=$?
	assertEquals  'Fehler bei Aufruf fls' 0 ${rtrn}
	assertContains 'fls Version' "$result" ${tskVersion}
}

#Meta Data Layer Tools

testSleuthkitModuleICAT(){
	[ ${machine} = 'base' ] && startSkipping
	result=$(icat -V)
	rtrn=$?
	assertEquals  'Fehler bei Aufruf icat' 0 ${rtrn}
	assertContains 'icat Version' "$result" ${tskVersion}
}

testSleuthkitModuleIFIND(){
	[ ${machine} = 'base' ] && startSkipping
	result=$(ifind -V)
	rtrn=$?
	assertEquals  'Fehler bei Aufruf ifind' 0 ${rtrn}
	assertContains 'ifind Version' "$result" ${tskVersion}
}

testSleuthkitModuleILS(){
	[ ${machine} = 'base' ] && startSkipping
	result=$(ils -V)
	rtrn=$?
	assertEquals  'Fehler bei Aufruf ils' 0 ${rtrn}
	assertContains 'ils Version' "$result" ${tskVersion}
}

testSleuthkitModuISTAT(){
	[ ${machine} = 'base' ] && startSkipping
	result=$(istat -V)
	rtrn=$?
	assertEquals 'Fehler bei Aufruf istat' 0 ${rtrn}
	assertContains 'istat Version' "$result" ${tskVersion}
}

#Data Unit Layer Tools
testSleuthkitModuleBLKCAT(){
	[ ${machine} = 'base' ] && startSkipping
	result=$(blkcat -V)
	rtrn=$?
	assertEquals  'Fehler bei Aufruf blkcat' 0 ${rtrn}
	assertContains 'blkcat Version' "$result" ${tskVersion}
}

testSleuthkitModuleBLKLS(){
	[ ${machine} = 'base' ] && startSkipping
	result=$(blkls -V)
	rtrn=$?
	assertEquals  'Fehler bei Aufruf blkls' 0 ${rtrn}
	assertContains 'blkls Version' "$result" ${tskVersion}
}

testSleuthkitModuleBLKSTAT(){
	[ ${machine} = 'base' ] && startSkipping
	result=$(blkstat -V)
	rtrn=$?
	assertEquals  'Fehler bei Aufruf blkstat' 0 ${rtrn}
	assertContains 'blkstat Version' "$result" ${tskVersion}
}

testSleuthkitModuleBLKCALC(){
	[ ${machine} = 'base' ] && startSkipping
	result=$(blkcalc -V)
	rtrn=$?
	assertEquals  'Fehler bei Aufruf blkcalc' 0 ${rtrn}
	assertContains 'blkcalc Version' "$result" ${tskVersion}
}

# File System Journal Tools
testSleuthkitModuleJCAT(){
	[ ${machine} = 'base' ] && startSkipping
	result=$(jcat -V)
	rtrn=$?
	assertEquals  'Fehler bei Aufruf jcat' 0 ${rtrn}
	assertContains 'jcat Version' "$result" ${tskVersion}
}

testSleuthkitModuleJLS(){
	[ ${machine} = 'base' ] && startSkipping
	result=$(jls -V)
	rtrn=$?
	assertEquals  'Fehler bei Aufruf jls' 0 ${rtrn}
	assertContains 'jls Version' "$result" ${tskVersion}
}

# Volume System Tools
testSleuthkitModuleMMLS(){
	[ ${machine} = 'base' ] && startSkipping
	result=$(mmls -V)
	rtrn=$?
	assertEquals  'Fehler bei Aufruf mmls' 0 ${rtrn}
	assertContains 'mmls Version' "$result" ${tskVersion}
}

testSleuthkitModuleMMSTAT(){
	[ ${machine} = 'base' ] && startSkipping
	result=$(mmstat -V)
	rtrn=$?
	assertEquals  'Fehler bei Aufruf mmstat' 0 ${rtrn}
	assertContains 'mmstat Version' "$result" ${tskVersion}
}

testSleuthkitModuleMMCAT(){
	[ ${machine} = 'base' ] && startSkipping
	result=$(mmcat -V)
	rtrn=$?
	assertEquals  'Fehler bei Aufruf mmcat' 0 ${rtrn}
	assertContains 'mmcat Version' "$result" ${tskVersion}
}

# Image File Tools
testSleuthkitModuleIMG_STAT(){
	[ ${machine} = 'base' ] && startSkipping
	result=$(img_stat -V)
	rtrn=$?
	assertEquals  'Fehler bei Aufruf img_stat' 0 ${rtrn}
	assertContains 'img_stat Version' "$result" ${tskVersion}
}

testSleuthkitModuleIMG_CAT(){
	[ ${machine} = 'base' ] && startSkipping
	result=$(img_cat -V)
	rtrn=$?
	assertEquals  'Fehler bei Aufruf img_cat' 0 ${rtrn}
	assertContains 'img_cat Version' "$result" ${tskVersion}
}

# Other Tools
testSleuthkitModuleHFIND(){
	[ ${machine} = 'base' ] && startSkipping
	result=$(hfind -V)
	rtrn=$?
	assertEquals  'Fehler bei Aufruf hfind' 0 ${rtrn}
	assertContains 'hfind Version' "$result" ${tskVersion}
}

testSleuthkitModuleMACTIME(){
	[ ${machine} = 'base' ] && startSkipping
	result=$(mactime -V)
	rtrn=$?
	assertEquals  'Fehler bei Aufruf mactime' 0 ${rtrn}
	assertContains 'mactime Version' "$result" ${tskVersion}
}

testSleuthkitModuleSORTER(){
	[ ${machine} = 'base' ] && startSkipping
	result=$(sorter -V)
	rtrn=$?
	assertEquals  'Fehler bei Aufruf sorter' 0 ${rtrn}
	assertContains 'sorter Version' "$result" ${tskVersion}
}

testSleuthkitModuleSIGFIND(){
	[ ${machine} = 'base' ] && startSkipping
	result=$(sigfind -V)
	rtrn=$?
	assertEquals  'Fehler bei Aufruf sigfind' 0 ${rtrn}
	assertContains 'sigfind Version' "$result" ${tskVersion}
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
}

oneTimeTearDown() {
  PATH=$originalPath
}

# Load and run shUnit2.
. /home/user/shunit2/shunit2
