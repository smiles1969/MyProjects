#!/bin/bash

#source /root/automation/Library/path.sh 
test_result_path=$(cat /root/automation/T55_MFG/mfg_version | grep "test_result_path" | awk '{print $2}')
test_result_failure_path=$(cat /root/automation/T55_MFG/mfg_version | grep "test_result_failure_path" | awk '{print $2}')
all_test_done_path=$(cat /root/automation/T55_MFG/mfg_version | grep "all_test_done_path" | awk '{print $2}')
memory_stress_test_path=$(cat /root/automation/T55_MFG/mfg_version | grep "memory_stress_test_path" | awk '{print $2}')
log_backup_path=$(cat /root/automation/T55_MFG/mfg_version | grep "log_backup_path" | awk '{print $2}')
log_path=$(cat /root/automation/T55_MFG/mfg_version | grep "log_path" | awk '{print $2}')
time_path=$(cat /root/automation/T55_MFG/mfg_version | grep "time_path" | awk '{print $2}')
tmp_path=$(cat /root/automation/T55_MFG/mfg_version | grep "tmp_path" | awk '{print $2}')
tmp_golden_path=$(cat /root/automation/T55_MFG/mfg_version | grep "tmp_golden_path" | awk '{print $2}')   

VERSION=2.4.1
DATE=2018/06/07

function menu(){
	echo "0. Golden Sample " | tee -a $log_path
	echo "1. All test items (Default)" | tee -a $log_path
	echo "2. BOM CHECK" | tee -a $log_path
	echo "3. RTC TEST" | tee -a $log_path
	echo "4. TPM TEST" | tee -a $log_path
	echo "5. HW MONITOR TEST" | tee -a $log_path
	echo "6. ID EEPROM TEST" | tee -a $log_path
	echo "7. S/N, OEM S/N, MAC ADDRESS CHECK-ONLY" | tee -a $log_path
	echo "8. NETWORK TEST" | tee -a $log_path
	echo "9. MEMORY TEST" | tee -a $log_path
	echo "10. BURN IN TEST" | tee -a $log_path
	echo "11. SYSTEM LEDS TEST"
	echo "12. LAN speed LED check"
	echo "13. Force to retest all"
	echo "97. Show Results" | tee -a $log_path
	echo "98. Delete Flag" | tee -a $log_path
	echo "99. Cancel" | tee -a $log_path

	echo "" | tee -a $log_path
	
}


if [ ! -d "/etc/wg/log/diag" ] ; then
    mkdir /etc/wg/log/diag
fi

echo "" | tee -a $log_path 
echo "###################################" | tee -a $log_path
echo "###### SENAO RMA IMAGE ############" | tee -a $log_path
echo "###### Version $VERSION   ############" | tee -a $log_path
echo "###### Date $DATE ############" | tee -a $log_path
echo "###################################" | tee -a $log_path
echo "" | tee -a $log_path

device=$(cat /root/automation/T55_MFG/mfg_version | grep "Device Mode" | awk '{print $3}') 

menu

read -p "Please select your test item in 10 seconds :  " -t 10 select
echo "" | tee -a $log_path

if [ "$select" == "" ] ; then
	if [ "$device" == "2" ] ; then
		select=0
	else
		select=1
	fi
fi

case $select in 
	"0")
		echo "[SENAO] Be a golden sample."
		sed -i '/Device Mode:/s/1/2/g' /root/automation/T55_MFG/mfg_version
		/root/automation/T55_MFG/set_ip.sh -g
		;;
	"1")
		echo "[SENAO] DUT mode"                          
		echo "[SENAO] You select All test items."
		sed -i '/Device Mode:/s/2/1/g' /root/automation/T55_MFG/mfg_version
		/root/automation/autotest.sh all
		;;
	"2")
		echo "[SENAO] You select item $select"
		/root/automation/autotest.sh bom
		;;
	"3")
		echo "[SENAO] You select item $select"
		/root/automation/autotest.sh rtc
		;;
	"4")
		echo "[SENAO] You select item $select"
		/root/automation/autotest.sh tpm
		;;
	"5")
		echo "[SENAO] You select item $select"
		/root/automation/autotest.sh hw-monitor
		;;
	"6")
		echo "[SENAO] You select item $select"
		/root/automation/autotest.sh eeprom
		;;
	"7")
		echo "[SENAO] You select item $select"
		/root/automation/autotest.sh sn-mac
		;;
	"8")
		echo "[SENAO] You select item $select"
		/root/automation/autotest.sh network
		;;
	"9")
		echo "[SENAO] You select item $select"
		/root/automation/autotest.sh mem-test
		;;
	"10")
		echo "[SENAO] You select item $select"
		/root/automation/autotest.sh burn-in
		;;
	"11")
		echo "[SENAO] You select item $select"
		/root/automation/T55_MFG/SysLEDTest.sh
		;;
	"12")
		echo "[SENAO] You select item $select"
		/root/automation/T55_MFG/LanLEDTest.sh
		;;
	"13")
		echo "[SENAO] You select item $select"
		echo "[SENAO] DUT mode"                          
		sed -i '/Device Mode:/s/2/1/g' /root/automation/T55_MFG/mfg_version
		/root/automation/autotest.sh del-flag
		/root/automation/autotest.sh all
		;;
	"97")
		echo "[SENAO] Show test results."
		/root/automation/autotest.sh fetch-results
		;;
	"98")
		echo "[SENAO] Move all flag and results into backup folder.."
		/root/automation/autotest.sh del-flag
		;;
	"99")
		echo "[SENAO] Cancel"
		exit 0
		;;
	*)
		echo "[ERROR] You enter a wrong number $select !"
		;;
esac		
