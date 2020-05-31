#!/bin/bash
# Add insecure Vagrant Key
mkdir /home/vagrant/.ssh
wget -O /home/vagrant/.ssh/authorized_keys https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub
chown -R vagrant:vagrant /home/vagrant/.ssh
chmod 0700 /home/vagrant/.ssh
chmod 0600 /home/vagrant/.ssh/authorized_keys
# passwordless Sudo
echo "vagrant ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
# install Virtualbox Additions
mkdir /media/iso
mount -o loop -t iso9660 ~/VBoxGuestAdditions.iso /media/iso
/media/iso/VBoxLinuxAdditions.run
exit 0
