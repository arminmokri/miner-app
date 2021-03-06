#!/bin/bash

### get config
this_file_path=$(eval "realpath $0")
this_dir_path=$(eval "dirname $this_file_path")
source "$this_dir_path/../../../config/main.conf"

### datetime path
datetime_path="$app_dir_path/bin/datetime.sh"

### reboot normal path
reboot_normal_path="$app_dir_path/bin/reboot/reboot_normal.sh"

### reboot force path
reboot_force_path="$app_dir_path/bin/reboot/reboot_force.sh"

### get datetime
datetime_res=$(eval $datetime_path)

###
caller_proc=""
reboot_type=""
if [ $# -eq 2 ]
then
   caller_proc=$1
   reboot_type=$2
elif [ $# -eq 1 ]
then
   caller_proc=$1
   reboot_type=$default_reboot_type
else
   caller_proc="manual"
   reboot_type=$default_reboot_type 
fi

echo "$datetime_res | Reboot | $caller_proc | $reboot_type | Successed" >> $mine_log_path

### sync
sync
sleep 3

### reboot
if [ "$reboot_type" == "normal" ] ### normal reboot
then
   sudo $reboot_normal_path
elif [ "$reboot_type" == "force" ] ### force reboot
then
   sudo $reboot_force_path
fi
