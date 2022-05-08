#!/bin/bash

clear
cd ~
sleep 0.1
apt-get install figlet > /dev/null &&
echo ""
echo ""
echo "==========================================="
figlet AlanYoon
echo "==========================================="
sleep 0.1
echo ""
echo ""
echo "Preparing source code compiling environment now... "
sleep 2
echo ""
echo ""
echo "You should select and inpout yes or 1 for all questions form script from now... "
sleep 5
echo ""
echo ""
if [ -f /root/aptos-core/public_full_node.yaml ]
then
    cp /root/aptos-core/public_full_node.yaml /root/public_full_node.yaml.old
    sleep 0.1
    cp /root/aptos-core/public_full_node.yaml /root
    sleep 0.1
    rm -r aptos-core
    sleep 0.1
else
    touch /root/public_full_node.yaml
    sleep 0.1
fi
git clone https://github.com/shyoon71/aptos-core
sleep 0.1
cd /root/aptos-core
sleep 0.1
mkdir data
echo ""
# cargo install --git https://github.com/aptos-labs/aptos-core.git aptos
# sleep 0.1
# which aptos
# cargo build
sleep 0.1
if [ -s /root/public_full_node.yaml ]
then
    echo ""
    echo ""
    echo ""
    sleep 0.1
    echo "Your 'public_full_node.yaml' file was copied and saved in /'root' directory. Backup is completed! "
    echo ""
    echo "If you previously ran this script, that yaml file would have been saved as extension name 'yaml.old'. "
    sleep 6
    echo ""
    echo ""
    sleep 0.1
else
    echo ""
    echo ""
    echo "You don't have any old files, so backup and restoring process will be possible when you update node next time. "
    sleep 6
    echo ""
    echo ""
    echo ""
fi
echo "Updating source files from APTOS devnet repo... "
sleep 2
echo ""
echo ""
./script/dev_setup.sh
sleep 0.1
source ~/.cargo/env
sleep 0.1
git checkout --track origin/devnet
sleep 0.1
cargo build
sleep 0.1
echo ""
echo ""
echo "Downloading new configurarion files for your node update... "
sleep 5
echo ""
wget https://devnet.aptoslabs.com/genesis.blob
sleep 1
wget https://devnet.aptoslabs.com/waypoint.txt
sleep 0.1
if [ -f /root/private_key.txt ]
then
    echo ""
    echo ""
else
    echo ""
    echo ""
    rm /root/public_full_node.yaml > /dev/null
    sleep 0.1
    wget https://raw.githubusercontent.com/shyoon71/installation-script/main/public_full_node_docker.yaml -P /root
    mv /root/public_full_node_docker.yaml ./public_full_node.yaml
    sleep 0.1
    cp /root//public_full_node.yaml /root/aptos-core
    sleep 0.1
    echo "Generating your private key and peer id... "
    sleep 2
    echo ""
#   docker run -i -t -v /root:/root aptoslab/tools:devnet /bin/bash
    cargo run -p aptos-operational-tool -- generate-key --encoding hex --key-type x25519 --key-file /root/private_key.txt
    sleep 0.5
    cargo run -p aptos-operational-tool -- extract-peer-from-file --encoding hex --key-file /root/private_key.txt --output-file /root/peer_info.yaml
    sleep 0.5
#   ./aptos-operational-tool extract-peer-from-file --encoding hex --key-file /root/private_key.txt --output-file /root/peer-info.yaml
#   sleep 0.1
    cd /root/aptos-core
    sleep 2
#   ID=$(sed -n 2p /root/private_key.txt.pub | sed 's/\(.*\):/\1/')
#   ID=${ID//$'\r'/}
    ID=$(sed -n 2p /root/peer_info.yaml | sed 's/.$//')
    sleep 0.1
    PRIVATE_KEY=$(cat /root/private_key.txt)
    sleep 0.1
    sed -i'' -e "s/<PEER-ID>/$ID/g" /root/public_full_node.yaml
    sleep 0.1
    sed -i'' -e "s/<PRIVATE_KEY>/$PRIVATE_KEY/g" /root/public_full_node.yaml
    sleep 0.1
fi
cd /root/aptos-core 2> /dev/null
sleep 0.1
grep -o "a950c9360c02c5ef9a02ad9a097f514b97f41a7499a2a798c530d610d3633e5c:" /root/public_full_node.yaml > /root/default_seed.txt
sleep 0.1
if [ -s /root/default_seed.txt ]
then
    sleep 0.1
