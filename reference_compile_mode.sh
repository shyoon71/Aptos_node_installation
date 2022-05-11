#!/bin/bash
echo "=================================================="
echo -e "\033[0;35m"
echo "      ___                        ___                                    _____    ";
echo "     /  /\          ___         /  /\                      ___         /  /::\   ";
echo "    /  /::|        /__/\       /  /::\                    /  /\       /  /:/\:\  ";
echo "   /  /:/:|        \  \:\     /  /:/\:\    ___     ___   /  /:/      /  /:/  \:\ ";
echo "  /  /:/|:|__       \  \:\   /  /:/~/::\  /__/\   /  /\ /__/::\     /__/:/ \__\:|";
echo " /__/:/ |:| /\  ___  \__\:\ /__/:/ /:/\:\ \  \:\ /  /:/ \__\/\:\__  \  \:\ /  /:/";
echo " \__\/  |:|/:/ /__/\ |  |:| \  \:\/:/__\/  \  \:\  /:/     \  \:\/\  \  \:\  /:/ ";
echo "     |  |:/:/  \  \:\|  |:|  \  \::/        \  \:\/:/       \__\::/   \  \:\/:/  ";
echo "     |  |::/    \  \:\__|:|   \  \:\         \  \::/        /__/:/     \  \::/   ";
echo "     |  |:/      \__\::::/     \  \:\         \__\/         \__\/       \__\/    ";
echo "     |__|/           ~~~~       \__\/                                            ";
echo -e "\e[0m"
echo "=================================================="

sleep 2

echo -e "\e[1m\e[32m1. Installing required dependencies... \e[0m" && sleep 1
sudo apt-get update & sudo apt-get install git -y
# Installing yq to modify yaml files
sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64  &> /dev/null
sudo chmod a+x /usr/local/bin/yq
cd $HOME
rm -rf aptos-core &> /dev/null
rm /usr/local/bin/aptos* &> /dev/null
rm -rf /opt/aptos/data/db &> /dev/null
sudo mkdir -p /opt/aptos/data aptos aptos/identity
systemctl stop aptos-fullnode &> /dev/null

echo "=================================================="

echo -e "\e[1m\e[32m2. Cloning github repo... \e[0m" && sleep 1
git clone https://github.com/aptos-labs/aptos-core.git
cd $HOME/aptos
rm *
rm $HOME/aptos/identity/id.json
cp $HOME/aptos-core/config/src/config/test_data/public_full_node.yaml $HOME/aptos
wget -P $HOME/aptos https://devnet.aptoslabs.com/genesis.blob
wget -P $HOME/aptos https://devnet.aptoslabs.com/waypoint.txt
#wget -P $HOME/aptos https://api.zvalid.com/aptos/seeds.yaml
/usr/local/bin/yq e -i 'del(.base.waypoint.from_file)' $HOME/aptos/public_full_node.yaml
/usr/local/bin/yq e -i '.base.waypoint.from_config="'$(cat $HOME/aptos/waypoint.txt)'"' $HOME/aptos/public_full_node.yaml
/usr/local/bin/yq e -i '.execution.genesis_file_location = "'$HOME/aptos/genesis.blob'"' $HOME/aptos/public_full_node.yaml
cd $HOME/aptos-core

echo "=================================================="

echo -e "\e[1m\e[32m3. Installing required Aptos dependencies... \e[0m" && sleep 1

echo y | ./scripts/dev_setup.sh && sleep 1
cargo install sccache && sleep 1
echo y | ./scripts/dev_setup.sh && sleep 1
source ~/.cargo/env

echo "=================================================="

echo -e "\e[1m\e[32m4. Compiling aptos-node ... \e[0m" && sleep 1
git checkout origin/devnet &> /dev/null
sleep 1
cargo build -p aptos-node --release --locked

echo "=================================================="

