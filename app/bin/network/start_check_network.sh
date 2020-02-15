#!/bin/bash

### get config
this_file_path=$(eval "realpath $0")
this_dir_path=$(eval "dirname $this_file_path")
source "$this_dir_path/../../../config/main.conf"

### datetime path
datetime_path="$app_dir_path/bin/datetime.sh"

### ping path
ping_path1="$app_dir_path/bin/network/ping.sh '$network_url1'"
ping_path2="$app_dir_path/bin/network/ping.sh '$network_url2'"

### send reboot cmd to modem path
send_reboot_cmd_to_modem_path="$app_dir_path/bin/network/send_cmd_to_modem.sh '$modem_ip' '$modem_username' '$modem_pasword' '$modem_reboot_cmd'"

### variables
ping_counter=0
network_dis=0

while true
do
   ### pings
   ping_res1=$(eval $ping_path1)
   ping_res2=$(eval $ping_path2)
   if [ "$ping_res1" -eq "0" ] || [ "$ping_res2" -eq "0" ]; then
      ###
      if [ "$network_dis" -eq "1" ]
	  then
         network_dis=0
         datetime_res=$(eval $datetime_path)
         echo "$datetime_res | CHECK_MODEM | Network Normal."
      fi
      ###
      if [ "$ping_counter" -gt "0" ]
	  then
         ping_counter=0
      fi
   else
      let ping_counter=ping_counter+1
      network_dis=1
      datetime_res=$(eval $datetime_path)
      echo "$datetime_res | CHECK_MODEM | No Network Access Try($ping_counter)."
   fi
   ###
   if [ "$ping_counter" -ge "50" ]
   then
      eval $send_reboot_cmd_to_modem_path
      datetime_res=$(eval $datetime_path)
      echo "$datetime_res | CHECK_MODEM | Reboot Modem."
      ping_counter=0
      sleep 120
   fi
   ###
   sleep 1
done