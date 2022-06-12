#!/bin/bash
count=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_state_sync_storage_synchronizer_errors{error_label="unexpected_error"')
while true
do
    cd $HOME/aptos
    count1=$(echo $count | grep -o '[0-9]*')
    sleep 30
    count2=$(echo $count | grep -o '[0-9]*')
    count3=$(expr $count2 - $count1)
    if [ $count3 -gt 10 ]
    then
        count4=$(expr $count3 / 10)
        echo "\e[1m\e[33mSynchronizer_error is occurring, so your node shoud be restarted now... \e[0m"
        echo "\e[1m\e[33mError count per minute : \e[1m\e[35m"$count4" \e[0m"
        echo ""
        docker compose down && docker compose up -d
        echo ""
    else
        echo "\e[1m\e[33mYour node health is ok. \e[0m"
        echo "\e[1m\e[33mError count per minute : \e[1m\e[33m"$count4" \e[0m"
        echo ""
    fi
done
