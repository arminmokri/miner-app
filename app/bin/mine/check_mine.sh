#!/bin/bash

### get config
this_file_path=$(eval "realpath $0")
this_dir_path=$(eval "dirname $this_file_path")
source "$this_dir_path/../../../config/main.conf"

### mine path
mine_path="$app_dir_path/bin/mine/mine.sh"

proc_id=$(eval "pgrep -f ethdcrminer64 | head -n 1")
if ! [ $proc_id > 0 ]
then
   eval "$mine_path 'no proc id'"
fi
