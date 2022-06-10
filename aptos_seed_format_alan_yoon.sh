#!/bin/bash
echo ""
echo ""
apt-get update &> /dev/null &&
apt-get install figlet &> /dev/null &&
echo "==========================================="
figlet AlanYoon
echo "==========================================="
sleep 1
echo ""
echo ""
echo -e "\e[1m\e[33mSearching your info now... \e[0m"
sleep 5
if [ -f $HOME/aptos/identity/private-key.txt ]
then
    ID=$(sed -n 2p $HOME/aptos/identity/peer-info.yaml | sed 's/\(.*\):/\1/')
    ID=${ID//$'\r'/}
    PRIVATE_KEY=$(cat $HOME/aptos/identity/private-key.txt)
    curl icanhazip.com > ip.txt
    sleep 0.1
    IP=$(cat ./ip.txt)
    sleep 0.1
    echo -en "\n"
    echo -en "\n"
    echo -e "\e[1m\e[33mYour Seed Format \e[0m" 
    echo "=================================================================================================================================="
    echo -e ' 
'$ID':
    addresses: 
    - "/ip4/\e[1m\e[33m'$IP'\e[0m/tcp/6180/noise-ik/'$ID'/handshake/0"
    role: "Upstream"'
    echo "=================================================================================================================================="
    echo -e "\e[1m\e[33mUpper IP address is your server's external IP address acquired by command 'curl icanhazip.com'. \e[0m"
    echo -en "\n"
    echo -en "\n"
    echo -e "\e[1m\e[33mYour ID and Keys \e[0m" 
    echo "=================================================================================================================================="
    echo -en "\n"
    echo -e "Peer Id: \e[0m" $ID
    echo -e "Public Key: \e[0m" $ID
    echo -e "Private Key:  \e[0m" $PRIVATE_KEY
    echo "=================================================================================================================================="
    echo -en "\n"
    echo -en "\n"
else
    echo -e "\e[1m\e[32mCan't find 'private-key.txt' file: "$HOME/aptos/identity"  \e[0m" 
fi
rm aptos_seed_format_alan_yoon.sh &> /dev/null &&
rm ip.txt &> /dev/null &&
echo ""
echo ""
echo ""