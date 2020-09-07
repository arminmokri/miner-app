#!/bin/bash

### get config
this_file_path=$(eval "realpath $0")
this_dir_path=$(eval "dirname $this_file_path")
source "$this_dir_path/../../../config/main.conf"

### datetime path
datetime_path="$app_dir_path/bin/datetime.sh"

### get datetime
datetime_res=$(eval $datetime_path)

### reboot path
reboot_path="$app_dir_path/bin/reboot/reboot.sh"

### get current hashrate
current_hashrate=0
if [ "$pool" == "nanopool.org" ] ### nanopool.org
then
   json=$(eval "wget -qO - 'https://api.nanopool.org/v1/eth/hashrate/$pool_wallet_id'")
   current_hashrate=$(echo $json | jq '.data')
   if [ "$current_hashrate" == "null" ] || [ "$current_hashrate" == "" ]
   then
     sleep 1
     "$(eval "realpath $0")"
     exit
   fi
elif [ "$pool" == "miningpoolhub.com" ] ### miningpoolhub.com
then
   json=$(eval "wget -qO - 'https://ethereum.miningpoolhub.com/index.php?page=api&action=getuserhashrate&api_key=$pool_api_key'")
   current_hashrate=$(echo $json | jq '.getuserhashrate.data')
   if [ "$current_hashrate" == "null" ] || [ "$current_hashrate" == "" ]
   then
     sleep 1
     "$(eval "realpath $0")"
     exit
   fi
   current_hashrate=$(eval "bc <<< 'scale=2; $current_hashrate/1024'")
elif [ "$pool" == "ethermine.org" ] ### ethermine.org
then
   json=$(eval "wget -qO - 'https://api.ethermine.org/miner/$pool_wallet_id/currentStats'")
   api_status=$(echo $json | jq '.status')
   if [ "$api_status" == "\"OK\"" ]
   then
      current_hashrate=$(echo $json | jq '.data.currentHashrate')
      current_hashrate=$(eval "bc <<< 'scale=2; $current_hashrate/(1000*1000)'")
   else
      sleep 1
      "$(eval "realpath $0")"
      exit
   fi
else ### other pools not implemented yet
   current_hashrate=0
fi

### log current hashrate
echo "$datetime_res | $current_hashrate Mh/s" >> $current_hashrate_log_path
uptime_in_minute=$(eval "echo $(awk '{print $1}' /proc/uptime) / 60 | bc")
if [ "$continuously_current_hashrate_times" != "0" ] && [ "$uptime_in_minute" -ge "$continuously_current_hashrate_uptime" ] && [ "$current_hashrate" == "0" ]
then
   if [ -e "$current_hashrate_zero_counter_path" ]
   then
      current_hashrate_zero_counter=$(eval "cat $current_hashrate_zero_counter_path")
   else
      current_hashrate_zero_counter=0
   fi
   let current_hashrate_zero_counter=current_hashrate_zero_counter+1
   if [ "$current_hashrate_zero_counter" -ge "$continuously_current_hashrate_times" ]
   then
      echo "0" > $current_hashrate_zero_counter_path
      sleep 1
      $reboot_path
   else
      echo "$current_hashrate_zero_counter" > $current_hashrate_zero_counter_path
   fi
else
   echo "0" > $current_hashrate_zero_counter_path
fi

