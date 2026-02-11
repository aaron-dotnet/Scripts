#!/usr/bin/bash

echo "======================="
echo "      System Info      "
echo "                       "
echo "    Version:    1.0    "
echo "======================="
echo ""

echo "--- Operative System ---"
uname -o

echo ""
echo "--- Kernel version ---"
uname -r

echo ""
echo "--- Distributión ---"
lsb_release -a 2>/dev/null || cat /etc/*-release | grep "NAME"

echo ""
echo "--- Uptime ---"
uptime

# otros comandos luego los checo :v
# df -h # disk info
# ip a # red info
# ss -tuln # active connections
# 
# Red config files
# cat /etc/hosts
# cat /etc/resolv.conf
#
# file with suid permissions
# find / -perm -4000 2>/dev/null
#
# binarys than can be run as another user
# sudo -l

