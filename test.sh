#!/bin/bash
echo ""
echo "================================"
echo ""
echo "Script from  //-\ ][_ //-\ ][\][ ";
echo ""
echo "================================  This script is for \e[1m\e[33mvalidator only\e[0m."
echo ""
echo ""
count=0
sync=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep "aptos_state_sync_version")
sync=$(echo "$sync"|sed -n -e '5p')
sync3=$(echo $sync | grep -o '[0-9]*')
echo "\e[1m\e[33mSyncing Progress \e[0m"
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
    echo "\e[1m\e[32mok. \e[0m"
    count=`expr $count + 1`
else
    echo ">>>> Not ok!! <<<<"
fi
echo ""
highest=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep "highest")
highest=$(echo "$highest"|sed -n -e '5p')
highest2=$(echo $highest | grep -o '[0-9]*')
echo "\e[1m\e[33mSyncing Speed \e[0m"
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
    echo "\e[1m\e[32mok.No lag. \e[0m"
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
echo "\e[1m\e[33mInbound Connection \e[0m"
echo "================================"
echo "$in"
echo "================================"
if [ -z $in4 ]
then
    echo "Can't fetch out your connection status."
else
    if [ $in4 -eq 0 ]
    then
        echo ">>>> Not ok!! <<<< if you are already in AIT period now."
    else
        echo "\e[1m\e[32mok. \e[0m"
        count=`expr $count + 1`
    fi
fi
echo ""
out=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep "outbound")
out=$(echo "$out"|sed -n -e '1p')
out3=$(echo $out | grep -o '[0-9]*')
export out4=$(echo "${out3:(-2)}")
echo "\e[1m\e[33mOutbound Connection \e[0m"
echo "================================"
echo "$out"
echo "================================"
if [ -z $out4 ]
then
    echo "Can't fetch out your connection status."
else
    if [ $out4 -eq 0 ]
    then
        echo "\e[1m\e[32mValidators don't need to outbound. No problem. \e[0m"
    else
        echo "\e[1m\e[32mok. \e[0m"
    fi
fi
echo ""
v1=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep "aptos_consensus_vote_nil_count")
v1=$(echo "$v1"|sed -n -e '3p')
v3=$(echo $v1 | grep -o '[0-9]*')
echo "\e[1m\e[33mVoting Progress \e[0m"
echo "================================"
echo "$v1"
sleep 3
v5=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep "aptos_consensus_vote_nil_count")
v5=$(echo "$v5"|sed -n -e '3p')
v6=$(echo $v5 | grep -o '[0-9]*')
echo "$v5"
echo "================================"
if [ -z $v6 ]
then
    echo "Can't fetch out your connection status."
else
    if [ $v6 -gt $v3 ]
    then
        echo "\e[1m\e[32mok. \e[0m"
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
echo "\e[1m\e[33mConsensus Round Progess \e[0m"
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
    echo "Can't fetch out your connection status."
else
    if [ $r6 -gt $r3 ]
    then
        echo "\e[1m\e[32mok. \e[0m"
        count=`expr $count + 1`
    else
        echo ">>>> Not ok!! <<<<"
    fi
fi
echo ""

if [ -z $v7 ]
then
    echo ""
else
    v7=`echo "scale=2;$v6*100/$r6"|bc`
    echo "\e[1m\e[33mVoting Success Ratio \e[0m"
    echo "================================"
    echo 'Ratio_now : \e[1m\e[33m'$v7'%\e[0m  should be >=25% at the end of the test period.'
    echo "================================"
    echo ""
    if [[ `echo "$v7 > 60" | bc` -eq 1 ]]
    then
        count=`expr $count + 1`
    fi
fi
if [ $count -gt 3 ]
then
    if [ $count -gt 4 ]
    then
        echo "\e[1m\e[32mDone! Check result's so amazing! \e[0m"
    else
        echo "\e[1m\e[32mDone! Check result's good. \e[0m"
    fi
else
    echo "Done. You should check carefully at the parts that are "Not ok!!" now."
fi
echo ""
echo ""
echo ""
echo "\e[1m\e[33mDisk usage info \e[0m"
echo "================================"
df -h | grep "Avail"; df -h | grep "/$"
echo "================================"
echo ""
