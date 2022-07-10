#!/bin/bash
echo ""
echo "================================"
echo ""
echo "Script from  //-\ ][_ //-\ ][\][ ";
echo ""
echo "================================  This script is for validator only."
echo ""
echo ""
count=0
highest=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep "highest")
highest=$(echo "$highest"|sed -n -e '5p')
highest2=$(echo $highest | grep -o '[0-9]*')
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
else
    if [ $highest2 -gt $sync4 ]
    then
        lag=`expr $highest2 - $sync4`
        echo 'You have to catch up with highest_version about '$lag''
    fi
fi
echo ""
sync=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep "aptos_state_sync_version")
sync=$(echo "$sync"|sed -n -e '5p')
sync3=$(echo $sync | grep -o '[0-9]*')
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
sleep 2
in=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep "inbound")
in=$(echo "$in"|sed -n -e '1p')
in3=$(echo $in | grep -o '[0-9]*')
export in4=$(echo "${in3:(-2)}")
echo "================================"
echo "$in"
echo "================================"
if [ -z $in4 ]
then
    echo ">>>> Not ok!! <<<<"
else
    if [ $in4 -eq 0 ]
    then
        echo ">>>> Not ok!! <<<< if you are already in AIT period now."
    else
        echo "ok"
        count=`expr $count + 1`
    fi
fi
echo ""
out=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep "outbound")
out=$(echo "$out"|sed -n -e '1p')
out3=$(echo $out | grep -o '[0-9]*')
export out4=$(echo "${out3:(-2)}")
echo "================================"
echo "$out"
echo "================================"
if [ -z $out4 ]
then
    echo "Validator has no peers. No problem."
else
    if [ $out4 -eq 0 ]
    then
        echo "Validator has no peers. No problem."
    else
        echo "ok"
    fi
fi
echo ""
v1=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep "aptos_consensus_vote_nil_count")
v1=$(echo "$v1"|sed -n -e '3p')
v3=$(echo $v1 | grep -o '[0-9]*')
echo "================================"
echo "$v1"
sleep 3
v5=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep "aptos_consensus_vote_nil_count")
v5=$(echo "$v5"|sed -n -e '3p')
v6=$(echo $v5 | grep -o '[0-9]*')
echo "$v5"
echo "================================"
if [ $v6 -gt $v3 ]
then
    echo "ok."
    count=`expr $count + 1`
else
    echo ">>>> Not ok!! <<<<"
fi
echo ""
sleep 2
r1=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep "aptos_consensus_current_round")
r1=$(echo "$r1"|sed -n -e '3p')
r3=$(echo $r1 | grep -o '[0-9]*')
echo "================================"
echo "$r1"
sleep 2
r5=$(curl 127.0.0.1:9101/metrics 2> /dev/null | grep "aptos_consensus_current_round")
r5=$(echo "$r5"|sed -n -e '3p')
r6=$(echo $r5 | grep -o '[0-9]*')
echo "$r5"
echo "================================"
if [ $r6 -gt $r3 ]
then
    echo "ok."
    count=`expr $count + 1`
else
    echo ">>>> Not ok!! <<<<"
fi
echo ""
v7=`echo "scale=2;$v6*100/$r6"|bc`
echo "================================"
echo 'vote_rate_now : '$v7'%  should be >=25% at the end of the test period.'
echo "================================"
echo ""
if [[ `echo "$v7 > 60" | bc` -eq 1 ]]
then
    count=`expr $count + 1`
fi
if [ $count -gt 3 ]
then
    if [ $count -gt 4 ]
    then
        echo "Done! Check result's so amazing!"
    else
        echo "Done! Check result's good."
    fi
else
    echo "Done. You should check carefully at the parts that are "Not ok!!" now."
fi
echo ""
echo "Disk usage info:"
echo "================================"
df -h | grep "Avail"; df -h | grep "/$"
echo "================================"
echo ""
