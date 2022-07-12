#!/bin/bash
echo ""
echo ""
echo "================================"
echo ""
echo "Script from  //-\ ][_ //-\ ][\][ ";
echo ""
echo "================================"
echo ""
echo "*Notice!"
echo 'This script is for "validators installed by docker" only.'
echo 'So applying it to compilied with source code or fullnode will result in errors or info missing.'
echo ""
echo ""
sleep 3
echo "Then script starts now..."
echo ""
sleep 1
count=0
sync=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep "aptos_state_sync_version")
sync=$(echo "$sync"|sed -n -e '5p')
sync3=$(echo $sync | grep -o '[0-9]*')
echo "Syncing Progress"
echo "================================"
echo "$sync"
sleep 2
sync2=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep "aptos_state_sync_version")
sync2=$(echo "$sync2"|sed -n -e '5p')
sync4=$(echo $sync2 | grep -o '[0-9]*')
echo "$sync2"
epoch=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep "aptos_state_sync_version")
epoch=$(echo "$epoch"|sed -n -e '6p')
echo "$epoch"
echo "================================"
if [ $sync4 -gt $sync3 ]
then
    echo "ok."
    count=`expr $count + 1`
else
    echo ">>>> Not ok!! <<<<"
fi
echo ""
highest=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep "highest")
highest=$(echo "$highest"|sed -n -e '5p')
highest2=$(echo $highest | grep -o '[0-9]*')
echo "Syncing Speed"
echo "================================"
echo "$highest"
sleep 2
sync2=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep "aptos_state_sync_version")
sync2=$(echo "$sync2"|sed -n -e '5p')
sync4=$(echo $sync2 | grep -o '[0-9]*')
echo "$sync2"
echo "================================"
if [ $sync4 -gt $highest2 ]
then
    echo "ok.No lag."
    count=`expr $count + 1`
else
    if [ $highest2 -gt $sync4 ]
    then
        lag=`expr $highest2 - $sync4`
        echo 'You have to catch up with highest_version about '$lag''
    fi
fi
echo ""
in=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep "inbound")
in=$(echo "$in"|sed -n -e '1p')
in3=$(echo $in | grep -o '[0-9]*')
export in4=$(echo "${in3:(-2)}")
echo "Inbound Connection"
echo "================================"
echo "$in"
echo "================================"
if [ -z $in4 ]
then
    echo "Can't fetch out your connection status."
else
    if [ $in4 -eq 0 ]
    then
        echo "No problem if you are not in AIT period."
    else
        echo "ok."
    fi
fi
echo ""
out=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep "outbound")
out=$(echo "$out"|sed -n -e '1p')
out3=$(echo $out | grep -o '[0-9]*')
export out4=$(echo "${out3:(-2)}")
echo "Outbound Connection"
echo "================================"
echo "$out"
echo "================================"
if [ -z $out4 ]
then
    echo "Can't fetch out your connection status."
else
    if [ $out4 -eq 0 ]
    then
        echo "Validators don't need to outbound. No problem."
    else
        echo "ok."
    fi
fi
echo ""
v1=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep "aptos_consensus_vote_nil_count")
v1=$(echo "$v1"|sed -n -e '3p')
v3=$(echo $v1 | grep -o '[0-9]*')
echo "Voting Progress"
echo "================================"
echo "$v1"
sleep 4
v5=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep "aptos_consensus_vote_nil_count")
v5=$(echo "$v5"|sed -n -e '3p')
v6=$(echo $v5 | grep -o '[0-9]*')
echo "$v5"
echo "================================"
if [ -z $v6 ]
then
    echo "Can't fetch out your consensus status."
else
    if [ $v6 -gt $v3 ]
    then
        echo "ok."
        count=`expr $count + 1`
    else
        echo ">>>> Not ok!! <<<<"
    fi
fi
echo ""
sleep 2
r1=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep "aptos_consensus_current_round")
r1=$(echo "$r1"|sed -n -e '3p')
r3=$(echo $r1 | grep -o '[0-9]*')
echo "Consensus Round Progess"
echo "================================"
echo "$r1"
sleep 2
r5=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep "aptos_consensus_current_round")
r5=$(echo "$r5"|sed -n -e '3p')
r6=$(echo $r5 | grep -o '[0-9]*')
echo "$r5"
echo "================================"
if [ -z $r6 ]
then
    echo "Can't fetch out your consensus status."
else
    if [ $r6 -gt $r3 ]
    then
        echo "ok."
        count=`expr $count + 1`
    else
        echo ">>>> Not ok!! <<<<"
    fi
fi
echo ""
if [ -z $r6 ]
then
    echo ""
else
    v7=`echo "scale=2;$v6*100/$r6"|bc`
    echo "Voting Success Ratio"
    echo "============================="
    echo 'Ratio_now : '$v7'%  should be >=25% at the end of the test period.'
    echo "============================="
    echo ""
    if [[ `echo "$v7 > 60" | bc` -eq 1 ]]
    then
        count=`expr $count + 1`
    fi
fi



echo ""
sleep 2
tps=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep "aptos_consensus_last_committed_version")
tps=$(echo "$tps"|sed -n -e '3p')
tps3=$(echo $tps | grep -o '[0-9]*')
echo "Transaction Speed"
echo "================================"
echo "$tps"
sleep 5
tps2=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep "aptos_consensus_last_committed_version")
tps2=$(echo "$tps2"|sed -n -e '3p')
tps4=$(echo $tps2 | grep -o '[0-9]*')
echo "$tps2"
echo "================================"
if [ -z $tps4 ]
then
    echo "Can't fetch out your transaction status."
else
    if [ $tps4 -gt $tps3 ]
    then
        echo "ok."
        echo ""
        count=`expr $count + 1`
        tps5=`echo "scale=2;($tps4-$tps3)/5"|bc`
        echo "Transactions Per Second"
        echo "============================="
        echo 'TPS_now : '$tps5''
        echo "============================="
        echo ""
    else
        echo ">>>> Not ok!! <<<<"
    fi
fi
echo ""
if [ $count -gt 4 ]
then
    if [ $count -gt 5 ]
    then
        echo "Done! Check result's so amazing!"
    else
        echo "Done! Check result's good."
    fi
else
    echo "Done. You should check carefully at the parts that are not ok."
fi
echo ""
echo ""
sleep 2
echo "Disk Usage Info"
echo "================================"
df -h | grep "Avail"; df -h | grep "/$"
echo "================================"
echo ""
sleep 1
echo "Node Uptime"
echo "================================"
pid=$(ps -ef|grep aptos-node) 2> /dev/null
echo "$pid"|sed -n -e '1p' 2> /dev/null
up=$(pgrep -f aptos-node) 2> /dev/null
ps -p $up -o etime 2> /dev/null
echo "================================"
echo ""
