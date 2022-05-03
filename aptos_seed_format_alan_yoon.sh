#!/bin/bash

if [ -f $HOME/aptos/identity/private-key.txt ]
then
    ID=$(sed -n 2p $HOME/aptos/identity/peer-info.yaml | sed 's/\(.*\):/\1/')
    ID=${ID//$'\r'/}
    PRIVATE_KEY=$(cat $HOME/aptos/identity/private-key.txt)
    IP=$(ip route get 8.8.8.8 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}')
    echo -en "\n"
    echo -en "\n"
    echo -e "\e[1m\e[33mYour Seed Format For Sharing \e[0m" 
    echo "============================================================================================================================"
    echo ' 
'$ID':
  addresses: 
  - "/ip4/'$IP'/tcp/6180/ln-noise-ik/'$ID'/ln-handshake/0"
  role: "Upstream"'
    echo "============================================================================================================================"
    echo -en "\n"
    echo -en "\n"
    echo -e "\e[1m\e[33mYour ID and Keys \e[0m" 
    echo "============================================================================================================================"
    echo -en "\n"
    echo -e "Peer Id: \e[0m" $ID
    echo -e "Public Key: \e[0m" $ID
    echo -e "Private Key:  \e[0m" $PRIVATE_KEY
    echo "============================================================================================================================"
    echo -en "\n"
    echo -en "\n"
else
    echo -e "\e[1m\e[32mCan't find 'private-key.txt' file: "$HOME/aptos/identity"  \e[0m" 
fi
