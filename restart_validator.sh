#!/bin/bash
echo ""
echo "================================"
echo ""
echo "Script from  //-\ ][_ //-\ ][\][ ";
echo ""
echo "================================"
echo ""
echo "*Notice!"
echo 'This script is for "validators installed by docker" only.'
echo 'So applying it to compilied with source code or fullnode will result in errors or malfunction.'
echo 'Enter "tail -n 100 restart_log.out" to check logs.'
echo ""
A=1
B=1
P=0
PP=1
PPP=25
while [ $A -lt 10081 ]
do
    let P=$P+1
    if [ $P -eq $PP ]
    then
        today=$(date)
        proposala=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_consensus_proposals_count')
        proposala=$(echo "$proposala"|sed -n -e '3p')
        echo "================================"
        echo " "$today"  Proposal checkpoint: start tracing --- "$proposala""
        echo "================================"
        proposalb=$(echo "$proposala" | grep -o '[0-9]*')
        if [ -z $proposalb ]
        then
            proposalb=0
        fi
    fi
    if [ $P -eq $PPP ]
    then
        today=$(date)
        proposalc=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_consensus_proposals_count')
        proposalc=$(echo "$proposalc"|sed -n -e '3p')
        echo "================================"
        echo " "$today"  Proposal re-checkpoint: comparing ---- "$proposalc""
        echo "================================"
        proposald=$(echo "$proposalc" | grep -o '[0-9]*')
        if [ -z $proposald ]
        then
            proposald=0
        fi
        if [ $proposald -eq $proposalb ]
        then
            echo " "$today"  Proposal stopped!!! Non-increasing during 25 minutes."
            echo " "$today"  Node should be restarted!!"
            docker compose stop
            sleep 10
            docker compose start
            P=0
            B=1
        else
            echo " "$today"  ok."
            P=0
        fi
    fi
    counta=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_consensus_error_count')
    counta=$(echo "$counta"|sed -n -e '3p')
    sleep 1
    countb=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_consensus_timeout_rounds_count')
    countb=$(echo "$countb"|sed -n -e '3p')
    sleep 1
    countbb=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_data_streaming_service_received_response_error')
    countbb=$(echo "$countbb"|sed -n -e '1p') &> /dev/null
    sleep 1
    countc=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_state_sync_version{type="synced"}')
    countc=$(echo "$countc"|sed -n -e '1p')
    sleep 1
    ref=40
    count1a=$(echo $counta | grep -o '[0-9]*')
    if [ -z $count1a ]
    then
        count1a=0
    fi
    count1b=$(echo $countb | grep -o '[0-9]*')
    if [ -z $count1b ]
    then
        count1b=0
    fi
    count1bb=$(echo $countbb | grep -o '[0-9]*')
    if [ -z $count1bb ]
    then
        count1bb=0
    fi
    count1c=$(echo $countc | grep -o '[0-9]*')
    if [ -z $count1c ]
    then
        count1c=0
    fi
    sleep 50
    counta=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_consensus_error_count')
    counta=$(echo "$counta"|sed -n -e '3p')
    sleep 1
    countb=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_consensus_timeout_rounds_count')
    countb=$(echo "$countb"|sed -n -e '3p')
    sleep 1
    countbb=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_data_streaming_service_received_response_error')
    countbb=$(echo "$countbb"|sed -n -e '1p') &> /dev/null
    sleep 1
    countc=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_state_sync_version{type="synced"}')
    countc=$(echo "$countc"|sed -n -e '1p')
    sleep 1
    outbound=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep "outbound")
    outbound=$(echo "$outbound"|sed -n -e '1p')
    sleep 1
    outbound=$(echo $outbound | grep -o '[0-9]*')
    export outbound1=$(echo "${outbound:(-3)}")
    count2a=$(echo $counta | grep -o '[0-9]*')
    if [ -z $count2a ]
    then
        count2a=0
    fi
    count2b=$(echo $countb | grep -o '[0-9]*')
    if [ -z $count2b ]
    then
        count2b=0
    fi
    count2bb=$(echo $countbb | grep -o '[0-9]*')
    if [ -z $count2bb ]
    then
        count2bb=0
    fi
    count2c=$(echo $countc | grep -o '[0-9]*')
    if [ -z $count2c ]
    then
        count2c=0
    fi
    count3=$((count2a + count2b + count2bb - count1a - count1b - count1bb))
    count4=$((count3 / 1))
    count45=$(echo $count5)
    tilt=$((count45 / 10))
    count5=$((count2c - count1c))
    sleep 1
    dockera=$(docker ps | grep aptoslab)
    dockera=$(echo $dockera | grep -o '[0-9]*')
    if [ -z $count2c ]
    then
        dockera=0
    else
        dockera=1
    fi
    if [ $count5 -eq 0 ]
    then
        if [ $count3 -eq 0 ]
        then
            if [ -z $outbound1 ]
            then
                if [ $dockera -eq 0 ]
                then
                    today=$(date)
                    echo " "$today"  Node already stopped!! Docker exited, too!!"
                    echo " "$today"  The cause is unknown. Or maybe you manually down the node."
                    echo " "$today"  This script won't restart node for now."
                    B=`expr $B + 1`
                    if [ $B -eq 6 ]
                    then
                        today=$(date)
                        echo " "$today"  5 minutes already passed with the node stopped status."
                        echo " "$today"  The node must continue to run!!"
                        docker compose stop
                        sleep 10
                        docker compose start
                        B=1
                    fi
                else
                    today=$(date)
                    echo " "$today"  Syncing is definitely Stopped!!! No outbound connection!!"
                    echo " "$today"  The node should be restarted!! Check your node health or figures of indicator!!"
                    docker compose stop
                    sleep 10
                    docker compose start
                    B=1
                fi
            fi
        else
            today=$(date)
            echo " "$today"  Syncing is definitely stopped!!! Version freezed!!! : "$count2c""
            docker compose stop
            sleep 10
            docker compose start
            B=1
        fi
    else
        if [ $count5 -gt $tilt ]
        then
            if [ $count3 -gt $ref ]
            then
                today=$(date)
                echo " "$today"  Node status is unstable. Sync and consensus error "$count4""/"min occurred."
            else
                if [ $count3 -ne 0 ]
                then
                    today=$(date)
                    echo " "$today"  Node health is not bad. Sync and consensus error "$count4""/"min occurred."
                fi
            fi
        else
            if [ $count3 -eq 0 ]
            then
                if [ -z $count2c ]
                then
                    today=$(date)
                    echo " "$today"  Node stopped !! Syncing stopped, too!! Previous_synced : "$count1c""
                    echo " "$today"  The cause is unknown. Or maybe you manually down the node."
                    echo " "$today"  This script won't restart node for now."
                    B=`expr $B + 1`
                    if [ $B -eq 6 ]
                    then
                        today=$(date)
                        echo " "$today"  5 minutes already passed with the node stopped status."
                        echo " "$today"  The node must continue to run!!"
                        docker compose stop
                        sleep 10
                        docker compose start
                        B=1
                    fi
                else
                    today=$(date)
                    echo " "$today"  Node is finishing catchup now. Syncing well done."
                    echo " "$today"  Previous_synced : "$count1c", Present_synced : "$count2c""
                fi
            else
                if [ $count3 -gt $ref ]
                then
                    today=$(date)
                    echo " "$today"  Node status is unstable. Sync and consensus error "$count4""/"min occurred."
                    echo " "$today"  Syncing speed has fallen below 10% compared to normal!!"
                    echo " "$today"  Previous_synced : "$count1c", Present_synced : "$count2c""
                    docker compose stop
                    sleep 10
                    docker compose start
                    B=1
                else
                    if [ -z $count2c ]
                    then
                        today=$(date)
                        echo " "$today"  Node stopped !! Syncing stopped, too!! Previous_synced : "$count1c""
                        echo " "$today"  The cause is unknown. Or maybe you manually down the node."
                        echo " "$today"  This script won't restart node for now."
                        B=`expr $B + 1`
                        if [ $B -eq 6 ]
                        then
                            today=$(date)
                            echo " "$today"  5 minutes already passed with the node stopped status."
                            echo " "$today"  The node must continue to run!!"
                            docker compose stop
                            sleep 10
                            docker compose start
                            B=1
                        fi
                    else
                        today=$(date)
                        echo " "$today"  Syncing speed has fallen below 10% compared to normal!!"
                        echo " "$today"  It looks like catchup has just been finished"
                        echo " "$today"  Previous_synced : "$count1c", Present_synced : "$count2c""
                    fi
                fi
            fi
        fi
    fi
    A=`expr $A + 1`
done
#rm ./restart_log.old &> /dev/null
#mv ./restart_log.out ./restart_log.old &> /dev/null
#sudo wget -q -O restart_validator.sh https://raw.githubusercontent.com/shyoon71/installation-script/main/restart_validator.sh && sudo chmod +x restart_validator.sh && sudo nohup ./restart_validator.sh &> restart_log.out &
exit()
