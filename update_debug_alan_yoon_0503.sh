#!/bin/bash

clear
cd /root/aptos &&
sleep 2
echo ""
echo ""
apt-get update > /dev/null &&
apt-get install figlet > /dev/null &&
figlet This script is only for 0504 debugging from AlanYoon
sleep 1
echo ""
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
