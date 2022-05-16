#!/bin/bash

clear
echo ""
echo ""

cd

echo "=========================================================================="
echo "This script is made for testnet validator node setup only. From Alan Yoon."
echo "=========================================================================="

sleep 2

read -p "What's your IP address? " IP

echo ""

read -p "What's your ID? Don't use '#' or 'space' " ID

echo ""

sudo apt-get update && sleep 0.2

apt-get -y install apt-transport-https ca-certificates curl gnupg lsb-release && sleep 0.2

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && sleep 0.2

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update && sleep 0.2

apt-get install docker-ce docker-ce-cli containerd.io -y && sleep 0.2

curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && sleep 0.2

chmod +x /usr/local/bin/docker-compose && sleep 0.2

curl https://sh.rustup.rs -sSf | sh && sleep 0.2

source /root/.cargo/env && sleep 0.2

rm -r aptos &> /dev/null && sleep 0.2

wget https://github.com/aptos-labs/aptos-core/releases/download/aptos-cli-v0.1.1/aptos-cli-0.1.1-Ubuntu-x86_64.zip && sleep 0.2

apt install unzip &> /dev/null && sleep 0.2

unzip aptos-cli-0.1.1-Ubuntu-x86_64.zip && rm aptos-cli-0.1.1-Ubuntu-x86_64.zip && sleep 0.2

mv aptos /usr/bin && sleep 0.2

chmod +x /usr/bin/aptos && sleep 0.2

export WORKSPACE=testnet && sleep 0.2

mkdir ~/$WORKSPACE && sleep 0.2

cd ~/$WORKSPACE && sleep 0.2

wget https://raw.githubusercontent.com/aptos-labs/aptos-core/main/docker/compose/aptos-node/docker-compose.yaml

wget https://raw.githubusercontent.com/aptos-labs/aptos-core/main/docker/compose/aptos-node/validator.yaml

wget https://raw.githubusercontent.com/aptos-labs/aptos-core/main/docker/compose/aptos-node/fullnode.yaml

aptos genesis generate-keys --output-dir ~/$WORKSPACE && sleep 0.2

mkdir -p /root/backup && sleep 0.2

cp *.yaml* /root/backup && sleep 0.2

aptos genesis set-validator-configuration --keys-dir ~/$WORKSPACE --local-repository-dir ~/$WORKSPACE --username $ID --validator-host $IP:6180 --full-node-host $IP:6182 && sleep 0.2

# touch layout.yaml && sleep 0.2

tee /root/layout.yaml > /dev/null <<EOF
---
root_key: "0x5243ca72b0766d9e9cbf2debf6153443b01a1e0e6d086c7ea206eaf6f8043956"
users:
    - $ID
chain_id: 23
EOF

wget https://github.com/aptos-labs/aptos-core/releases/download/aptos-framework-v0.1.0/framework.zip && sleep 0.2

unzip framework.zip && rm framework.zip && sleep 0.2

aptos genesis generate-genesis --local-repository-dir ~/$WORKSPACE --output-dir ~/$WORKSPACE && sleep 0.2

cp *.yaml /root/backup && cp *.txt /root/backup && sleep 0.2

docker-compose up -d && sleep 5

docker ps

echo ""
echo ""

echo "Done!!"

