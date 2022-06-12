#!/bin/bash

while true
do
    cd $HOME/aptos
    counta=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_state_sync_continuous_syncer_errors{error_label="unexpected_error"}')
    countb=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_state_sync_timeout_total')
    ref=20
    count1a=$(echo $counta | grep -o '[0-9]*')
    count1b=$(echo $countb | grep -o '[0-9]*')
    sleep 600
    counta=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_state_sync_continuous_syncer_errors{error_label="unexpected_error"}')
    countb=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_state_sync_timeout_total')
    count2a=$(echo $counta | grep -o '[0-9]*')
    count2b=$(echo $countb | grep -o '[0-9]*')
    count3=$((count2a + count2b - count1a - count1b))
    count4=$((count3 / ref))
    if [ $count3 -gt $ref ]
    then
        echo "Syncer_error and timeout are occurring, your node shoud be restarted now..."
        echo "Error count per minute : "$count4""
        today=$(date)
        echo $today
        docker compose down && docker compose up -d
        echo ""
    else
        echo "Your node health is ok."
        echo "Error count per minute : "$count4""
        today=$(date)
        echo $today
        echo ""
    fi
done
