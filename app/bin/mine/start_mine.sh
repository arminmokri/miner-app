#!/bin/bash

### get config
this_file_path=$(eval "realpath $0")
this_dir_path=$(eval "dirname $this_file_path")
source "$this_dir_path/../../../config/main.conf"

### claymore path
claymore_path="$app_dir_path/bin/claymore/ethdcrminer64"

### ethminer path
ethminer_path="$app_dir_path/bin/ethminer/ethminer"

### lolminer path
lolminer_path="$app_dir_path/bin/lolminer/lolMiner"

### use tor network
tor_socks=""
if [ "$use_tor_network_for_mine" == "1" ]
then
   tor_socks="torsocks"
fi

### run claymore
if [ "$pool" == "nanopool.org" ] ### nanopool.org
then
   if [ "$miner" == "claymore" ] ### claymore
   then
      $tor_socks $claymore_path \
      -epool $pool_url \
      -ewal $pool_wallet_id.$workername/$pool_email \
      -epsw $epsw \
      -esm $esm \
      -asm $asm \
      -mport $mport \
      -mode $mode \
      -allpools $allpools \
      -dbg $dbg \
      -r $r \
      -powlim $powlim \
      -tt $tt \
      -ttli $ttli \
      -tstop $tstop \
      -fanmin $fanmin \
      -fanmax $fanmax \
      -cclock $cclock \
      -mclock $mclock \
      -cvddc $cvddc \
      -mvddc $mvddc \
      -eres $eres \
      -colors $colors
   elif [ "$miner" == "ethminer" ] ### ethminer
   then
      $tor_socks $ethminer_path \
      -P stratum1+tcp://$pool_wallet_id@$pool_url/$workername/$pool_email
   elif [ "$miner" == "lolminer" ] ### lolminer
   then
      $tor_socks $lolminer_path \
      --algo ETHASH --pool $pool_url --user $pool_wallet_id.$workername $@
   fi
elif [ "$pool" == "miningpoolhub.com" ] ### miningpoolhub.com
then
   if [ "$miner" == "claymore" ] ### claymore
   then
      $tor_socks $claymore_path \
      -epool $pool_url \
      -ewal $pool_username.$workername \
      -eworker $pool_username.$workername \
      -epsw $epsw \
      -esm $esm \
      -asm $asm \
      -mport $mport \
      -mode $mode \
      -allpools $allpools \
      -dbg $dbg \
      -r $r \
      -powlim $powlim \
      -tt $tt \
      -ttli $ttli \
      -tstop $tstop \
      -fanmin $fanmin \
      -fanmax $fanmax \
      -cclock $cclock \
      -mclock $mclock \
      -cvddc $cvddc \
      -mvddc $mvddc \
      -eres $eres \
      -colors $colors
   elif [ "$miner" == "ethminer" ] ### ethminer
   then
      $tor_socks $ethminer_path \
      -P stratum2+tcp://$pool_username%2e$workername:x@$pool_url
   elif [ "$miner" == "lolminer" ] ### lolminer
   then
      $tor_socks $lolminer_path \
      --algo ETHASH --pool $pool_url --user $pool_username.$workername $@
   fi
elif [ "$pool" == "ethermine.org" ] ### ethermine.org
then
   if [ "$miner" == "claymore" ] ### claymore
   then
      $tor_socks $claymore_path \
      -epool $pool_url \
      -ewal $pool_wallet_id.$workername \
      -epsw $epsw \
      -esm $esm \
      -asm $asm \
      -mport $mport \
      -mode $mode \
      -allpools $allpools \
      -dbg $dbg \
      -r $r \
      -powlim $powlim \
      -tt $tt \
      -ttli $ttli \
      -tstop $tstop \
      -fanmin $fanmin \
      -fanmax $fanmax \
      -cclock $cclock \
      -mclock $mclock \
      -cvddc $cvddc \
      -mvddc $mvddc \
      -eres $eres \
      -colors $colors
   elif [ "$miner" == "ethminer" ] ### ethminer
   then
      $tor_socks $ethminer_path \
      -P stratum1+tcp://$pool_wallet_id.$workername@$pool_url
   elif [ "$miner" == "lolminer" ] ### lolminer
   then
      $tor_socks $lolminer_path \
      --algo ETHASH --pool $pool_url --user $pool_wallet_id.$workername $@
   fi
fi
