#!/bin/bash

while true
do
    cd $HOME/aptos
    counta=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_state_sync_continuous_syncer_errors{error_label="unexpected_error"}')
    countb=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_state_sync_timeout_total')
    count=$((counta + countb))
    ref=20
    count1a=$(echo $counta | grep -o '[0-9]*')
    count1b=$(echo $countb | grep -o '[0-9]*')
    sleep 600
    counta=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_state_sync_continuous_syncer_errors{error_label="unexpected_error"}')
    countb=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_state_sync_timeout_total')
    count2a=$(echo $counta | grep -o '[0-9]*')
    count2b=$(echo $countb | grep -o '[0-9]*')
    count3=$((count2a + count2b - count1a - count1b))
    if [ $count3 -gt $ref ]
    then
        count4=$((count3 / ref))
        echo "\e[1m\e[33mSynchronizer_error is occurring, your node shoud be restarted now... \e[0m"
        echo "\e[1m\e[33mError count per minute : \e[1m\e[35m"$count4" \e[0m"
        today=$(date)
        echo $today
        docker compose down && docker compose up -d
        echo ""
    else
        echo "\e[1m\e[33mYour node health is ok. \e[0m"
        echo "\e[1m\e[33mError count per minute : \e[1m\e[33m"$count4" \e[0m"
        today=$(date)
        echo $today
        echo ""
    fi
done
