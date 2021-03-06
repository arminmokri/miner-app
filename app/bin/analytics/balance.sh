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

### get last balance
last_balance=0
if [ -e "$last_balance_path" ]
then
   last_balance=$(eval "cat $last_balance_path")
fi

### get balance
balance=0
if [ "$pool" == "nanopool.org" ] ### nanopool.org
then
   json=$(eval "wget -qO - 'https://api.nanopool.org/v1/eth/balance/$pool_wallet_id'")
   balance=$(echo $json | jq '.data')
   if [ "$balance" == "null" ] || [ "$balance" == "" ]
   then
      if [ "$balance_log_try_times" == "0" ] || [ "$balance_log_try_times" -ge "$datetime_sec" ]
      then
         sleep 1
         "$(eval "realpath $0")"
         exit
      else
         balance="-1"
      fi
   fi
elif [ "$pool" == "miningpoolhub.com" ] ### miningpoolhub.com
then
   json=$(eval "wget -qO - 'https://ethereum.miningpoolhub.com/index.php?page=api&action=getuserbalance&api_key=$pool_api_key'")
   balance=$(echo $json | jq '.getuserbalance.data.confirmed')
   if [ "$balance" == "null" ] || [ "$balance" == "" ]
   then
      if [ "$balance_log_try_times" == "0" ] || [ "$balance_log_try_times" -ge "$datetime_sec" ]
      then
         sleep 1
         "$(eval "realpath $0")"
         exit
      else
         balance="-1"
      fi
   else
      if [[ $balance == *e* ]]
      then
         balance=$(eval "printf "%.16f" $balance")
      fi
   fi
elif [ "$pool" == "ethermine.org" ] ### ethermine.org
then
   json=$(eval "wget -qO - 'https://api.ethermine.org/miner/$pool_wallet_id/currentStats'")
   api_status=$(echo $json | jq '.status')
   if [ "$api_status" == "\"OK\"" ]
   then
      balance=$(echo $json | jq '.data.unpaid')
      balance=$(eval "bc <<< 'scale=8; $balance/1000000000000000000'")
   else
      if [ "$balance_log_try_times" == "0" ] || [ "$balance_log_try_times" -ge "$datetime_sec" ]
      then
         sleep 1
         "$(eval "realpath $0")"
         exit
      else
         balance="-1"
      fi
   fi
else ### not implemented other pools yet
   balance=0
fi

### log balance
if [ "$balance" == "-1" ]
then
   echo "$datetime_res | Unavailable Data, Try($balance_log_try_times)" >> $balance_log_path
else
   ### calculate diff
   diff=0
   if [[ $(echo "$balance > $last_balance" | bc -l) > 0 ]]
   then
      diff=$(eval "echo '$balance - $last_balance' | bc")
   fi
   echo "$datetime_res | $balance | $diff" >> $balance_log_path
   echo "$balance" > $last_balance_path  
fi
