#!/bin/bash

### get config
this_file_path=$(eval "realpath $0")
this_dir_path=$(eval "dirname $this_file_path")
source "$this_dir_path/../../../config/main.conf"

### datetime path
datetime_path="$app_dir_path/bin/datetime.sh"

### get datetime
datetime_res=$(eval $datetime_path)

### get reported hashrate
reported_hashrate=0
if [ "$pool" == "nanopool.org" ] ### nanopool.org
then
   json=$(eval "wget -qO - 'https://api.nanopool.org/v1/eth/reportedhashrate/$pool_wallet_id'")
   reported_hashrate=$(echo $json | jq '.data')
elif [ "$pool" == "miningpoolhub.com" ] ### miningpoolhub.com
then
   reported_hashrate=0
else ### other pools not implemented yet
   reported_hashrate=0
fi

### log reported hashrate
if [ "$reported_hashrate" == "null" ] || [ "$reported_hashrate" == "" ]
then
   sleep 1
   "$(eval "realpath $0")"
else
   echo "$datetime_res | $reported_hashrate Mh/s" >> $reported_hashrate_log_path
fi
