#!/bin/bash

clear
cd ~
sleep 1
apt-get update > /dev/bull &&
apt-get install figlet > /dev/null &&
echo ""
echo ""
echo "==========================================="
figlet AlanYoon
echo "==========================================="
sleep 1
echo ""
echo ""
echo "\e[1m\e[33mPreparing now... \e[0m"
sleep 1
if [ -f /root/aptos-core/public_full_node.yaml ]
then
    cp /root/aptos/public_full_node.yaml ./public_full_node.yaml.old &&
    cp /root/aptos/public_full_node.yaml ./
    sleep 2
else
    touch ./public_full_node.yaml &&
    sleep 1
    git clone https://github.com/shyoon71/aptos-core.git
    sleep 0.1
    cd aptos-core
    slep 0.1
    ./scripts/dev_setup.sh
    sleep 0.1
    source ~/.cargo/env
    sleep 0.1
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
    rm -r /root/aptos-core/target/release > /dev/null &&
    echo ""
    echo ""
else
    echo ""
    echo ""
    echo "\e[1m\e[33mYou don't have any old files this time, so backup and restoring process will be possible when you update node next time. \e[0m"
    echo ""
    echo ""
    echo ""
fi
sleep 0.1
cd /root/aptos-core
sleep 0.1
wget https://devnet.aptoslabs.com/genesis.blob
sleep 0.1
wget https://devnet.aptoslabs.com/waypoint.txt
sleep 1
if [ -s /root/public_full_node.yaml ]
then
    echo ""
    echo ""
else
    echo ""
    echo ""
    rm /root/public_full_node.yaml
    sleep 0.1
    cp config/src/config/test_data/public_full_node.yaml /root &&
    sleep 2
    aptos key generate --key-type x25519 --output-file /path/to/private-key.txt
    sleep 0.1
    ID=$(sed -n 2p /path/to/peer-info.yaml | sed 's/\(.*\):/\1/')
    ID=${ID//$'\r'/}
    PRIVATE_KEY=$(cat /path/to/private-key.txt)
    sed -i 's/<PEER_ID>/$ID/g' /root/public_full_node.yaml
    sed -i 's/<PRIVATE_KEY>/$PRIVATE_KEY/g' /root/public_full_node.yaml
fi
cd aptos-core
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
    cp /root/public_full_node.yaml /root/aptos-core
    sleep 0.1
    echo "\e[1m\e[33mYour 'public_full_node.yaml' file was restored successfully! \e[0m"
    echo ""
    echo ""
    echo "\e[1m\e[33mFinally compiling and starting now! \e[0m"
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
    cp /root/public_full_node.yaml /root/aptos-core
    sleep 0.1
    echo "\e[1m\e[33mYour state_sync_driver's version config in 'public_full_node.yaml' was upgraded to v2 successfully. \e[0m"
    echo ""
    echo ""
    echo "\e[1m\e[33mFinally compiling and starting now! \e[0m"
    echo ""
    echo ""
fi
rm -r /root/default_seed.txt 2> /dev/null &&
rm -r /root/v2_or_not.txt 2> /dev/null &&
rm -r /root/aptos.sh 2> /dev/null &&
rm -r /root/kaptos_alan_yoon_v1.sh 2> /dev/null &&
rm -r /root/aptos_identity.sh 2> /dev/null &&
rm -r /root/127001.txt 2> /dev/null &&
rm -r /root/seed.txt 2> /dev/null &&
sleep 0.1
cd /root/aptos-core
sleep 0.1
echo ""
echo ""
echo "\e[1m\e[33mDone!! Have a nide day! Thanks you for using my script. From Alan Yoon(discord id: @Alan Yoon#2149). \e[0m"
echo ""
echo ""
sleep 0.1
cargo run -p aptos-node --release -- -f ./public_full_node.yaml
echo ""
echo ""
