#!/bin/bash

clear
cd ~
sleep 0.2
apt-get update > /dev/bull &&
apt-get install figlet > /dev/null &&
echo ""
echo ""
echo "==========================================="
figlet AlanYoon
echo "==========================================="
sleep 0.2
echo ""
echo ""
echo "\e[1m\e[33mStarting script now... \e[0m"
sleep 0.2
curl https://sh.rustup.rs -sSf | sh &&
sleep 0.2
git clone https://github.com/<YOUR-GITHUB-USERID>/aptos-core.git &&
cd aptos-core &&
sleep 0.2
./scripts/dev_setup.sh &&
sleep 0.2
source ~/.cargo/env &&
sleep 0.2
cargo install --git https://github.com/aptos-labs/aptos-core.git aptos &&
sleep 0.2
which aptos &&
sleep 0.2
if [ -f /path/to/private-key.txt ]
then
    cp ./public_full_node.yaml /root/public_full_node.yaml.old &&
    cp ./public_full_node.yaml /root &&
    sleep 0.1
    rm genesis.blob &&
    sleep 0.1
    rm waypoint.txt &&
    sleep 0.1
    rm -r /opt/aptos/data &&
    sleep 0.1
else
    aptos key generate --key-type x25519 --output-file /path/to/private-key.txt &&
    cat ~/private-key.txt &&
    sleep 0.2
    cat ~/private-key.txt.pub &&
    sleep 0.2
    cat ~/peer-info.yaml &&
    sleep 0.2
    PRIVATE_KEY=$(cat /path/to/private-key.txt) &&
    sleep 0.2
    ID=$(sed -n 2p /path/to/peer-info.yaml | sed 's/\(.*\):/\1/') &&
    ID=${ID//$'\r'/} &&
    sleep 0.2
    sed -i 's/<PRIVATE_KEY>/$PRIVATE_KEY/g' ~/aptos-core/public_full_node.yaml &&
    sleep 0.5
    sed -i 's/<PEER_ID>/$ID/g' ~/aptos-core/public_full_node.yaml &&
    sleep 0.1
fi
grep -o "a950c9360c02c5ef9a02ad9a097f514b97f41a7499a2a798c530d610d3633e5c:" ~/aptos-core/public_full_node.yaml > /root/default_seed.txt
sleep 3
if [ -s /root/default_seed.txt ]
then
    echo ""
    echo ""
    sleep 2
else
    sed -i'' -r -e "/identity:/i\      a950c9360c02c5ef9a02ad9a097f514b97f41a7499a2a798c530d610d3633e5c:" ~/aptos-core/public_full_node.yaml
    sleep 1
    sed -i'' -r -e "/identity:/i\          addresses:" ~/aptos-core/public_full_node.yaml &&
    sleep 1
    sed -i'' -r -e '/identity:/i\          - "/ip4/175.118.42.185/tcp/6180/ln-noise-ik/a950c9360c02c5ef9a02ad9a097f514b97f41a7499a2a798c530d610d3633e5c/ln-handshake/0"' ~/aptos-core/public_full_node.yaml
    sleep 1
    sed -i'' -r -e '/identity:/i\          role: "Upstream"' ~/aptos-core/public_full_node.yaml &&
    sleep 1
fi
grep -o "seeds: {}" ~/aptos-core/public_full_node.yaml > /root/seed.txt
if [ -s /root/seed.txt ]
then
    sed -i '/seeds:/d' ~/aptos-core/public_full_node.yaml &&
    sed -i'' -r -e '/Define the upstream peers to connect to/a\    seeds:' ~/aptos-core/public_full_node.yaml &&
    sleep 1
else
    sleep 1    
    sed -i '/{}/d' ~/aptos-core/public_full_node.yaml &&
    sleep 1
fi
grep -o "127.0.0.1" ~/aptos-core/public_full_node.yaml > /root/127001.txt
sleep 3
if [ -s /root/127001.txt ]
then
    sed -i '/127.0.0.1/d' ~/aptos-core/public_full_node.yaml &&
    sed -i'' -r -e '/prevent remote, incoming connections/a\    listen_address: "/ip4/0.0.0.0/tcp/6180"' ~/aptos-core/public_full_node.yaml &&
    sleep 2
else
    echo ""
    echo ""
fi
rm -r /root/127001.txt > /dev/null &&
rm -r /root/seed.txt &&
rm -r /root/default_seed.txt &&
sleep 0.1
wget https://devnet.aptoslabs.com/genesis.blob &&
sleep 0.1
wget https://devnet.aptoslabs.com/waypoint.txt &&
sleep 0.1
echo ""
echo ""
echo "Starting compiling and running..."
cargo run -p aptos-node --release -- -f ./public_full_node.yaml
