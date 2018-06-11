#!/bin/bash 

/root/automation/T55_MFG/set_ip.sh -g
killall -9 iperf &> /dev/null
iperf -s -w 512k -l 64k -D &> /dev/null
iperf -s -u -D &> /dev/null

sleep 4

port_num=$(ifconfig -a | grep eth | wc -l)
for ((eid=0; eid<$port_num; eid++))
do
	iperf -c 192.168.$eid.1 -t 999999 -P 1 &
done

sleep 1
ps -ax | grep iperf

