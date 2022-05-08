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
sleep 5
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
if [ -f /$HOME/aptos-core/public_full_node.yaml ]
then
    cp /$HOME/aptos-core/public_full_node.yaml ./public_full_node.yaml.old
    sleep 0.1
    cp /$HOME/aptos-core/public_full_node.yaml ./
    sleep 0.1
    rm -r aptos-core
    sleep 0.1
else
    touch ./public_full_node.yaml
    sleep 0.1
fi
git clone https://github.com/shyoon71/aptos-core.git
sleep 0.1
cd aptos-core
sleep 0.1
mkdir data
sleep 0.1
curl https://sh.rustup.rs -sSf | sh
sleep 0.1
./scripts/dev_setup.sh
sleep 0.1
source $HOME/.cargo/env
sleep 0.1
echo ""
# cargo install --git https://github.com/aptos-labs/aptos-core.git aptos
# sleep 0.1
# which aptos
# cargo build
sleep 0.1
if [ -s /$HOME/public_full_node.yaml ]
then
    echo ""
    echo ""
    echo ""
    sleep 0.1
    echo "Your 'public_full_node.yaml' file was copied and saved in /'$HOME' directory. Backup is completed! "
    echo ""
    echo "If you previously ran this script, that yaml file would have been saved as extension name 'yaml.old'. "
    sleep 6
    echo ""
    echo ""
    rm -r /$HOME/aptos-core/target/release 2> /dev/null
    sleep 0.1
    echo ""
    echo ""
else
    echo ""
    echo ""
    echo "You don't have any old files, so backup and restoring process will be possible when you update node next time. "
    sleep 6
    echo ""
    echo ""
    echo ""
fi

cd /$HOME/aptos-core
sleep 0.1
echo "Updating source files from APTOS devnet repo... "
sleep 2
echo ""
echo ""
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
if [ -f /$HOME/private-key.txt ]
then
    echo ""
    echo ""
else
    echo ""
    echo ""
    rm /$HOME/public_full_node.yaml > /dev/null
    sleep 0.1
    wget https://raw.githubusercontent.com/shyoon71/installation-script/main/public_full_node_source.yaml
    mv ./public_full_node_source.yaml ./public_full_node.yaml
    sleep 0.1
    cp ./public_full_node.yaml /$HOME
    sleep 0.1

#    wget https://raw.githubusercontent.com/shyoon71/installation-script/main/public_full_node.yaml -P /$HOME
    sleep 0.1
    echo "Generating your private key and peer id... "
    sleep 2
    echo ""
#   docker run -i -t -v /$HOME:/$HOME aptoslab/tools:devnet /bin/bash
    aptos key generate --key-type x25519 --output-file /$HOME/private-key.txt
    sleep 0.5
#   ./aptos-operational-tool extract-peer-from-file --encoding hex --key-file /$HOME/private-key.txt --output-file /$HOME/peer-info.yaml
#   sleep 0.1
    cd /$HOME/aptos-core
    sleep 2
#   ID=$(sed -n 2p /$HOME/private-key.txt.pub | sed 's/\(.*\):/\1/')
#   ID=${ID//$'\r'/}
    ID=$(cat /$HOME/private-key.txt.pub)
    sleep 0.1
    PRIVATE_KEY=$(cat /$HOME/private-key.txt)
    sleep 0.1
    sed -i'' -e "s/<PEER-ID>/$ID/g" /$HOME/public_full_node.yaml
    sleep 0.1
    sed -i'' -e "s/<PRIVATE_KEY>/$PRIVATE_KEY/g" /$HOME/public_full_node.yaml
    sleep 0.1
fi
cd /$HOME/aptos-core 2> /dev/null
sleep 0.1
grep -o "a950c9360c02c5ef9a02ad9a097f514b97f41a7499a2a798c530d610d3633e5c:" /$HOME/public_full_node.yaml > /$HOME/default_seed.txt
sleep 0.1
if [ -s /$HOME/default_seed.txt ]
then
    sleep 0.1
