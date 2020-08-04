#!/usr/bin/env bash



seconds_left=10
echo "please wait for${seconds_left}s……, to ensure that the backup server starts successfully"
while [ $seconds_left -gt 0 ];do
    echo -n $seconds_left
    sleep 1
    seconds_left=$(($seconds_left - 1))
    echo -ne "\r     \r" #clear digital
done