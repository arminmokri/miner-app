#!/bin/bash

### get config
this_file_path=$(eval "realpath $0")
this_dir_path=$(eval "dirname $this_file_path")
source "$this_dir_path/../../../config/main.conf"

### stop check network path
stop_check_network_path="$app_dir_path/bin/network/stop_check_network.sh"

### start check network path
start_check_network_path="$app_dir_path/bin/network/start_check_network.sh"

### run stop check network path
$stop_check_network_path

### run start check network path
$start_check_network_path 1>> $check_network_log_path 2>> $check_network_error_log_path &
