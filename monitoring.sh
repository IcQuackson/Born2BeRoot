#!/bin/bash

# OS info
arch="Arquitecture: $(uname -a)"
#CPU info
nproc="CPU physical : $(nproc)"
#nproc="CPU physical : $(cat /proc/cpuinfo | grep "physical id" | sort | uniq | wc -l)"
nvproc="vCPU : $(cat /proc/cpuinfo | grep "processor" | wc -l)"
# Ram usage
meminfo=$(free -m)
ram_used=$(echo "$meminfo" | grep Mem | awk '{print $3}')
ram_total=$(echo "$meminfo" | grep Mem | awk '{print $2}')
ram_usage=$(echo "scale=2; $ram_used / $ram_total * 100" | bc)
ram="Memory Usage: $ram_used/${ram_total}MB ($ram_usage%)"
# Disk usage
disk_used=$(df -h -B KB| awk '/^\/dev/ {print $3}' | awk '{s+=$1} END {print s}')
disk_total=$(df -h -B KB| awk '/^\/dev/ {print $2}' | awk '{s+=$1} END {print s}')
disk_used=$(echo "scale=2; $disk_used / 1024 / 1024" | bc)
disk_total=$(echo "scale=2; $disk_total / 1024 / 1024" | bc)
disk_usage=$(echo "scale=2; $disk_used / $disk_total * 100" | bc)
disk="Disk usage: $disk_used/${disk_total}GB ($disk_usage%)"
# CPU load
cpu_usage="CPU load: $(top -b -n 1 | grep '%Cpu(s)' | awk '{print $2}')%"
# Last boot
last_boot="Last boot: $(uptime -s)"
# LVM
is_lvm_used="LVM use: "
if [ -d /dev/mapper ]; then
	is_lvm_used+="yes"
else
	is_lvm_used+="no"
fi      
# Connections
connections="TCP connections: $(netstat -nt | grep -e "tcp" -e "ESTABLISHED" | wc -l) ESTABLISHED"
# Users
user_log="User log: $(users | wc -w)"
# ip mac
ip=$(hostname -I)
mac=$(ip a | grep -A 1 "enp0s3:" | grep "link/ether" | awk '{print $2}')
net="Network: IP $ip ($mac)"
cmds="42 cmd: $(journalctl _COMM=sudo | grep COMMAND | wc -l)"
wall "$arch
$nproc
$nvproc
$ram
$disk
$cpu_usage
$last_boot
$is_lvm_used
$connections
$user_log
$net
$cmds"
