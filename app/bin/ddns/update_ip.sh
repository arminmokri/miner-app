#!/bin/bash

### get config
this_file_path=$(eval "realpath $0")
this_dir_path=$(eval "dirname $this_file_path")
source "$this_dir_path/../../../config/main.conf"

### run api
wget "http://api.dynu.com/nic/update?username=$ddns_username&password=$ddns_hash_password&hostname=$ddns_domian_name" -O /dev/null &>/dev/null
