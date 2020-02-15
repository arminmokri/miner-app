#!/bin/bash

### get config
this_file_path=$(eval "realpath $0")
this_dir_path=$(eval "dirname $this_file_path")
source "$this_dir_path/../../../config/main.conf"

### claymore path
claymore_path="$app_dir_path/bin/claymore/ethdcrminer64"

if [ "$pool" == "nanopool.org" ] ### nanopool.org
then
   $claymore_path \
   -epool $pool_url \
   -ewal $pool_wallet_id.$system_mac_address/$pool_email \
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
elif [ "$pool" == "miningpoolhub.com" ] ### miningpoolhub.com
then
   $claymore_path \
   -epool $pool_url \
   -ewal $pool_username.$system_mac_address \
   -eworker $pool_username.$system_mac_address \
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
fi
