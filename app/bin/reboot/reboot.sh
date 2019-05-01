#!/bin/bash

### get config
this_file_path=$(eval "realpath $0")
this_dir_path=$(eval "dirname $this_file_path")
source "$this_dir_path/../../../config/main.conf"

### reboot normal path
reboot_normal_path="$app_dir_path/bin/reboot/reboot_normal.sh"

### reboot force path
reboot_force_path="$app_dir_path/bin/reboot/reboot_force.sh"

### reboot
if [ "$reboot_type" == "normal" ] ### normal reboot
then
   $reboot_normal_path
elif [ "$reboot_type" == "force" ] ### force reboot
then
   $reboot_force_path
fi
