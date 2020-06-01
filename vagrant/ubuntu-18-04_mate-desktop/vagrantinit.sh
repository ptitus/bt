#!/bin/bash
vagrant box remove ubuntu1804.01
vagrant box add --name ubuntu1804.01 ../../packer/ubuntu-18-04/box/virtualbox/ubuntu-18.04-0.1.box
if [ ! -f Vagrantfile]; then
       vagrant init ubuntu1804.01
fi       
