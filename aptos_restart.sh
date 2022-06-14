#!/bin/bash

A=0
while [ $A -lt 1008 ]
do
    counta=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_state_sync_continuous_syncer_errors{error_label="unexpected_error"}')
    countb=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_state_sync_timeout_total')
    ref=2000
    count1a=$(echo $counta | grep -o '[0-9]*')
    count1b=$(echo $countb | grep -o '[0-9]*')
    sleep 600
    counta=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_state_sync_continuous_syncer_errors{error_label="unexpected_error"}')
    countb=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_state_sync_timeout_total')
    count2a=$(echo $counta | grep -o '[0-9]*')
    count2b=$(echo $countb | grep -o '[0-9]*')
    count3=$((count2a + count2b - count1a - count1b))
    count4=$(echo "scale=1;$count3 / 10" | bc -l)
    if [ $count3 -gt $ref ]
    then
        today=$(date)
        echo " "$today"  Node Restarts Now!! Sync error occurred count per minute : "$count4""
        docker compose restart
        echo ""
    else
        if [ $count3 -ne 0 ]
        then
            today=$(date)
            echo " "$today"  Node health is not bad. Sync error occurred count per minute : "$count4""
            echo ""
        fi
    fi
    A=`expr $A + 1`
done
wget -q -O aptos_restart.sh https://raw.githubusercontent.com/shyoon71/installation-script/main/aptos_restart.sh && sudo chmod +x aptos_restart.sh && sudo nohup ./aptos_restart.sh &> restart_log.out &
exit()