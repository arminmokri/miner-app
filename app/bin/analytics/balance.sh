#!/bin/bash

### get config
this_file_path=$(eval "realpath $0")
this_dir_path=$(eval "dirname $this_file_path")
source "$this_dir_path/../../../config/main.conf"

### datetime path
datetime_path="$app_dir_path/bin/datetime.sh"

### get datetime
datetime_res=$(eval $datetime_path)

### get last balance
last_balance=$(eval "cat $last_balance_path")

### get balance
balance=0
if [ "$pool" == "nanopool.org" ] ### nanopool.org
then
   json=$(eval "wget -qO - 'https://api.nanopool.org/v1/eth/balance/$pool_wallet_id'")
   balance=$(echo $json | jq '.data')
elif [ "$pool" == "miningpoolhub.com" ] ### miningpoolhub.com
then
   json=$(eval "wget -qO - 'https://ethereum.miningpoolhub.com/index.php?page=api&action=getuserbalance&api_key=$pool_api_key'")
   balance=$(echo $json | jq '.getuserbalance.data.confirmed')
   if [[ $balance == *e* ]]
   then
      balance=$(eval "printf "%.16f" $balance")
   fi
else ### not implemented other pools yet
   balance=0
fi

### calculate diff
diff=0
if [[ $(echo "$balance > $last_balance" | bc -l) > 0 ]]
then
   diff=$(eval "echo '$balance - $last_balance' | bc")
fi

### log balance
if [ "$balance" == "null" ] || [ "$balance" == "" ]
then
   sleep 1
   "$(eval "realpath $0")"
else
   echo "$datetime_res | $balance | $diff" >> $balance_log_path
   echo "$balance" > $last_balance_path
fi
