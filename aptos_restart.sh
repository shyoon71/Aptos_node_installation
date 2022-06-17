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
    count2a=$(echo $counta | grep -o '[0-9]*')
    count2b=$(echo $countb | grep -o '[0-9]*')
    count2bb=$(echo $countbb | grep -o '[0-9]*')
    count2c=$(echo $countc | grep -o '[0-9]*')
    count3=$((count2a + count2b + count2bb - count1a - count1b - count1bb))
    count4=$((count3 / 1))
    count45=$(echo $count5)
    tilt=$((count45 / 5))
    count5=$((count2c - count1c))
    if [ $count5 -eq 0 ]
    then
        if [ $count3 -eq 0 ]
        then
            if [ "$( docker container inspect -f '{{.State.Running}}' $aptos-fullnode-1 )" == "true" ]
            then
                today=$(date)
                echo " "$today"  Node running now, but no syncing no errors, it looks like no peers."
                echo " "$today"  No need to restart now. But node health should be checked!!"
            else
                today=$(date)
                echo " "$today"  Node looks like already stopped, it's not running now. Maybe you stopped the node."
                echo " "$today"  Node should be started manually, because this script doesn't know why already stopped."
            fi    
        else
            today=$(date)
            echo " "$today"  Syncing Stopped!!! Previous_synced : "$count1c", Present_synced : "$count2c""
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
                    echo " "$today"  The error count level is not so high. Sync error: "$count4""/"min"
                    echo " "$today"  No need to restart now. But node health should be checked!!"
                fi
            fi
        fi
    fi
    A=`expr $A + 1`
done
wget -q -O aptos_restart.sh https://raw.githubusercontent.com/shyoon71/installation-script/main/aptos_restart.sh && sudo chmod +x aptos_restart.sh && sudo nohup ./aptos_restart.sh &> restart_log.out &
exit()