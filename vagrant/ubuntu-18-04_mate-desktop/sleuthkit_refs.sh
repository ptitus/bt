#!/usr/bin/env bash
apt install -qy automake libtool checkinstall libafflib-dev libewf-dev libvmdk-dev libvhdi-dev libsqlite3-dev postgresql-server-dev-10 default-jre default-jdk
git clone --depth=1 https://faui1-gitlab.cs.fau.de/paul.prade/refs-sleuthkit-implementation.git /home/user/sleuthkit
cd /home/user/sleuthkit
./bootstrap
./configure
make
checkinstall -y