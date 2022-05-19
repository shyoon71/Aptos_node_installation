#!/bin/bash
echo ""
read -p "What's your validator IP address? : " IP
echo ""
read -p "What's your ID? Don't use '#' or 'space' : " ID
echo ""
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
# wget -P $HOME/aptos https://devnet.aptoslabs.com/genesis.blob
# wget -P $HOME/aptos https://devnet.aptoslabs.com/waypoint.txt
# /usr/local/bin/yq e -i 'del(.base.waypoint.from_file)' $HOME/aptos/public_full_node.yaml
# /usr/local/bin/yq e -i '.base.waypoint.from_config="'$(cat $HOME/aptos/waypoint.txt)'"' $HOME/aptos/public_full_node.yaml
# /usr/local/bin/yq e -i '.execution.genesis_file_location = "'$HOME/aptos/genesis.blob'"' $HOME/aptos/public_full_node.yaml
cd $HOME/aptos-core
git checkout origin/devnet &> /dev/null
echo y | ./scripts/dev_setup.sh
source ~/.cargo/env
git checkout --track origin/testnet
export WORKSPACE=testnet
mkdir ~/$WORKSPACE
cargo run --release -p aptos -- genesis generate-keys --output-dir ~/$WORKSPACE
cargo run --release -p aptos -- genesis set-validator-configuration --keys-dir ~/$WORKSPACE --local-repository-dir ~/$WORKSPACE --username $ID --validator-host $IP:6180 --full-node-host $IP:6182
touch ~/$WORKSPACE/layout.yaml
echo '---
root_key: "0x5243ca72b0766d9e9cbf2debf6153443b01a1e0e6d086c7ea206eaf6f8043956"
users:
  - '$ID'
chain_id: 23' > ~/$WORKSPACE/layout.yaml && sleep 0.5
cargo run --release --package framework -- --package aptos-framework --output current
mkdir ~/$WORKSPACE/framework
mv aptos-framework/releases/artifacts/current/build/**/bytecode_modules/*.mv ~/$WORKSPACE/framework/
cargo run --release -p aptos -- genesis generate-genesis --local-repository-dir ~/$WORKSPACE --output-dir ~/$WORKSPACE
mkdir ~/$WORKSPACE/config
cp docker/compose/aptos-node/validator.yaml ~/$WORKSPACE/validator.yaml
cp docker/compose/aptos-node/fullnode.yaml ~/$WORKSPACE/fullnode.yaml

cargo run -p aptos-node --release -- -f ~/$WORKSPACE/validator.yaml && sleep 1
cargo run -p aptos-node --release -- -f ~/$WORKSPACE/fullnode.yaml

# echo "[Unit]
# Description=Aptos Node

# [Service]
# User=$USER
# Type=simple
# ExecStart=/usr/local/bin/aptos-node --config $HOME/aptos/public_full_node.yaml
# Restart=always
# RestartSec=10
# LimitNOFILE=10000

# [Install]
# WantedBy=multi-user.target
# " > $HOME/aptos-fullnode.service
# mv $HOME/aptos-fullnode.service /etc/systemd/system

# sudo systemctl restart systemd-journald
# sudo systemctl daemon-reload
# sudo systemctl enable aptos-fullnode
# sudo systemctl restart aptos-fullnode