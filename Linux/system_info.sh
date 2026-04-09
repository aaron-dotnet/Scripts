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
cat <<EOF
--- Uptime ---
This machine has been $(uptime -p)
Since: $(uptime -s)
------

EOF

echo "--- Extra system info ---"
hostnamectl --no-ask-password 2>/dev/null | grep -E 'hostname|Chassis|Virtualization|System'
echo "----"

local_ip="$(hostname -I 2>/dev/null)"
if [ $? == 0 ]; then
    echo "--- Local IP ----"
    echo $local_ip
fi

echo ""
echo "--- gateway ---"
ip route show

# otros comandos
# df -h # disk info
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

