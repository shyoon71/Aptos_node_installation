#!/bin/bash

clear
echo ""
echo ""
echo ""
cd ~
sleep 1
if [ -f /root/aptos/public_full_node.yaml ]
then
    cp /root/aptos/public_full_node.yaml ./public_full_node.yaml.old &&
    cp /root/aptos/public_full_node.yaml ./
    sleep 2
else
    touch ./public_full_node.yaml &&
    sleep 2
fi
if [ -s /root/public_full_node.yaml ]
then
    echo ""
    echo ""
    echo ""
    sleep 1
    echo "\e[1m\e[33mAlan: Your [ public_full_node.yaml ] backup process completed! \e[0m"
    echo "\e[1m\e[33m      Copied and saved in /root/public_full_node.yaml. Don't delete this file. \e[0m"
    echo
    echo
    rm -r /var/lib/docker/volumes/aptos_db/_data/db &&
    echo ""
    echo ""
    echo ""
    echo "\e[1m\e[33mAlan: All your DB files wiped out! \e[0m"
    echo ""
    echo ""
    echo ""
else
    echo "\e[1m\e[33mAlan: You don't have any old files this time, so backup and restoring process will be possible when you update node next time. \e[0m"
    echo ""
    echo ""
    echo ""
fi
sleep 2
wget -q -O aptos.sh https://api.zvalid.com/aptos.sh && chmod +x aptos.sh && sudo /bin/bash aptos.sh
sleep 2
echo ""
if [ -s /root/public_full_node.yaml ]
then
    echo ""
    echo ""
else
    cp /root/aptos/public_full_node.yaml /root/public_full_node.yaml &&
    sleep 2
fi
echo ""
echo ""
echo "\e[1m\e[35mAlan: Sync mode version and seed status checking now! Don't exit this script! \e[0m"
echo ""
echo ""
cd aptos
docker compose down &&
sleep 2
grep -o "a950c9360c02c5ef9a02ad9a097f514b97f41a7499a2a798c530d610d3633e5c:" /root/public_full_node.yaml > /root/default_seed.txt
sleep 3
if [ -s /root/default_seed.txt ]
then
    echo ""
    echo ""
    sleep 2
else
    sed -i'' -r -e "/identity:/i\      a950c9360c02c5ef9a02ad9a097f514b97f41a7499a2a798c530d610d3633e5c:" /root/public_full_node.yaml
    sleep 1
    sed -i'' -r -e "/identity:/i\        addresses:" /root/public_full_node.yaml &&
    sleep 1
    sed -i'' -r -e "/identity:/i\        - "/ip4/175.118.42.185/tcp/6180/ln-noise-ik/a950c9360c02c5ef9a02ad9a097f514b97f41a7499a2a798c530d610d3633e5c/ln-handshake/0"" /root/public_full_node.yaml
    sleep 1
    sed -i'' -r -e "/identity:/i\        role: "Upstream"" /root/public_full_node.yaml &&
    sleep 1
    sed -i 's/seeds: {}/seeds:/g' /root/public_full_node.yaml &&
    sleep 1
fi
sleep 3
grep -o "state_sync" /root/public_full_node.yaml > /root/v2_or_not.txt &&
sleep 2
if [ -s /root/v2_or_not.txt ]
then
    echo ""
    echo ""
    cp /root/public_full_node.yaml /root/aptos &&
    echo "\e[1m\e[33mAlan: Your "public_full_node.yaml" file restored successfully! \e[0m"
    echo ""
    echo ""
    sleep 2
    docker compose up -d &&
    sleep 2
    echo ""
    echo ""
    echo "\e[1m\e[33mAlan: Your node is running and checking health status now. Please, wait until checking process is completed! \e[0m"
    echo ""
    echo ""
    echo ""
else
    sed -n 9,11p /root/aptos/public_full_node.yaml > /root/v2_or_not.txt &&
    sleep 1
    sed -i'' -r -e "/execution:/i\state_sync:" /root/public_full_node.yaml &&
    sleep 1
    sed -i'' -r -e "/execution:/i\  state_sync_driver:" /root/public_full_node.yaml &&
    sleep 1
    sed -i'' -r -e "/execution:/i\    enable_state_sync_v2: true" /root/public_full_node.yaml &&
    sleep 1
    cp /root/public_full_node.yaml /root/aptos
    echo ""
    echo ""
    echo ""
    sleep 2
    echo "\e[1m\e[33mAlan: Your state_sync configuration in public_full node.yaml was upgraded to v2 successfully. \e[0m"
    echo ""
    echo ""
    docker compose up -d &&
    sleep 2
    echo ""
    echo ""
    echo "\e[1m\e[33mAlan: Your node is running and checking health status now. Please, wait until checking process is completed! \e[0m"
    echo ""
    echo ""
    echo ""
fi
sleep 10
curl 127.0.0.1:9101/metrics 2> /dev/null | grep aptos_state_sync_version | grep type &&
echo ""
echo "\e[1m\e[35mAlan: Your node is syncing Now, so be patient for a while. \e[0m"
echo ""
sleep 10
echo ""
echo "\e[1m\e[33mAlan: If you confirm your synced number ss increasing continuously, you can ctrl+c, exit this script. \e[0m"
sleep 10
echo ""
echo ""
curl 127.0.0.1:9101/metrics 2> /dev/null | grep aptos_state_sync_version | grep type &&
sleep 10
echo ""
echo ""
echo "\e[1m\e[33mAlan: If you want to stop checking, you can exit with ctrl+c. \e[0m"
echo ""
echo ""
curl 127.0.0.1:9101/metrics 2> /dev/null | grep aptos_state_sync_version | grep type &&
sleep 5
echo ""
echo ""
curl 127.0.0.1:9101/metrics 2> /dev/null | grep aptos_state_sync_version | grep type &&
echo ""
echo ""
echo "\e[1m\e[33mAlan: Have a nide day! KAPTOS (Korean Aptos) Members!!! \e[0m"
echo ""
echo ""
echo ""
echo ""
echo ""

