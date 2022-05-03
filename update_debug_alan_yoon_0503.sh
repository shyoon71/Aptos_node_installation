#!/bin/bash

clear
cd
echo ""
echo ""
apt-get update > /dev/null &&
apt-get install figlet > /dev/null &&
echo "========================================================================================================"
figlet This script is only for 0504 debugging from AlanYoon
echo "========================================================================================================"
sleep 1
echo ""
cd /aptos
echo ""
echo -e "\e[1m\e[33mRestoring old docker-compose.yaml file... \e[0m"
docker compose down &&
sleep 1
rm docker-compose.yaml &&
sleep 1
wget https://raw.githubusercontent.com/shyoon71/installation-script/main/docker-compose.yaml &&
sleep 1
docker compose up -d &&
sleep 1
echo -e "\e[1m\e[33mDONE!! \e[0m"
echo ""
