#!/bin/bash

A=1
while [ $A -lt 576 ]
do
    counta=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_state_sync_continuous_syncer_errors{error_label="unexpected_error"}')
    countb=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_state_sync_timeout_total')
    countc=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_storage_ledger_version')
    ref=500
    count1a=$(echo $counta | grep -o '[0-9]*')
    count1b=$(echo $countb | grep -o '[0-9]*')
    count1c=$(echo $countc | grep -o '[0-9]*')
    sleep 300
    counta=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_state_sync_continuous_syncer_errors{error_label="unexpected_error"}')
    countb=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_state_sync_timeout_total')
    countc=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_storage_ledger_version')
    count2a=$(echo $counta | grep -o '[0-9]*')
    count2b=$(echo $countb | grep -o '[0-9]*')
    count2c=$(echo $countc | grep -o '[0-9]*')
    count3=$((count2a + count2b - count1a - count1b))
    count4=$((count3 / 10))
    count45=$(echo $count5)
    tilt=$((count45 / 5))
    count5=$((count2c - count1c))
    if [ $count5 -eq 0 ]
    then
        if [ $count3 -eq 0 ]
        then
            today=$(date)
            echo " "$today"  Node looks like already stopped now."
        else
            today=$(date)
            echo " "$today"  Syncing Stopped!!! Aptos_storage_ledger_version : "$count2c""
            docker compose restart
        fi
    else
        if [ $count5 -gt $tilt ]
        then
            if [ $count3 -gt $ref ]
            then
                today=$(date)
                echo " "$today"  Node health is bad. Sync error count("/"min) : "$count4""
            else
                if [ $count3 -ne 0 ]
                then
                    today=$(date)
                    echo " "$today"  Node health is not bad. Sync error count("/"min) : "$count4""
                fi
            fi
        else
            if [ $count3 -eq 0 ]
            then
                today=$(date)
                echo " "$today"  Node looks like catchup completed now. Sync error count("/"min) : "$count4""
            else
                today=$(date)
                echo " "$today"  Syncing speed has fallen below 20%!! Former_version : "$count1c", Present_version : "$count2c""
                docker compose restart
            fi
        fi
    fi
    A=`expr $A + 1`
done
wget -q -O aptos_restart.sh https://raw.githubusercontent.com/shyoon71/installation-script/main/aptos_restart.sh && sudo chmod +x aptos_restart.sh && sudo nohup ./aptos_restart.sh &> restart_log.out &
exit()