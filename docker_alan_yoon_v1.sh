#!/bin/bash
clear
cd ~
sleep 0.1
# apt-get install figlet > /dev/null
# sleep 0.1
echo ""
echo ""
echo "============================================================="
echo "This script is made for binary compiling mode. From Alan Yoon"
echo "============================================================="
sleep 0.1
echo ""
echo ""
echo "Starting script now... "
sleep 3
if [ -f /root/aptos/public_full_node.yaml ]
then
    cp /root/aptos/public_full_node.yaml ./public_full_node.yaml.old &&
    cp /root/aptos/public_full_node.yaml ./
    sleep 2
else
    touch ./public_full_node.yaml &&
    mkdir /root/aptos
    sleep 2
fi
if [ -s /root/public_full_node.yaml ]
then
    echo ""
    echo ""
    echo ""
    sleep 1
    echo "Your 'public_full_node.yaml' file was copied and saved in /root directory. Backup is completed! "
    echo ""
    echo "If you previously ran this script, that yaml file would have been saved as extension name 'yaml.old'. "
    echo ""
    echo ""
    rm -r /var/lib/docker/volumes/aptos_db/_data/db > /dev/null &&
    echo ""
    echo ""
else
    echo ""
    echo ""
    echo "You don't have any old files, so backup and restoring process will be possible when you update node next time. "
    echo ""
    echo ""
    echo ""
fi
sleep 1
echo "Main script for installing and updating identiable aptos node starts now. "
echo ""
sleep 2
apt-get -y update
sleep 0.1
apt-get -y install apt-transport-https ca-certificates curl gnupg lsb-release
sleep 0.1
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
sleep 0.1
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sleep 0.1
apt-get -y install docker-ce docker-ce-cli containerd.io
sleep 0.1
docker --version
sleep 0.1
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version
sleep 0.1
if [ -s /root/public_full_node.yaml ]
then
    echo ""
    echo ""
else
    echo ""
    echo ""
    mkdir aptos
    sleep 0.1
    cd aptos
    slepp 0.1
    wget https://raw.githubusercontent.com/shyoon71/installation-script/main/public_full_node_docker.yaml
    mv ./public_full_node_docker.yaml ./public_full_node.yaml
    sleep 0.1
    cp /root/aptos/public_full_node.yaml /root/public_full_node.yaml &&
    sleep 2
fi
echo "Checking your state_sync_driver's version and seed status now... Don't touch your keyboard, please. "
echo ""
echo ""
cd aptos
sleep 0.1
wget https://raw.githubusercontent.com/aptos-labs/aptos-core/main/docker/compose/public_full_node/docker-compose.yaml
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
    sed -i'' -r -e "/identity:/i\          addresses:" /root/public_full_node.yaml &&
    sleep 1
    sed -i'' -r -e '/identity:/i\          - "/ip4/175.118.42.185/tcp/6180/ln-noise-ik/a950c9360c02c5ef9a02ad9a097f514b97f41a7499a2a798c530d610d3633e5c/ln-handshake/0"' /root/public_full_node.yaml
    sleep 1
    sed -i'' -r -e '/identity:/i\          role: "Upstream"' /root/public_full_node.yaml &&
    sleep 1
fi
grep -o "seeds: {}" /root/public_full_node.yaml > /root/seed.txt
if [ -s /root/seed.txt ]
then
    sed -i '/seeds:/d' /root/public_full_node.yaml &&
    sed -i'' -r -e '/Define the upstream peers to connect to/a\    seeds:' /root/public_full_node.yaml &&
    sleep 1
else
    sleep 1    
    sed -i '/{}/d' /root/public_full_node.yaml &&
    sleep 1
fi
grep -o "127.0.0.1" /root/public_full_node.yaml > /root/127001.txt
sleep 3
if [ -s /root/127001.txt ]
then
    sed -i '/127.0.0.1/d' /root/public_full_node.yaml &&
    sed -i'' -r -e '/prevent remote, incoming connections/a\    listen_address: "/ip4/0.0.0.0/tcp/6180"' /root/public_full_node.yaml &&
    sleep 2
else
    echo ""
    echo ""
fi
sleep 3
grep -o "state_sync" /root/public_full_node.yaml > /root/v2_or_not.txt &&
sleep 2
if [ -s /root/v2_or_not.txt ]
then
    echo ""
    cp /root/public_full_node.yaml /root/aptos &&
    echo "Your 'public_full_node.yaml' file was restored successfully! "
    echo ""
    echo ""
    sleep 2
    docker compose up -d &&
    sleep 2
    echo ""
    echo ""
    echo "Your node is running and checking health status now. Wait until checking process is completed! "
    echo ""
    sleep 5
    timeout 6 docker stats
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
    sleep 5
    echo "Your state_sync_driver's version config in 'public_full_node.yaml' was upgraded to v2 successfully. "
    echo ""
    echo ""
    docker compose up -d &&
    sleep 5
    echo ""
    echo ""
    echo "Your node is running and checking health status now. Wait until checking process is completed! "
    echo ""
    sleep 5
    timeout 6 docker stats
    echo ""
    echo ""
fi
echo "And from now another script for extracting your identity info and seed format for sharing starts... "
sleep 2
wget -q -O aptos_seed_format_alan_yoon.sh https://raw.githubusercontent.com/shyoon71/installation-script/main/aptos_seed_format_alan_yoon.sh && chmod +x aptos_seed_format_alan_yoon.sh && sudo /bin/bash aptos_seed_format_alan_yoon.sh > ../my_seed_format.txt && sed "s/^M//g" ../my_seed_format.txt > /dev/null && sed -i "s/'/\"/g" ../my_seed_format.txt
cat ../my_seed_format.txt
sleep 1
echo "Process for extracting identity info is completed! You can copy upper seed format on the screen directly. "
sleep 1
echo ""
echo "You can find your correct seed format file at /root directory, and copy it printed from command 'cat my_seed_format.txt'. "
sleep 5
rm -r /root/default_seed.txt 2> /dev/null &&
rm -r /root/v2_or_not.txt 2> /dev/null &&
rm -r /root/aptos.sh 2> /dev/null &&
rm -r /root/docker_alan_yoon_v1.sh 2> /dev/null &&
rm -r /root/aptos_identity.sh 2> /dev/null &&
rm -r /root/127001.txt 2> /dev/null &&
rm -r /root/seed.txt 2> /dev/null &&
sleep 5
echo ""
echo ""
echo ""
curl 127.0.0.1:9101/metrics 2> /dev/null | grep aptos_state_sync_version | grep type &&
sleep 5
echo ""
echo ""
echo "Your node is syncing Now, so be patient for a while. "
sleep 5
echo ""
echo ""
curl 127.0.0.1:9101/metrics 2> /dev/null | grep aptos_state_sync_version | grep type &&
sleep 2
echo ""
echo ""
echo "If docker is running and synced number is increasing continuously, your node can be considered as normal running state. "
sleep 3
echo ""
echo ""
echo "Done!! Have a nide day! Thanks you for using my script. From Alan Yoon(discord id: @Alan Yoon#2149). "
echo ""
echo ""
