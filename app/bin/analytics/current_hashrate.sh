#!/bin/bash

### get config
this_file_path=$(eval "realpath $0")
this_dir_path=$(eval "dirname $this_file_path")
source "$this_dir_path/../../../config/main.conf"

### datetime path
datetime_path="$app_dir_path/bin/datetime.sh"

### get datetime
datetime_res=$(eval $datetime_path)

### get current hashrate
current_hashrate=0
if [ "$pool" == "nanopool.org" ] ### nanopool.org
then
   json=$(eval "wget -qO - 'https://api.nanopool.org/v1/eth/hashrate/$pool_wallet_id'")
   current_hashrate=$(echo $json | jq '.data') 
elif [ "$pool" == "miningpoolhub.com" ] ### miningpoolhub.com
then
   json=$(eval "wget -qO - 'https://ethereum.miningpoolhub.com/index.php?page=api&action=getuserhashrate&api_key=$pool_api_key'")
   current_hashrate=$(echo $json | jq '.getuserhashrate.data')
   current_hashrate=$(eval "bc <<< 'scale=2; $current_hashrate/1024'")
else ### other pools not implemented yet
   current_hashrate=0
fi

### log current hashrate
if [ "$current_hashrate" == "null" ] || [ "$current_hashrate" == "" ]
then
   sleep 1
   "$(eval "realpath $0")"
else
   echo "$datetime_res | $current_hashrate Mh/s" >> $current_hashrate_log_path
fi
