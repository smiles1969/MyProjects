#! /bin/bash

port_num=$(ifconfig -a | grep eth | wc -l)
for ((eid=0; eid<$port_num; eid++))
do
    link_state=$(ethtool eth$eid | grep 'Link detected' | awk '{print $3}')
    if [ $link_state != "yes" ] ; then
        echo "[WARNING] Golden Sample port eth$eid link status $link_state" | tee -a /root/automation/log.txt | tee -a /root/automation/testresults-failure.txt 
        link_error=1 # disconnection
    fi      
done
