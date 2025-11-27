#!/bin/bash

# arch -> get system architecture and kernel version
arch=$(uname -a)

# number physical CPUs
cpuphys=$(grep "physical id" /proc/cpuinfo | wc -l)

# number virtual cores
cpuv=$(grep "processor" /proc/cpuinfo | wc -l)

# amount of RAM currently available on your server and its usage percentage
ram_total=$(free --mega | awk '$1 == "Mem:" {print $2}')
ram_use=$(free --mega | awk '$1 == "Mem:" {print $3}')
ram_percent=$(free --mega | awk '$1 == "Mem:" {printf("%.2f", $3/$2*100)}')

# amount of storage currently available on your server and its usage as a percentage
disk_used=$(df -m | grep "^/dev/" | grep -v "/boot" | awk '{u += $3} END {printf("%.0f", u)}')
disk_total=$(df -m | grep "^/dev" | grep -v "/boot" | awk '{t += $2} END {printf("%.1fGb", t/1024)}')
disk_percent=$(df -m | grep "^/dev/" | grep -v "/boot" | awk '{u += $3} {t += $2} END {printf("%.2f", u/t*100)}')

# current CPU usage percentage
cpul=$(vmstat 1 2 | tail -1 | awk '{printf $15}')
cpu_op=$(expr 100 - $cpul)
cpu_fin=$(printf "%.1f" $cpu_op)

# date and time of the last reboot
lb=$(who -b | awk '{print $3, $4}')

# whether LVM is active or not
lvmu=$(if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then echo yes; else echo no; fi)

# number of active connections
tcpc=$(ss -ta | grep ESTAB | wc -l)

# number of users currently logged into the server
ulog=$(users | wc -w)

# IPV4 address server and MAC address
ip=$(hostname -I | awk '{print $1}')
mac=$(ip link | grep "link/ether" | awk '{print $2}')

# number of commands executed with sudo
cmnd=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

#Display system information on all terminals
wall "    #Architecture : $arch
             #CPU physical : $cpuphys
             #VCPU : $cpuv
             #Memory Usage : $ram_use/${ram_total}MB ($ram_percent%)
             #Disk Usage : $disk_used/${disk_total} ($disk_percent%)
             #CPU load : $cpu_fin%
             #Last boot : $lb
             #LVM use : $lvmu
             #TCP Connections : $tcpc ESTABLISHED
             #User log : $ulog
             #Network : IP $ip ($mac)
             #Sudo : $cmnd cmd"
