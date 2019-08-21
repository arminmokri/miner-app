#!/bin/bash

### get config
this_file_path=$(eval "realpath $0")
this_dir_path=$(eval "dirname $this_file_path")
source "$this_dir_path/../../../config/main.conf"

### stop mine path
stop_mine_path="$app_dir_path/bin/mine/stop_mine.sh"

### run stop mine
$stop_mine_path
