#!/bin/bash

### get config
this_file_path=$(eval "realpath $0")
this_dir_path=$(eval "dirname $this_file_path")
source "$this_dir_path/../../../config/main.conf"

### datetime path
datetime_path="$app_dir_path/bin/datetime.sh"

### get datetime
datetime_res=$(eval $datetime_path)

### get avg hashrate
avg_hashrate=0
if [ "$pool" == "nanopool.org" ] ### nanopool.org
then
   json=$(eval "wget -qO - 'https://api.nanopool.org/v1/eth/avghashratelimited/$pool_wallet_id/24'")
   avg_hashrate=$(echo $json | jq '.data')
elif [ "$pool" == "miningpoolhub.com" ] ### miningpoolhub.com
then
   avg_hashrate=0
else ### not implemented other pools yet
   avg_hashrate=0
fi

### log avg hashrate
if [ "$avg_hashrate" == "null" ] || [ "$avg_hashrate" == "" ]
then
   sleep 1
   "$(eval "realpath $0")"
else
   echo "$datetime_res | $avg_hashrate Mh/s" >> $avg_hashrate_log_path
fi
