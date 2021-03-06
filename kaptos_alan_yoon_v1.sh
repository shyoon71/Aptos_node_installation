#!/bin/bash

clear
cd ~
echo ""
echo "================================"
echo ""
echo "Script from  //-\ ][_ //-\ ][\][ ";
echo ""
echo "================================"
echo ""
sleep 2
echo ""
echo "\e[1m\e[33mStarting script now... \e[0m"
sleep 3
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
    echo "\e[1m\e[35mYour 'public_full_node.yaml' file was copied and saved in /root directory. Backup is completed! \e[0m"
    echo ""
    echo "\e[1m\e[33mIf you previously ran this script, that yaml file would have been saved as extension name 'yaml.old'. \e[0m"
    echo ""
    echo ""
    rm -r /var/lib/docker/volumes/aptos_db/_data/db &> /dev/null &&
    echo ""
    echo ""
else
    echo ""
    echo ""
    echo "\e[1m\e[33mYou don't have any old files, so backup and restoring process will be possible when you update node next time. \e[0m"
    echo ""
    echo ""
    echo ""
fi
echo "\e[1m\e[33mEnter the docker image tag name (ex. devnet_22fd977c):  \e[0m"
read tag
echo ""
echo ""
sleep 1
echo "\e[1m\e[35mMain script for installing or updating identiable aptos node starts now. \e[0m"
echo ""
echo "\e[1m\e[33mThis main script was made by Andrew | zValid(discord id: @drawrowfly#4024), thanks to Andrew! \e[0m"
echo ""
sleep 2
wget -q -O aptos.sh https://raw.githubusercontent.com/shyoon71/installation-script/main/aptos.sh && chmod +x aptos.sh && sudo /bin/bash aptos.sh
sleep 1
if [ -s /root/public_full_node.yaml ]
then
    echo ""
    echo ""
else
    echo ""
    echo ""
    cp /root/aptos/public_full_node.yaml /root/public_full_node.yaml &&
    sleep 2
fi
echo "\e[1m\e[35mChecking your state_sync_driver's version and seed status now... Don't touch your keyboard, please. \e[0m"
echo ""
echo ""
cd aptos
docker compose down --volumes &&
sleep 2
grep -o "6180:6180" /root/aptos/docker-compose.yaml > /root/6180.txt
sleep 0.5
if [ -s /root/6180.txt ]
then
    echo ""
    echo ""
    sleep 0.5
else
    sed -i'' -r -e '/volumes:/i\      - "6180:6180"' /root/aptos/docker-compose.yaml
    sleep 0.5
fi
# grep -o "bb14af025d226288a3488b4433cf5cb54d6a710365a2d95ac6ffbd9b9198a86a:" /root/public_full_node.yaml > /root/admin_seed.txt
# sleep 2
# if [ -s /root/admin_seed.txt ]
# then
#     echo ""
#     echo ""
#     sleep 1
# else
#     sed -i'' -r -e "/identity:/i\      bb14af025d226288a3488b4433cf5cb54d6a710365a2d95ac6ffbd9b9198a86a:" /root/public_full_node.yaml
#     sleep 1
#     sed -i'' -r -e "/identity:/i\          addresses:" /root/public_full_node.yaml &&
#     sleep 1
#     sed -i'' -r -e '/identity:/i\          - "/dns4/pfn0.node.devnet.aptoslabs.com/tcp/6182/noise-ik/bb14af025d226288a3488b4433cf5cb54d6a710365a2d95ac6ffbd9b9198a86a/handshake/0"' /root/public_full_node.yaml
#     sleep 1
#     sed -i'' -r -e '/identity:/i\          role: "Upstream"' /root/public_full_node.yaml &&
#     sleep 1
# fi
grep -o "a950c9360c02c5ef9a02ad9a097f514b97f41a7499a2a798c530d610d3633e5c:" /root/public_full_node.yaml > /root/default_seed.txt
sleep 2
if [ -s /root/default_seed.txt ]
then
    echo ""
    echo ""
    sleep 1
