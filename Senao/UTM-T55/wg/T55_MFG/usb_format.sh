#!/bin/bash

extra_disk=$(lsblk|grep sd[bcdefg]|grep disk|awk '{print $1}')
partition="1 2 3 4 5"
ERR=0
for disk in $extra_disk
do
    for part in $partition
    do
        umount /dev/$disk$part > /dev/null 2>&1
    done

    parted -s /dev/$disk mklabel msdos
    if [ "$?" != "0" ]; then
        ERR=1
        echo "Error: $disk MS-DOS partition fail"
		echo "BURN_IN_TEST: $disk MS-DOS partition fail" >> /root/automation/testresults-failure.txt
        continue
    fi

    parted -s /dev/$disk mkpart primary ext3 0% 100%
    if [ "$?" != "0" ]; then
        ERR=1
        echo "Error: $disk partition full volume fail"
		echo "BURN_IN_TEST: $disk partition full volume fail" >> /root/automation/testresults-failure.txt
        continue
    fi
    sleep 1;

    for part in $partition
    do
        umount /dev/$disk$part > /dev/null 2>&1
    done

    mke2fs -T ext3 /dev/"$disk"1
    if [ "$?" != "0" ]; then
        ERR=1
        echo "Error: $disk EXT3 format fail"
		echo "BURN_IN_TEST: $disk EXT3 format fail" >> /root/automation/testresults-failure.txt
        continue
    fi
done

if [ "$ERR" == "1" ]; then
    echo Format process is not completed.
else
    echo Format process is completed.
fi
