#!/bin/bash

### reboot force
echo 1 | tee /proc/sys/kernel/sysrq > /dev/null
echo b | tee /proc/sysrq-trigger > /dev/null
