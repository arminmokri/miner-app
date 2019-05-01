#!/bin/bash

### stop claymore
killall -9 ethdcrminer64
sleep 1
pgrep -f ethdcrminer64 | xargs kill -9
