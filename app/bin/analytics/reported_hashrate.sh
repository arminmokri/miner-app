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

### get reported hashrate
reported_hashrate=0
if [ "$pool" == "nanopool.org" ] ### nanopool.org
then
   json=$(eval "wget -qO - 'https://api.nanopool.org/v1/eth/reportedhashrate/$pool_wallet_id'")
   reported_hashrate=$(echo $json | jq '.data')
   if [ "$reported_hashrate" == "null" ] || [ "$reported_hashrate" == "" ]
   then
      if [ "$reported_hashrate_log_try_times" == "0" ] || [ "$reported_hashrate_log_try_times" -ge "$datetime_sec" ]
      then
         sleep 1
         "$(eval "realpath $0")"
         exit
      else
         reported_hashrate="-1"
      fi
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
      if [ "$reported_hashrate_log_try_times" == "0" ] || [ "$reported_hashrate_log_try_times" -ge "$datetime_sec" ]
      then
         sleep 1
         "$(eval "realpath $0")"
         exit
      else
         reported_hashrate="-1"
      fi
   fi
else ### other pools not implemented yet
   reported_hashrate=0
fi

### log reported hashrate
if [ "$avg_hashrate" == "-1" ]
then
   echo "$datetime_res | Unavailable Data, Try($reported_hashrate_log_try_times)" >> $reported_hashrate_log_path
else
   echo "$datetime_res | $reported_hashrate Mh/s" >> $reported_hashrate_log_path
fi
