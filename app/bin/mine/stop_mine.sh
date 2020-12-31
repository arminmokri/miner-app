#!/bin/bash

### get config
this_file_path=$(eval "realpath $0")
this_dir_path=$(eval "dirname $this_file_path")
source "$this_dir_path/../../../config/main.conf"

### stop claymore
killall -9 $miner_module_name
sleep 1
pgrep -f $miner_module_name | xargs kill -9
