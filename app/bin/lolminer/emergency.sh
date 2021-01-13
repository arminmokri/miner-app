#!/bin/bash

##################################
## Emergency script in case the ##
## miner crashes. User defined  ##
## actions to be inserted here  ##
##################################

### get config
this_file_path=$(eval "realpath $0")
this_dir_path=$(eval "dirname $this_file_path")
source "$this_dir_path/../../../config/main.conf"

### mine path
mine_path="$app_dir_path/bin/mine/mine.sh"

### reboot path
reboot_path="$app_dir_path/bin/reboot/reboot.sh"

### reboot
uptime_in_minute=$(eval "echo $(awk '{print $1}' /proc/uptime) / 60 | bc")
if [ "$uptime_in_minute" -ge "$miner_module_reboot_uptime" ]
then
   this_file_name=$(eval "basename $this_file_path")
   if [ "$miner_module_reboot_file_action" == "restart_mining" ]
   then
      $mine_path "$miner ($this_file_name file)"
   elif [[ "$miner_module_reboot_file_action" == "reboot_system"* ]]
   then
      reboot_type=$(eval "echo $miner_module_reboot_file_action | cut -d '/' -f 2")
      $reboot_path "$miner ($this_file_name file)" "$reboot_type"
   fi
fi
