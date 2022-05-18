#!/bin/bash

sudo apt-get update & sudo apt-get install git -y

sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64  &> /dev/null
sudo chmod a+x /usr/local/bin/yq
cd $HOME
rm -rf aptos-core
rm /usr/local/bin/aptos*
rm -rf /opt/aptos/data/db
sudo mkdir -p /opt/aptos/data aptos aptos/identity
systemctl stop aptos-fullnode &> /dev/null
git clone https://github.com/aptos-labs/aptos-core.git
cd $HOME/aptos
rm *
rm $HOME/aptos/identity/id.json
cp $HOME/aptos-core/config/src/config/test_data/public_full_node.yaml $HOME/aptos
wget -P $HOME/aptos https://devnet.aptoslabs.com/genesis.blob
wget -P $HOME/aptos https://devnet.aptoslabs.com/waypoint.txt
/usr/local/bin/yq e -i 'del(.base.waypoint.from_file)' $HOME/aptos/public_full_node.yaml
/usr/local/bin/yq e -i '.base.waypoint.from_config="'$(cat $HOME/aptos/waypoint.txt)'"' $HOME/aptos/public_full_node.yaml
/usr/local/bin/yq e -i '.execution.genesis_file_location = "'$HOME/aptos/genesis.blob'"' $HOME/aptos/public_full_node.yaml
cd $HOME/aptos-core
git checkout origin/devnet &> /dev/null
echo y | ./scripts/dev_setup.sh
source ~/.cargo/env
cargo build -p aptos-node --release
cargo build -p aptos-operational-tool --release
mv $HOME/aptos-core/target/release/aptos-node /usr/local/bin
mv $HOME/aptos-core/target/release/aptos-operational-tool /usr/local/bin
if [ ! -f $HOME/aptos/identity/private-key.txt ]
then
    /usr/local/bin/aptos-operational-tool generate-key --encoding hex --key-type x25519 --key-file $HOME/aptos/identity/private-key.txt &> /dev/null
fi
/usr/local/bin/aptos-operational-tool extract-peer-from-file --encoding hex --key-file $HOME/aptos/identity/private-key.txt --output-file $HOME/aptos/identity/peer-info.yaml &> /dev/null
PEER_ID=$(sed -n 2p $HOME/aptos/identity/peer-info.yaml | sed 's/.$//')
PRIVATE_KEY=$(cat $HOME/aptos/identity/private-key.txt)
/usr/local/bin/yq e -i '.full_node_networks[] +=  { "identity": {"type": "from_config", "key": "'$PRIVATE_KEY'", "peer_id": "'$PEER_ID'"} }' $HOME/aptos/public_full_node.yaml
/usr/local/bin/yq e -i '.full_node_networks[].listen_address="/ip4/0.0.0.0/tcp/6180"' $HOME/aptos/public_full_node.yaml

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

sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable aptos-fullnode
sudo systemctl restart aptos-fullnode