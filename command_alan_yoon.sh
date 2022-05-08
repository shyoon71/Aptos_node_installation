#!/bin/bash

echo "=================================================="

echo "\e[1m\e[32mBinary mode Aptos node command list \e[0m"

echo "=================================================="

echo "\e[1m\e[32mTo stop the Aptos node: \e[0m" 
echo "\e[1m\e[39m    systemctl stop aptos-fullnode \n \e[0m" 

echo "\e[1m\e[32mTo start the Aptos node: \e[0m" 
echo "\e[1m\e[39m    systemctl start aptos-fullnode \n \e[0m" 

echo "\e[1m\e[32mTo check the Aptos node Logs: \e[0m" 
echo "\e[1m\e[39m    journalctl -u aptos-fullnode -f \n \e[0m" 

echo "\e[1m\e[32mTo check the node syncd status:  >> The third [synced] number is matter!! \e[0m" 
echo "\e[1m\e[39m    curl 127.0.0.1:9101/metrics 2> /dev/null | grep aptos_state_sync_version | grep type \n \e[0m"


echo "=========================================================================="

echo "\e[1m\e[32mDocker mode Aptos node command list  >> input commands at /root/aptos directory!! \e[0m"

echo "=========================================================================="

echo "\e[1m\e[32mTo stop the Aptos node: \e[0m" 
echo "\e[1m\e[39m    docker compose stop \n \e[0m" 

echo "\e[1m\e[32mTo start the Aptos node: \e[0m" 
echo "\e[1m\e[39m    docker compose start \n \e[0m" 

echo "\e[1m\e[32mTo check the Aptos node Logs: \e[0m" 
echo "\e[1m\e[39m    docker compose logs -f --tail 1000 \n \e[0m" 

echo "\e[1m\e[32mTo check the node syncd status: >> The third [synced] number is matter! \e[0m" 
echo "\e[1m\e[39m    curl 127.0.0.1:9101/metrics 2> /dev/null | grep aptos_state_sync_version | grep type \n \e[0m"

echo "\e[1m\e[32mTo check docker cpu and memory utilization status:  >> CPU % and MEM % is matter!! \e[0m" 
echo "\e[1m\e[39m    docker stats --no-stream \n \e[0m" 