else
    sed -i'' -r -e "/identity:/i\      a950c9360c02c5ef9a02ad9a097f514b97f41a7499a2a798c530d610d3633e5c:" /$HOME/public_full_node.yaml
    sleep 0.1
    sed -i'' -r -e "/identity:/i\          addresses:" /$HOME/public_full_node.yaml
    sleep 0.1
    sed -i'' -r -e '/identity:/i\          - "/ip4/175.118.42.185/tcp/6180/ln-noise-ik/a950c9360c02c5ef9a02ad9a097f514b97f41a7499a2a798c530d610d3633e5c/ln-handshake/0"' /$HOME/public_full_node.yaml
    sleep 0.1
    sed -i'' -r -e '/identity:/i\          role: "Upstream"' /$HOME/public_full_node.yaml
    sleep 0.1
fi
WAYPOINT=$(cat /$HOME/aptos-core/waypoint.txt)
sleep 0.1
sed -i'' -e "s/<WAYPOINT>/$WAYPOINT/g" /$HOME/public_full_node.yaml
sleep 0.1
grep -o "seeds: {}" /$HOME/public_full_node.yaml > /$HOME/seed.txt
sleep 0.1
if [ -s /$HOME/seed.txt ]
then
    sleep 0.1
    sed -i'' -e '/seeds:/d' /$HOME/public_full_node.yaml
    sleep 0.1
    sed -i'' -r -e '/Define the upstream peers to connect to/a\    seeds:' /$HOME/public_full_node.yaml
    sleep 0.1
else
    sleep 0.1  
    sed -i'' -e '/{}/d' /$HOME/public_full_node.yaml
    sleep 0.1
fi
grep -o "127.0.0.1" /$HOME/public_full_node.yaml > /$HOME/127001.txt
sleep 0.1
if [ -s /$HOME/127001.txt ]
then
    sleep 0.1
    sed -i'' -e '/127.0.0.1/d' /$HOME/public_full_node.yaml
    sleep 0.1
    sed -i'' -r -e '/prevent remote, incoming connections/a\    listen_address: "/ip4/0.0.0.0/tcp/6180"' /$HOME/public_full_node.yaml
    sleep 0.1
else
    echo ""
fi
sleep 0.1
grep -o "state_sync" /$HOME/public_full_node.yaml > /$HOME/v2_or_not.txt
sleep 0.1
if [ -s /$HOME/v2_or_not.txt ]
then
    echo ""
    cp /$HOME/public_full_node.yaml /$HOME/aptos-core
    sleep 0.1
    echo ""
else
    sleep 0.1
    sed -n 9,11p /$HOME/aptos-core/public_full_node.yaml > /$HOME/v2_or_not.txt
    sleep 0.1
    sed -i'' -r -e "/execution:/i\state_sync:" /$HOME/public_full_node.yaml
    sleep 0.1
    sed -i'' -r -e "/execution:/i\  state_sync_driver:" /$HOME/public_full_node.yaml
    sleep 0.1
    sed -i'' -r -e "/execution:/i\    enable_state_sync_v2: true" /$HOME/public_full_node.yaml
    sleep 0.1
    cp /$HOME/public_full_node.yaml /$HOME/aptos-core
    sleep 0.1
    echo ""
fi
sleep 0.1
rm -r /$HOME/default_seed.txt 2> /dev/null
sleep 0.1
rm -r /$HOME/v2_or_not.txt 2> /dev/null
sleep 0.1
rm -r /$HOME/127001.txt 2> /dev/null
sleep 0.1
rm -r /$HOME/seed.txt 2> /dev/null
sleep 1
cd /$HOME/aptos-core
sleep 0.1
rm -r /$HOME/compile_alan_yoon.sh > /dev/null
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
cargo run -p aptos-node --release -- -f /$HOME/public_full_node.yaml
