#!/bin/bash
vagrant box add --name ubuntu1804.01 ../../packer/ubuntu-18-04/box/virtualbox/ubuntu-18.04-0.1.box
vagrant init ubuntu1804.01
