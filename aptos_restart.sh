#!/bin/bash

count=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_state_sync_storage_synchronizer_errors{error_label="unexpected_error"')
count1=$(echo $count | grep -o '[0-9]*')
sleep 60
count2=$(echo $count | grep -o '[0-9]*')
count3=$($count2-$count1)
if [ $count3 > 0 ]
then
    echo "\e[1m\e[33mSynchronizer_error is occurring, so your node shoud be restarted now... \e[0m"
    echo "\e[1m\e[33m"$count3"times occured in 1 minute. \e[0m"
    docker compose down && docker compose up -d
fi

