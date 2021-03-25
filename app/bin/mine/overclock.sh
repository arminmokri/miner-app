#!/bin/bash

### get config
this_file_path=$(eval "realpath $0")
this_dir_path=$(eval "dirname $this_file_path")
source "$this_dir_path/../../../config/main.conf"

### overclock
if [ "$overclock" == "yes" ]
then
   for output in $(ls /sys/class/drm/ | egrep 'card[0-9]$')
   do
      echo $pp_sclk_od | tee /sys/class/drm/$output/device/pp_sclk_od 1> /dev/null
      echo $pp_mclk_od | tee /sys/class/drm/$output/device/pp_mclk_od 1> /dev/null
   done
fi
