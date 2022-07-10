#!/bin/bash
echo ""
echo "================================"
echo ""
echo "Script from  //-\ ][_ //-\ ][\][ ";
echo '                                  This script is for "validators installed by docker" only.'
echo "================================"
echo ""
echo ""
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
tps=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep "aptos_consensus_channel_msgs_count")
tps=$(echo "$tps"|sed -n -e '3p')
tps3=$(echo $tps | grep -o '[0-9]*')
echo "Transaction Speed"
echo "================================"
echo "$tps"
sleep 5
tps2=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep "aptos_consensus_channel_msgs_count")
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
echo ""
echo "Disk Usage Info"
echo "================================"
df -h | grep "Avail"; df -h | grep "/$"
echo "================================"
echo ""
echo "Node Uptime"
echo "================================"
pro_nm="aptos-node"
pro_sday=`ps -eo lstart,pid,cmd|grep -w "$pro_nm" |grep -v "grep" |
awk '{ 
       cmd="date -d\""$1 FS $2 FS $3 FS $4 FS $5"\" +\047%Y-%m-%d %H:%M:%S\047"; 
       cmd | getline d; close(cmd); $1=$2=$3=$4=$5=""; printf "%s\n",d$0 }' 2>/dev/null |
       awk '{print $1}'`
pro_cday=`date +%Y-%m-%d`
pro_sday_sec=`date -d $pro_sday +%s`
pro_cday_sec=`date -d $pro_cday +%s`
day_sec_diff=`echo "($pro_cday_sec - $pro_sday_sec) / 86400" |bc`
echo "Process $pro_nm has been running for more than" $day_sec_diff "days."
ps -eo pid,etime,cmd | grep aptos-node | grep -v grep
echo "================================"
echo ""