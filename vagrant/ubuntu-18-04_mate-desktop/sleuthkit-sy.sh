#!/usr/bin/env bash
apt-get -qy install automake libtool checkinstall libafflib-dev libewf-dev libvmdk-dev libvhdi-dev libsqlite3-dev postgresql-server-dev-10 default-jre default-jdk xmount
if ! [[ -e /home/user/sleuthkit/.git ]]
  then git clone --depth=1 https://github.com/shujianyang/sleuthkit.git /home/user/sleuthkit
fi
cd /home/user/sleuthkit
./bootstrap
./configure
make
checkinstall -y









