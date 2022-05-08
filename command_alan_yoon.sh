#!/bin/bash

echo "=================================================="

echo -e "\e[1m\e[32mBinary mode command list \e[0m"

echo "=================================================="

echo -e "\e[1m\e[32mTo stop the Aptos Node: \e[0m" 
echo -e "\e[1m\e[39m    systemctl stop aptos-fullnode \n \e[0m" 

echo -e "\e[1m\e[32mTo start the Aptos Node: \e[0m" 
echo -e "\e[1m\e[39m    systemctl start aptos-fullnode \n \e[0m" 

echo -e "\e[1m\e[32mTo check the Aptos Node Logs: \e[0m" 
echo -e "\e[1m\e[39m    journalctl -u aptos-fullnode -f \n \e[0m" 

echo -e "\e[1m\e[32mTo check the node status: \e[0m" 
echo -e "\e[1m\e[39m    curl 127.0.0.1:9101/metrics 2> /dev/null | grep aptos_state_sync_version | grep type \n \e[0m"
