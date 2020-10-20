#!/bin/bash

### get config
this_file_path=$(eval "realpath $0")
this_dir_path=$(eval "dirname $this_file_path")
source "$this_dir_path/../../../config/main.conf"

### datetime path
datetime_path="$app_dir_path/bin/datetime.sh"

### get datetime
datetime_res=$(eval $datetime_path)

### if achieve number of try times to get data, do exit
datetime_sec=$(eval "date --date='$datetime_res' '+%S'")
if [ "$reported_hashrate_log_try_times" != "0" ] && [ "$datetime_sec" -gt "$reported_hashrate_log_try_times" ]
then
   exit
fi

### get reported hashrate
reported_hashrate=0
if [ "$pool" == "nanopool.org" ] ### nanopool.org
then
   json=$(eval "wget -qO - 'https://api.nanopool.org/v1/eth/reportedhashrate/$pool_wallet_id'")
   reported_hashrate=$(echo $json | jq '.data')
   if [ "$reported_hashrate" == "null" ] || [ "$reported_hashrate" == "" ]
   then
      sleep 1
      "$(eval "realpath $0")"
      exit
   fi
elif [ "$pool" == "miningpoolhub.com" ] ### miningpoolhub.com
then
   reported_hashrate=0
elif [ "$pool" == "ethermine.org" ] ### ethermine.org
then
   json=$(eval "wget -qO - 'https://api.ethermine.org/miner/$pool_wallet_id/currentStats'")
   api_status=$(echo $json | jq '.status')
   if [ "$api_status" == "\"OK\"" ]
   then
      reported_hashrate=$(echo $json | jq '.data.reportedHashrate')
      reported_hashrate=$(eval "bc <<< 'scale=2; $reported_hashrate/(1000*1000)'")
   else
      sleep 1
      "$(eval "realpath $0")"
      exit
   fi
else ### other pools not implemented yet
   reported_hashrate=0
fi

### log reported hashrate
echo "$datetime_res | $reported_hashrate Mh/s" >> $reported_hashrate_log_path

