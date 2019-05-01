#!/bin/bash

host=$1
ping -c 1 -W 1 $host >/dev/null 2>/dev/null
echo $?
