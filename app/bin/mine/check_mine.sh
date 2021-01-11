#!/bin/bash

### get config
this_file_path=$(eval "realpath $0")
this_dir_path=$(eval "dirname $this_file_path")
source "$this_dir_path/../../../config/main.conf"

### mine path
mine_path="$app_dir_path/bin/mine/mine.sh"

### reboot path
reboot_path="$app_dir_path/bin/reboot/reboot.sh"

### get proc id
proc_id=$(eval "pgrep -f $miner_module_name | head -n 1")

### call miner if no proc
uptime_in_minute=$(eval "echo $(awk '{print $1}' /proc/uptime) / 60 | bc")
if [ "$uptime_in_minute" -ge "$miner_module_reboot_uptime" ]
then
   if ! [ $proc_id > 0 ]
   then
      if [ "$miner_module_proc_id_action" == "restart_mining" ]
      then
         $mine_path "proc id checker"
      elif [ "$miner_module_proc_id_action" == "reboot_system" ]
      then
         $reboot_path "proc id checker"
      fi
   else
      for i in ${!miner_module_crash_list[@]}
      do
         crash=${miner_module_crash_list[$i]}
         if [ "$(eval "tail -n30 $mining_log_path | grep '$crash' | wc -l")" -gt "0" ]
         then
            if [ "$miner_module_crash_action" == "restart_mining" ]
            then
               $mine_path "crash checker (key='$crash')"
            elif [ "$miner_module_crash_action" == "reboot_system" ]
            then
               $reboot_path "crash checker (key='$crash')"
            fi
            break
         fi
      done
   fi
fi
