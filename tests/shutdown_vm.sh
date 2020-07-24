#!/bin/bash
VBoxManage guestcontrol $1 --username Administrator --password Windoof2020 run -- 'C:\WINDOWS\system32\shutdown.exe' '-s'
