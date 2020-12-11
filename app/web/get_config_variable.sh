#!/bin/bash

variable_name=$1

### get config
this_file_path=$(eval "realpath $0")
this_dir_path=$(eval "dirname $this_file_path")
source "$this_dir_path/../../config/main.conf"

### get variable value
eval "variable_value=\$$variable_name"

### print variable value
echo -n $variable_value;