echo -e "\e[1m\e[32m5. Compiling aptos-operational-tool ... \e[0m" && sleep 1
cargo build -p aptos-operational-tool --release

echo "=================================================="

echo -e "\e[1m\e[32m6. Moving aptos-node to /usr/local/bin/aptos-node ... \e[0m" && sleep 1
mv $HOME/aptos-core/target/release/aptos-node /usr/local/bin

echo "=================================================="

echo -e "\e[1m\e[32m7. Moving aptos-operational-tool to /usr/local/bin/aptos-operational-tool ... \e[0m" && sleep 1
mv $HOME/aptos-core/target/release/aptos-operational-tool /usr/local/bin

echo "=================================================="

echo -e "\e[1m\e[32m8. Generating a unique node identity ... \e[0m" && sleep 1

if [ ! -f $HOME/aptos/identity/private-key.txt ]
then
    /usr/local/bin/aptos-operational-tool generate-key --encoding hex --key-type x25519 --key-file $HOME/aptos/identity/private-key.txt &> /dev/null
fi
/usr/local/bin/aptos-operational-tool extract-peer-from-file --encoding hex --key-file $HOME/aptos/identity/private-key.txt --output-file $HOME/aptos/identity/peer-info.yaml &> /dev/null
PEER_ID=$(sed -n 2p $HOME/aptos/identity/peer-info.yaml | sed 's/.$//')
PRIVATE_KEY=$(cat $HOME/aptos/identity/private-key.txt)

# Setting node identity
/usr/local/bin/yq e -i '.full_node_networks[] +=  { "identity": {"type": "from_config", "key": "'$PRIVATE_KEY'", "peer_id": "'$PEER_ID'"} }' $HOME/aptos/public_full_node.yaml

# Setting peer list
#/usr/local/bin/yq ea -i 'select(fileIndex==0).full_node_networks[0].seeds = select(fileIndex==1).seeds | select(fileIndex==0)' $HOME/aptos/public_full_node.yaml $HOME/aptos/seeds.yaml
#rm $HOME/aptos/seeds.yaml

# Add possibility to share your node as a peer
/usr/local/bin/yq e -i '.full_node_networks[].listen_address="/ip4/0.0.0.0/tcp/6180"' $HOME/aptos/public_full_node.yaml

echo "=================================================="

echo -e "\e[1m\e[32m9. Creating systemctl service ... \e[0m" && sleep 1

echo "[Unit]
Description=Aptos Node

[Service]
User=$USER
Type=simple
ExecStart=/usr/local/bin/aptos-node --config $HOME/aptos/public_full_node.yaml
Restart=always
RestartSec=10
LimitNOFILE=10000

[Install]
WantedBy=multi-user.target
" > $HOME/aptos-fullnode.service
mv $HOME/aptos-fullnode.service /etc/systemd/system

echo "=================================================="

echo -e "\e[1m\e[32m10. Starting the node ... \e[0m" && sleep 1

sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable aptos-fullnode
sudo systemctl restart aptos-fullnode

echo "=================================================="

echo -e "\e[1m\e[32m11. Aptos FullNode Started \e[0m"

echo "=================================================="

echo -e "\e[1m\e[32mTo stop the Aptos Node: \e[0m" 
echo -e "\e[1m\e[39m    systemctl stop aptos-fullnode \n \e[0m" 

echo -e "\e[1m\e[32mTo start the Aptos Node: \e[0m" 
echo -e "\e[1m\e[39m    systemctl start aptos-fullnode \n \e[0m" 

echo -e "\e[1m\e[32mTo check the Aptos Node Logs: \e[0m" 
echo -e "\e[1m\e[39m    journalctl -u aptos-fullnode -f \n \e[0m" 

echo -e "\e[1m\e[32mTo check the node status: \e[0m" 
echo -e "\e[1m\e[39m    curl 127.0.0.1:9101/metrics 2> /dev/null | grep aptos_state_sync_version | grep type \n \e[0m"