else
    sed -i'' -r -e "/identity:/i\      a950c9360c02c5ef9a02ad9a097f514b97f41a7499a2a798c530d610d3633e5c:" /root/public_full_node.yaml
    sleep 0.1
    sed -i'' -r -e "/identity:/i\          addresses:" /root/public_full_node.yaml
    sleep 0.1
    sed -i'' -r -e '/identity:/i\          - "/ip4/175.118.42.185/tcp/6180/ln-noise-ik/a950c9360c02c5ef9a02ad9a097f514b97f41a7499a2a798c530d610d3633e5c/ln-handshake/0"' /root/public_full_node.yaml
    sleep 0.1
    sed -i'' -r -e '/identity:/i\          role: "Upstream"' /root/public_full_node.yaml
    sleep 0.1
fi
WAYPOINT=$(cat /root/aptos-core/waypoint.txt)
sleep 0.1
sed -i'' -e "s/<WAYPOINT>/$WAYPOINT/g" /root/public_full_node.yaml
sleep 0.1
grep -o "seeds: {}" /root/public_full_node.yaml > /root/seed.txt
sleep 0.1
if [ -s /root/seed.txt ]
then
    sleep 0.1
    sed -i'' -e '/seeds:/d' /root/public_full_node.yaml
    sleep 0.1
    sed -i'' -r -e '/Define the upstream peers to connect to/a\    seeds:' /root/public_full_node.yaml
    sleep 0.1
else
    sleep 0.1  
    sed -i'' -e '/{}/d' /root/public_full_node.yaml
    sleep 0.1
fi
grep -o "127.0.0.1" /root/public_full_node.yaml > /root/127001.txt
sleep 0.1
if [ -s /root/127001.txt ]
then
    sleep 0.1
    sed -i'' -e '/127.0.0.1/d' /root/public_full_node.yaml
    sleep 0.1
    sed -i'' -r -e '/prevent remote, incoming connections/a\    listen_address: "/ip4/0.0.0.0/tcp/6180"' /root/public_full_node.yaml
    sleep 0.1
else
    echo ""
fi
sleep 0.1
grep -o "state_sync" /root/public_full_node.yaml > /root/v2_or_not.txt
sleep 0.1
if [ -s /root/v2_or_not.txt ]
then
    echo ""
    cp /root/public_full_node.yaml /root/aptos-core
    sleep 0.1
    echo ""
else
    sleep 0.1
    sed -n 9,11p /root/aptos-core/public_full_node.yaml > /root/v2_or_not.txt
    sleep 0.1
    sed -i'' -r -e "/execution:/i\state_sync:" /root/public_full_node.yaml
    sleep 0.1
    sed -i'' -r -e "/execution:/i\  state_sync_driver:" /root/public_full_node.yaml
    sleep 0.1
    sed -i'' -r -e "/execution:/i\    enable_state_sync_v2: true" /root/public_full_node.yaml
    sleep 0.1
    cp /root/public_full_node.yaml /root/aptos-core
    sleep 0.1
    echo ""
fi
sleep 0.1
rm -r /root/default_seed.txt 2> /dev/null
sleep 0.1
rm -r /root/v2_or_not.txt 2> /dev/null
sleep 0.1
rm -r /root/127001.txt 2> /dev/null
sleep 0.1
rm -r /root/seed.txt 2> /dev/null
sleep 1
cd /root/aptos-core
sleep 0.1
rm -r /root/compile_alan_yoon.sh > /dev/null
sleep 0.1
echo "Editing public_full_node.yaml file completed successfully!! "
sleep 2
echo ""
echo ""
echo "Final compiling starts and your node will run by binary files after compiling ends... "
sleep 2
echo ""
echo ""
echo "Thanks you for using my script. From Alan Yoon(discord id: @Alan Yoon#2149). "
sleep 1
echo ""
echo ""
#apt-get -y install apt-transport-https ca-certificates curl gnupg lsb-release
#sleep 0.1
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
#sleep 0.1
#echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#sleep 0.1
#apt-get -y install docker-ce docker-ce-cli containerd.io
#sleep 0.1
#docker --version
#sleep 0.1
#curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
#chmod +x /usr/local/bin/docker-compose
#docker-compose --version
#sleep 0.1
cargo run -p aptos-node --release -- -f ./public_full_node.yaml
