#! /bin/bash
mydir=$(pwd)
mntpath=$(echo "/mnt/testpool")

mkdir zfsimg

dd if=/dev/zero of=zfsimg/disk1 count=19531250
dd if=/dev/zero of=zfsimg/disk2 count=19531250

losetup -D
losetup /dev/loop1 zfsimg/disk1
losetup /dev/loop2 zfsimg/disk2

zpool create -m $mntpath testpool mirror /dev/loop1 /dev/loop2 

zfs create testpool/testfs

cd ${mntpath}/testfs
cat < /dev/urandom | head -c 10000000 > file.binary 
base64 /dev/urandom | head -c 10000000 > file.txt 
mkdir subdir 
cd subdir 
base64 /dev/urandom | head -c 10000000 > file2.txt

cd $mydir

zpool export testpool

pls zfsimg
pls zfsimg/disk1
fls -P zfsimg
