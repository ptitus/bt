#!/usr/bin/env bash
apt install -qy automake libtool checkinstall libafflib-dev libewf-dev libvmdk-dev libvhdi-dev libsqlite3-dev postgresql-server-dev-10 default-jre default-jdk
git clone --depth=1 --branch release-4.9.0 https://github.com/sleuthkit/sleuthkit.git /home/user/sleuthkit
cd /home/user/sleuthkit
./bootstrap
./configure
make
checkinstall -y
