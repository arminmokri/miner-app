#!/bin/bash

killall -9 start_check_network.sh
pgrep -f start_check_network.sh | xargs kill -9
