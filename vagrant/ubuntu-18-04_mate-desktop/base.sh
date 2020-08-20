#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get upgrade -y
apt-get install ubuntu-mate-desktop^ -y
# Benutzer anlegen und berechtigen
if ! grep -q ^user: /etc/passwd 
  then 
    adduser user --gecos "My User,,," --disabled-password
    echo "user:linux" | chpasswd
    echo "user ALL=(ALL) ALL" >> /etc/sudoers
    usermod -a -G vboxsf user
fi
# shunit2 installieren
if ! [[ -e /home/user/shunit2/.git ]] 
  then git clone --depth=1 https://github.com/kward/shunit2.git /home/user/shunit2
fi
# jshon installieren
apt-get install jq tree -y
