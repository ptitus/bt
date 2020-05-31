#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get upgrade -y
apt-get install ubuntu-mate-desktop^ -y
adduser user --gecos "My User,,," --disabled-password
echo "user:linux" | chpasswd
echo "user ALL=(ALL) ALL" >> /etc/sudoers
