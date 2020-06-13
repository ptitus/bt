#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get upgrade -y
apt-get install ubuntu-mate-desktop^ -y
adduser user --gecos "My User,,," --disabled-password
echo "user:linux" | chpasswd
echo "user ALL=(ALL) ALL" >> /etc/sudoers
usermod -a -G vboxsf user
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBxBuN+4taQ5IbKJXr3oSdVny4/769YSqxBrjTv5roQerBfDeCgv6rIoSfKDXB4sbGSnQCRSUMxc/qJPm86SJvlBOjr0YcrxC+VfRAcZNu08SfKtzhsQIGknxrkMA8j2bFzaZbYm4xPn/LfBfC/TAx82tM0tK4R/36IZ4Pkppa7poZKumai/W+1iXZvlDCqd44LdErBOXEuPMkKxYXIV3h1uAeV71krngqIenmQ+zauTxbjzPGZtg5w6XxeHureJ5JfbM4v04JDvSIFSUt/t1S9WdDJCzsvYZji7aVotj4e1rlGCb0gjDC0XMflhqAzak97S2/8ZPNiv8hBjXjioyj Key zur Automation per ssh" > /home/user/.ssh/authorized_keys