else
    sed -i'' -r -e "/identity:/i\      a950c9360c02c5ef9a02ad9a097f514b97f41a7499a2a798c530d610d3633e5c:" /root/public_full_node.yaml
    sleep 1
    sed -i'' -r -e "/identity:/i\          addresses:" /root/public_full_node.yaml &&
    sleep 1
    sed -i'' -r -e '/identity:/i\          - "/ip4/180.71.88.95/tcp/6180/noise-ik/a950c9360c02c5ef9a02ad9a097f514b97f41a7499a2a798c530d610d3633e5c/handshake/0"' /root/public_full_node.yaml
    sleep 1
    sed -i'' -r -e '/identity:/i\          role: "Upstream"' /root/public_full_node.yaml &&
    sleep 1
fi
grep -o "seeds: {}" /root/public_full_node.yaml > /root/seed.txt
if [ -s /root/seed.txt ]
then
    sed -i '/seeds:/d' /root/public_full_node.yaml &&
    sed -i'' -r -e '/upstream peers/a\    seeds:' /root/public_full_node.yaml &&
    sleep 1
else
    sleep 1    
    sed -i '/{}/d' /root/public_full_node.yaml &&
    sleep 1
fi
grep -o "state_sync" /root/public_full_node.yaml > /root/v2_or_not.txt &&
sleep 2
if [ -s /root/v2_or_not.txt ]
then
    sed -i '/state_sync:/d' /root/public_full_node.yaml &&
    sleep 0.2
    sed -i '/state_sync_driver:/d' /root/public_full_node.yaml &&
    sleep 0.2
    sed -i '/enable_state_sync_v2:/d' /root/public_full_node.yaml &&
    sleep 0.2
    sed -i'' -r -e "/execution:/i\state_sync:" /root/public_full_node.yaml &&
    sleep 0.2
    sed -i'' -r -e "/execution:/i\  state_sync_driver:" /root/public_full_node.yaml &&
    sleep 0.2
    sed -i'' -r -e "/execution:/i\    enable_state_sync_v2: true" /root/public_full_node.yaml &&
    sleep 0.2
else
    sed -i'' -r -e "/execution:/i\state_sync:" /root/public_full_node.yaml &&
    sleep 0.2
    sed -i'' -r -e "/execution:/i\  state_sync_driver:" /root/public_full_node.yaml &&
    sleep 0.2
    sed -i'' -r -e "/execution:/i\    enable_state_sync_v2: true" /root/public_full_node.yaml &&
    sleep 0.2
fi
grep -o "127.0.0.1" /root/public_full_node.yaml > /root/127001.txt &&
sleep 0.2
if [ -s /root/127001.txt ]
then
    sed -i "s/127.0.0.1/0.0.0.0/g" /root/public_full_node.yaml &&
    sleep 1
fi
grep -o "enabled: true" /root/public_full_node.yaml > /root/api.txt
sleep 2
if [ -s /root/api.txt ]
then
    echo ""
    echo ""
    sleep 1
else
    sed -i'' -r -e "/address: 0.0.0.0:8080/i\  enabled: true" /root/public_full_node.yaml
    sleep 1
fi
grep -o ":devnet" /root/aptos/docker-compose.yaml > /root/tag.txt &&
sleep 1
if [ -s /root/tag.txt ]
then
    sed -i "s/:devnet/:$tag/g" /root/aptos/docker-compose.yaml &&
    sleep 1
fi
sleep 3
grep -o "state_sync" /root/public_full_node.yaml > /root/v2_or_not.txt &&
sleep 2
if [ -s /root/v2_or_not.txt ]
then
    echo ""
    cp /root/public_full_node.yaml /root/aptos &&
    echo ""
    sleep 1
    docker compose up -d &&
    sleep 1
    echo ""
    echo ""
    echo "\e[1m\e[35mYour node is running and checking health status now. Wait until checking process is completed! \e[0m"
    echo ""
    sleep 2
    timeout 3 docker stats
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
    sleep 1
    echo "\e[1m\e[33mYour state_sync_driver's version config in 'public_full_node.yaml' was upgraded to v2 successfully. \e[0m"
    echo ""
    echo ""
    docker compose up -d &&
    sleep 2
    echo ""
    echo ""
    echo "\e[1m\e[35mYour node is running and checking health status now. Wait until checking process is completed! \e[0m"
    echo ""
    sleep 2
    timeout 3 docker stats
    echo ""
    echo ""
