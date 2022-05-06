#!/bin/bash

clear
cd ~
sleep 0.1
apt-get install figlet > /dev/null
sleep 0.1
echo ""
echo ""
echo "==========================================="
figlet AlanYoon
echo "==========================================="
sleep 1
echo ""
echo ""
echo -e "\e[1m\e[33mPreparing compile environment and cloning github source code now... \e[0m"
sleep 2
echo -e "\e[1m\e[35mYou should select and inpout yes or 1 for all question form script from now... \e[0m"
sleep 5
if [ -f /root/aptos-core/public_full_node.yaml ]
then
    cp /root/aptos-core/public_full_node.yaml ./public_full_node.yaml.old
    sleep 0.1
    cp /root/aptos-core/public_full_node.yaml ./
    sleep 0.1
    rm -r aptos-core
    sleep 0.1
else
    touch ./public_full_node.yaml
    sleep 0.1
fi
git clone https://github.com/shyoon71/aptos-core.git
sleep 0.1
curl https://sh.rustup.rs -sSf | sh
sleep 0.1
source $HOME/.cargo/env
sleep 2
echo ""
echo ""
echo -e "\e[1m\e[33m[ 1/2 ] First compiling starts now... \e[0m"
sleep 5
echo ""
cargo install --git https://github.com/aptos-labs/aptos-core.git aptos
sleep 1
cd aptos-core
sleep 0.1
./scripts/dev_setup.sh
sleep 1
if [ -s /root/public_full_node.yaml ]
then
    echo ""
    echo ""
    echo ""
    sleep 0.1
    echo -e "\e[1m\e[35mYour 'public_full_node.yaml' file was copied and saved in /root directory. Backup is completed! \e[0m"
    echo ""
    echo -e "\e[1m\e[33mIf you previously ran this script, that yaml file would have been saved as extension name 'yaml.old'. \e[0m"
    sleep 6
    echo ""
    echo ""
    rm -r /root/aptos-core/target/release 2> /dev/null
    sleep 0.1
    echo ""
    echo ""
else
    echo ""
    echo ""
    echo -e "\e[1m\e[33mYou don't have any old files this time, so backup and restoring process will be possible when you update node next time. \e[0m"
    sleep 6
    echo ""
    echo ""
    echo ""
fi
cd /root/aptos-core
sleep 0.1
mkdir data
sleep 0.1
echo -e "\e[1m\e[33mDownloading genesis and waypoint files for update configuration... \e[0m"
sleep 5
echo ""
wget https://devnet.aptoslabs.com/genesis.blob
sleep 1
wget https://devnet.aptoslabs.com/waypoint.txt
sleep 0.1
if [ -s /root/public_full_node.yaml ]
then
    echo ""
    echo ""
else
    echo ""
    echo ""
    rm /root/public_full_node.yaml
    sleep 0.1
    wget https://raw.githubusercontent.com/shyoon71/installation-script/main/public_full_node.yaml -P /root
    sleep 0.1
    echo -e "\e[1m\e[33mGenerating your private key and peer id... \e[0m"
    sleep 0.1
    echo ""
    aptos key generate --key-type x25519 --output-file /root/private-key.txt
    sleep 5
    echo ""
#   cargo run -p aptos-operational-tool extract-peer-from-file --encoding hex --key-file /root/private-key.txt --output-file /root/peer-info.yaml
    sleep 0.1
#   ID=$(sed -n 2p /root/private-key.yaml | sed 's/\(.*\):/\1/')
#   sleep 0.1
#   ID=${ID//$'\r'/}
    ID=$(cat /root/private-key.txt.pub)
    sleep 0.1
    PRIVATE_KEY=$(cat /root/private-key.txt)
    sleep 0.1
    sed -i "s/<PEER-ID>/$ID/g" /root/public_full_node.yaml
    sleep 0.1
    sed -i "s/<PRIVATE_KEY>/$PRIVATE_KEY/g" /root/public_full_node.yaml
    sleep 0.1
fi
cd /root/aptos-core 2> /dev/null
sleep 0.1
grep -o "a950c9360c02c5ef9a02ad9a097f514b97f41a7499a2a798c530d610d3633e5c:" /root/public_full_node.yaml > /root/default_seed.txt
sleep 0.1
if [ -s /root/default_seed.txt ]
then
    echo ""
    echo ""
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
sed -i "s/<WAYPOINT>/$WAYPOINT/g" /root/public_full_node.yaml
sleep 0.1
grep -o "seeds: {}" /root/public_full_node.yaml > /root/seed.txt
sleep 0.1
if [ -s /root/seed.txt ]
then
    sleep 0.1
    sed -i '/seeds:/d' /root/public_full_node.yaml
    sleep 0.1
    sed -i'' -r -e '/Define the upstream peers to connect to/a\    seeds:' /root/public_full_node.yaml
    sleep 0.1
else
    sleep 0.1  
    sed -i '/{}/d' /root/public_full_node.yaml
    sleep 0.1
fi
grep -o "127.0.0.1" /root/public_full_node.yaml > /root/127001.txt
sleep 0.1
if [ -s /root/127001.txt ]
then
    sleep 0.1
    sed -i '/127.0.0.1/d' /root/public_full_node.yaml
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
echo -e "\e[1m\e[33m[ 2/2 ] Second compiling starts now... \e[0m"
sleep 1
echo ""
echo ""
echo -e "\e[1m\e[33mThanks you for using my script. From Alan Yoon(discord id: @Alan Yoon#2149). \e[0m"
sleep 5
echo ""
cargo run -p aptos-node --release -- -f ./public_full_node.yaml
