#!/bin/bash

### get config
this_file_path=$(eval "realpath $0")
this_dir_path=$(eval "dirname $this_file_path")
source "$this_dir_path/../../../config/main.conf"

### reboot path
reboot_path="$app_dir_path/bin/reboot/reboot.sh"

### reboot
uptime_in_minute=$(eval "echo $(awk '{print $1}' /proc/uptime) / 60 | bc")
if [ "$uptime_in_minute" -ge "$miner_module_reboot_uptime" ]
then
   ### run reboot
   this_file_name=$(eval "basename $this_file_path")
   $reboot_path "$miner ($this_file_name file)"
fi