fi
echo "\e[1m\e[35mAnd from now another script for extracting your identity info and seed format for sharing starts... \e[0m"
echo 1
wget -q -O aptos_seed_format_alan_yoon.sh https://raw.githubusercontent.com/shyoon71/installation-script/main/aptos_seed_format_alan_yoon.sh && chmod +x aptos_seed_format_alan_yoon.sh && sudo /bin/bash aptos_seed_format_alan_yoon.sh > ../my_seed_format.txt && sed "s/^M//g" ../my_seed_format.txt > /dev/null && sed -i "s/'/\"/g" ../my_seed_format.txt
cat ../my_seed_format.txt
sleep 1
echo "\e[1m\e[33mProcess for extracting identity info is completed! You can copy upper seed format on the screen directly. \e[0m"
sleep 1
echo ""
echo "\e[1m\e[35mYou can find your correct seed format file at /root directory, and copy it printed from command 'cat my_seed_format.txt'. \e[0m"
sleep 5
rm /root/default_seed.txt &> /dev/null &&
rm /root/v2_or_not.txt &> /dev/null &&
rm /root/aptos.sh &> /dev/null &&
rm /root/kaptos_alan_yoon_v1.sh &> /dev/null &&
rm /root/127001.txt &> /dev/null &&
rm /root/seed.txt &> /dev/null &&
rm /root/6180.txt &> /dev/null &&
rm /root/tag.txt &> /dev/null &&
rm /root/api.txt &> /dev/null &&
#rm /root/admin_seed.txt &> /dev/null &&
sleep 1
echo ""
echo ""
echo ""
curl 127.0.0.1:9101/metrics 2> /dev/null | grep aptos_state_sync_version | grep type &&
sleep 1
echo ""
echo ""
echo "\e[1m\e[35mYour node is syncing Now, so be patient for a while. \e[0m"
sleep 5
echo ""
echo ""
curl 127.0.0.1:9101/metrics 2> /dev/null | grep aptos_state_sync_version | grep type &&
sleep 1
echo ""
echo ""
echo "\e[1m\e[35mIf docker is running and synced number is increasing continuously, your node can be considered as normal running state. \e[0m"
sleep 2
echo ""
echo ""
echo "\e[1m\e[33mDone!! Have a nide day! Thanks you for using my script. From Alan Yoon(discord id: @Alan Yoon#2149). \e[0m"
echo ""
echo ""
wget -q -O command_alan_yoon.sh https://raw.githubusercontent.com/shyoon71/installation-script/main/command_alan_yoon.sh && chmod +x command_alan_yoon.sh
sleep 0.2
wget -q -O disk.sh https://raw.githubusercontent.com/shyoon71/installation-script/main/disk.sh && chmod +x disk.sh && sudo sh disk.sh
sleep 0.2
echo ""
echo ""
echo "========================================================================"

echo "\e[1m\e[33mDocker mode Aptos node command list  >> input at /root/aptos directory!! \e[0m"

echo "========================================================================"

echo "\e[1m\e[32mTo print this command list: \e[0m" 
echo "\e[1m\e[39m    sh command_alan_yoon.sh  or  sh command* \n \e[0m" 

echo "\e[1m\e[32mTo stop the Aptos node: \e[0m" 
echo "\e[1m\e[39m    docker compose stop \n \e[0m" 

echo "\e[1m\e[32mTo start the Aptos node: \e[0m" 
echo "\e[1m\e[39m    docker compose start \n \e[0m" 

echo "\e[1m\e[32mTo check the Aptos node Logs:  >> To stop inut ctrl+c \e[0m" 
echo "\e[1m\e[39m    docker compose logs -f --tail 1000 \n \e[0m" 

echo "\e[1m\e[32mTo check outbound connection status: >> If number is not 0, it's ok! \e[0m" 
echo "\e[1m\e[39m    curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_connections{direction=\"outbound\"' \e[0m"

echo "\e[1m\e[32mTo check syncd status: >> The third [synced] number is matter! \e[0m" 
echo "\e[1m\e[39m    curl 127.0.0.1:9101/metrics 2> /dev/null | grep aptos_state_sync_version | grep type \n \e[0m"

echo "\e[1m\e[32mTo check docker cpu and memory utilization status:  >> CPU % and MEM % is matter!! \e[0m" 
echo "\e[1m\e[39m    docker stats --no-stream \n \e[0m" 
echo ""
echo ""
