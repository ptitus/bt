#!/usr/bin/env bash
apt-get -qy install automake libtool checkinstall libafflib-dev libewf-dev libvmdk-dev libvhdi-dev libsqlite3-dev postgresql-server-dev-10 default-jre default-jdk
git clone --depth=1 --branch https://github.com/sleuthkit/sleuthkit.git /home/user/sleuthkit
cd /home/user/sleuthkit
./bootstrap
./configure
make
checkinstall -y









