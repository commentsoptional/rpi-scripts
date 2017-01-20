#!/usr/bin/env bash

### Author: A.A.
### Date: 20170118
### Description: Turn WiFi Power Management setting on/off
### Usage: ./wifi_power_management.sh {on || off}

export rundir=$(dirname $0)
export RUNTIME=`date +%Y%m%d%H%M%S`
# Source in some common functions.

. ${rundir}/common_functions.sh

setting=${1}
current_setting=`iwconfig wlan0 | grep "Power Management:" | cut -d ":" -f 2`

if [ $# -eq 0 ]
then
    echo "[##E] `date` (wifi_power_management.sh) -> One and only one input parameter is required {on || off}."
    exit 1
elif [ $setting != "on" ] && [ $setting != "off" ]
then
    echo "[##E] `date` (wifi_power_management.sh) -> Only settings accepted as parameters are {on || off}."
    exit 1
fi

if [ $setting == $current_setting ]
then
    echo "[##I] `date` (wifi_power_management.sh) -> Input setting matched the current system setting."
    echo "[##I] `date` (wifi_power_management.sh) -> You input:                ${setting}"
    echo "[##I] `date` (wifi_power_management.sh) -> Current system setting:   ${setting}"
fi

echo "[##I] `date` (wifi_power_management.sh) -> Creating a backup of your current /etc/networking/interfaces in your home dir."
sudo cp /etc/network/interfaces ~/interfaces_bk_${RUNTIME}
error_check $?

echo "[##I] `date` (wifi_power_management.sh) -> Checking if /etc/networking/interfaces has ever been modified to adjust wireless power."
prev_mod=`grep "wireless-power" /etc/network/interfaces`

if [ ${#prev_mod} -eq 0 ]
then
    sed -i '0,/iface wlan0 inet manual/{s/iface wlan0 inet manual/iface wlan0 inet manual\n    wireless-power '"${setting}"'/}' /etc/network/interfaces
    error_check $?
else
    sudo sed -i 's|'"${prev_mod}"'|    wireless-power '"${setting}"'|g' /etc/network/interfaces
    error_check $?
fi

echo "[##I] `date` (wifi_power_management.sh) -> Changes will take effect after your next reboot."
echo "[##I] `date` (wifi_power_management.sh) -> Please run: sudo reboot"
sleep 3
echo "[##I] `date` (wifi_power_management.sh) -> Don't forget sudo reboot."

exit 0


