#!/bin/bash

### get config
this_file_path=$(eval "realpath $0")
this_dir_path=$(eval "dirname $this_file_path")
source "$this_dir_path/../../../config/main.conf"

### stop mine path
#stop_mine_path="$app_dir_path/bin/mine/stop_mine.sh"

### run stop mine
#$stop_mine_path

### reboot path
reboot_path="$app_dir_path/bin/reboot/reboot.sh"

### reboot
uptime_in_minute=$(eval "echo $(awk '{print $1}' /proc/uptime) / 60 | bc")
if [ "$uptime_in_minute" -ge "$claymore_reboot_uptime" ]
then
   ### run reboot
   $reboot_path
fi
