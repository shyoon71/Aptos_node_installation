#!/bin/bash

A=1
while [ $A -lt 1441 ]
do
    counta=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_state_sync_continuous_syncer_errors{error_label="unexpected_error"}')
    countb=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_state_sync_timeout_total')
    countbb=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_state_sync_continuous_syncer_errors{error_label="data_stream_notification_timeout"}')
    countc=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_state_sync_version{type="synced"}')
    ref=60
    count1a=$(echo $counta | grep -o '[0-9]*')
    count1b=$(echo $countb | grep -o '[0-9]*')
    count1bb=$(echo $countbb | grep -o '[0-9]*')
    count1c=$(echo $countc | grep -o '[0-9]*')
    sleep 60
    counta=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_state_sync_continuous_syncer_errors{error_label="unexpected_error"}')
    countb=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_state_sync_timeout_total')
    countbb=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_state_sync_continuous_syncer_errors{error_label="data_stream_notification_timeout"}')
    countc=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_state_sync_version{type="synced"}')
    outbound=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_connections{direction="outbound"')
    count2a=$(echo $counta | grep -o '[0-9]*')
    count2b=$(echo $countb | grep -o '[0-9]*')
    count2bb=$(echo $countbb | grep -o '[0-9]*')
    count2c=$(echo $countc | grep -o '[0-9]*')
    export outbound1=$(echo "${outbound:(-2)}")
    count3=$((count2a + count2b + count2bb - count1a - count1b - count1bb))
    count4=$((count3 / 1))
    count45=$(echo $count5)
    tilt=$((count45 / 5))
    count5=$((count2c - count1c))
    if [ $count5 -eq 0 ]
    then
        if [ $count3 -eq 0 ]
        then
            if [ -z $outbound1 ]
            then
                today=$(date)
                echo " "$today"  There's no available peers, so syncing stopped"
                echo " "$today"  No need to restart now. But node configuration and health should be checked!!"
            fi
        else
            today=$(date)
            echo " "$today"  Syncing Stopped, clearly!!! Version freezed!!! : "$count2c""
            docker compose restart
        fi
    else
        if [ $count5 -gt $tilt ]
        then
            if [ $count3 -gt $ref ]
            then
                today=$(date)
                echo " "$today"  Node health is bad. Sync error: "$count4""/"min"
            else
                if [ $count3 -ne 0 ]
                then
                    today=$(date)
                    echo " "$today"  Node health is not bad. Sync error: "$count4""/"min"
                fi
            fi
        else
            if [ $count3 -eq 0 ]
            then
                today=$(date)
                echo " "$today"  Node looks like catchup completed now. Previous_synced : "$count1c", Present_synced : "$count2c""
            else
                if [ $count3 -gt $ref ]
                then
                    today=$(date)
                    echo " "$today"  Syncing speed has fallen below 20%!! Previous_synced : "$count1c", Present_synced : "$count2c""
                    docker compose restart
                else
                    today=$(date)
                    echo " "$today"  Syncing speed has fallen below 20%!! Previous_synced : "$count1c", Present_synced : "$count2c""
                    echo " "$today"  The error count level is not so high, so no need to restart now."
                    echo " "$today"  I think you just restarted the node manually, didn't you?"
                fi
            fi
        fi
    fi
    A=`expr $A + 1`
done
wget -q -O aptos_restart.sh https://raw.githubusercontent.com/shyoon71/installation-script/main/aptos_restart.sh && sudo chmod +x aptos_restart.sh && sudo nohup ./aptos_restart.sh &> restart_log.out &
exit()