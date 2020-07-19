#! /bin/bash
mydir=$(pwd)
mntpath=$(echo "/mnt/btrfs")

mkdir btrfsimg

dd if=/dev/zero of=btrfsimg/disk1 count=19531250
dd if=/dev/zero of=btrfsimg/disk2 count=19531250

losetup -D
losetup /dev/loop1 btrfsimg/disk1
losetup /dev/loop2 btrfsimg/disk2

#pool create -m $mntpath testpool mirror /dev/loop1 /dev/loop2 
#zfs create testpool/testfs
mkfs.btrfs /dev/loop1 /dev/loop2
[[ -d "$mntpath" ]] || mkdir $mntpath
mount -o device=/dev/loop1 $mntpath 

cd ${mntpath}/testfs
cat < /dev/urandom | head -c 10000000 > file.binary 
base64 /dev/urandom | head -c 10000000 > file.txt 
mkdir subdir 
cd subdir 
base64 /dev/urandom | head -c 10000000 > file2.txt

cd $mydir

umount $mntpath

pls btrfsimg
fls -P btrfsimg
