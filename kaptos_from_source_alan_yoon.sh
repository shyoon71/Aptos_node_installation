#!/bin/bash

clear
cd ~
echo ""
echo "==============================================================="
echo "This script is only for source compiling mode. Made by Alan Yoon." 
echo "==============================================================="
sleep 0.2
echo ""
echo ""
echo "Preparing source code compiling..."
echo ""
sleep 0.2
curl https://sh.rustup.rs -sSf | sh &&
sleep 0.2
mv ~/public_full_node.yaml ~/public_full_node.yaml.old
cp ~/aptos-core/public_full_node.yaml ~/ &&
sleep 0.1
rm -r ~/aptos-core &&
sleep 0.1
git clone https://github.com/shyoon71/aptos-core &&
cd ~/aptos-core &&
sleep 0.1
./scripts/dev_setup.sh &&
sleep 0.1
source ~/.cargo/env &&
sleep 0.1
cargo install --force --git https://github.com/aptos-labs/aptos-core.git aptos &&
sleep 0.1
which aptos &&
sleep 0.1
cd ~/aptos-core &&
sleep 0.1
wget https://raw.githubusercontent.com/shyoon71/installation-script/main/public_full_node.yaml &&
sleep 0.1
if [ -f ~/private-key.txt ]
then
    rm ~/aptos-core/genesis.blob > /dev/null &&
    sleep 0.1
    rm ~/aptos-core/waypoint.txt /dev/null &&
    sleep 0.1
    rm -r ~/aptos-core/target/release > /dev/null &&
    sleep 0.1
else
    aptos key generate --key-type x25519 --output-file ~/private-key.txt &&
    cat ~/private-key.txt &&
    sleep 0.1
    cat ~/private-key.txt.pub &&
    sleep 0.1
    cat ~/peer-info.yaml &&
    sleep 0.1
    cd ~/aptos-core &&
    sleep 0.1
    PRIVATE_KEY=$(cat ~/private-key.txt) &&
    sleep 0.5
    ID=$(sed -n 2p ~/peer-info.yaml | sed 's/\(.*\):/\1/') &&
    ID=${ID//$'\r'/} &&
    sleep 0.5
    sed -i'' -e 's/<PRIVATE_KEY>/$PRIVATE_KEY/g' ~/aptos-core/public_full_node.yaml &&
    sleep 0.5
    sed -i'' -e 's/<PEER_ID>/$ID/g' ~/aptos-core/public_full_node.yaml &&
    sleep 0.1
fi
grep -o "a950c9360c02c5ef9a02ad9a097f514b97f41a7499a2a798c530d610d3633e5c:" ~/aptos-core/public_full_node.yaml > ~/default_seed.txt
sleep 3
if [ -s ~/default_seed.txt ]
then
    echo ""
    echo ""
    sleep 2
else
    sed -i'' -r -e "/identity:/i\      a950c9360c02c5ef9a02ad9a097f514b97f41a7499a2a798c530d610d3633e5c:" ~/aptos-core/public_full_node.yaml
    sleep 0.5
    sed -i'' -r -e "/identity:/i\          addresses:" ~/aptos-core/public_full_node.yaml &&
    sleep 0.5
    sed -i'' -r -e '/identity:/i\          - "/ip4/175.118.42.185/tcp/6180/ln-noise-ik/a950c9360c02c5ef9a02ad9a097f514b97f41a7499a2a798c530d610d3633e5c/ln-handshake/0"' ~/aptos-core/public_full_node.yaml
    sleep 0.5
    sed -i'' -r -e '/identity:/i\          role: "Upstream"' ~/aptos-core/public_full_node.yaml &&
    sleep 0.1
fi
grep -o "seeds: {}" ~/aptos-core/public_full_node.yaml > ~/seed.txt
if [ -s ~/seed.txt ]
then
    sed -i'' -e '/seeds:/d' ~/aptos-core/public_full_node.yaml &&
    sleep 0.5
    sed -i'' -r -e '/Define the upstream peers to connect to/a\    seeds:' ~/aptos-core/public_full_node.yaml &&
    sleep 0.1
else
    sleep 0.1
    sed -i '/{}/d' ~/aptos-core/public_full_node.yaml &&
    sleep 0.5
fi
grep -o "127.0.0.1" ~/aptos-core/public_full_node.yaml > ~/127001.txt
sleep 0.1
if [ -s ~/127001.txt ]
then
    sed -i'' -e '/127.0.0.1/d' ~/aptos-core/public_full_node.yaml &&
    sleep 0.5
    sed -i'' -r -e '/prevent remote, incoming connections/a\    listen_address: "/ip4/0.0.0.0/tcp/6180"' ~/aptos-core/public_full_node.yaml &&
    sleep 0.1
else
    echo ""
    echo ""
fi
rm -r ~/127001.txt > /dev/null &&
rm -r ~/seed.txt &&
rm -r ~/default_seed.txt &&
rm -r ~/kaptos_from_source_alan_yoon.sh &&
sleep 0.1
rm ~/aptos-core/genesis.blob &&
sleep 0.1
wget https://devnet.aptoslabs.com/genesis.blob &&
sleep 0.1
rm ~/aptos-core/waypoint.txt &&
sleep 0.1
wget https://devnet.aptoslabs.com/waypoint.txt &&
sleep 0.1
cp ~/aptos-core/public_full_node.yaml ~/ &&
sleep 0.1
cd ~/aptos-core &&
sleep 0.1
echo "Compiling source code..."
cargo run -p aptos-node --release -- -f ./public_full_node.yaml
