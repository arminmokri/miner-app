#!/bin/bash

### get config
this_file_path=$(eval "realpath $0")
this_dir_path=$(eval "dirname $this_file_path")
source "$this_dir_path/../../../config/main.conf"

### get ip
myip=$(wget -qO - "https://api.ipify.org")

### use tor network
tor_socks=""
if [ "$use_tor_network_for_ddns" == "1" ]
then
   tor_socks="torsocks"
fi

### run api
$tor_socks wget -qO - "http://api.dynu.com/nic/update?username=$ddns_username&password=$ddns_hash_password&hostname=$ddns_domian_name&myip=$myip" &>/dev/null

