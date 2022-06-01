#!/bin/bash

sudo clear
cd ~
sleep 0.1
echo " ============================================================================="
echo ""
echo "   █████╗ ██╗      █████╗ ███╗   ██╗    ██╗   ██╗ ██████╗  ██████╗ ███╗   ██╗"
echo "  ██╔══██╗██║     ██╔══██╗████╗  ██║    ╚██╗ ██╔╝██╔═══██╗██╔═══██╗████╗  ██║"
echo "  ███████║██║     ███████║██╔██╗ ██║     ╚████╔╝ ██║   ██║██║   ██║██╔██╗ ██║"
echo "  ██╔══██║██║     ██╔══██║██║╚██╗██║      ╚██╔╝  ██║   ██║██║   ██║██║╚██╗██║"
echo "  ██║  ██║███████╗██║  ██║██║ ╚████║       ██║   ╚██████╔╝╚██████╔╝██║ ╚████║"
echo "  ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝       ╚═╝    ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝"
echo ""
echo " ============================================================================="
sleep 2
echo ""
echo ""
echo "Starting script for Mac OS..."
sleep 1
if [ -f $HOME/aptos/public_full_node.yaml ]
then
    sudo cp $HOME/aptos/public_full_node.yaml ./public_full_node.yaml.old &&
    sudo cp $HOME/aptos/public_full_node.yaml ./
    sleep 1
else
    touch ./public_full_node.yaml &&
    sleep 1
fi
if [ -s $HOME/public_full_node.yaml ]
then
    echo ""
    echo ""
    echo ""
    echo "Your 'public_full_node.yaml' file was copied and saved in $HOME directory. Backup is completed!"
    echo ""
    echo "If you previously ran this script, that yaml file would have been saved as extension name 'yaml.old'."
    sleep 1
    echo ""
    echo ""
    sudo rm -r /var/lib/docker/volumes/aptos_db/_data/db &> /dev/null &&
    echo ""
    echo ""
else
    echo ""
    echo ""
    echo "You don't have any old files, so backup and restoring process will be possible when you update node next time."
    sleep 1
    echo ""
    echo ""
    echo ""
fi
echo "Main script for installing or updating identiable aptos node starts now."
sleep 1
echo ""
#sudo wget -q -O aptos.sh https://api.zvalid.com/aptos.sh && sudo chmod +x aptos.sh && sudo /bin/bash aptos.sh
echo "1. Updating list of dependencies..." && sleep 1
brew update
brew install jq -y
# Installing yq to modify yaml files
sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
sudo chmod a+x /usr/local/bin/yq
cd $HOME

echo "=================================================="

echo "2. Checking if Docker is installed..." && sleep 1

if ! command -v docker &> /dev/null
then

    echo "2.1 Installing Docker..." && sleep 1
    brew install ca-certificates curl gnupg lsb-release sudo wget -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --deasudo rmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    brew update
    brew install docker-ce docker-ce-cli containerd.io -y
fi

echo "=================================================="

echo "3. Checking if Docker Compose is installed ..." && sleep 1

docker compose version &> /dev/null
if [ $? -ne 0 ]
then

    echo "3.1 Installing Docker Compose v2.3.3 ..." && sleep 1
    sudo mkdir -p ~/.docker/cli-plugins/
    curl -SL https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
    sudo chmod +x ~/.docker/cli-plugins/docker-compose
    sudo chown $USER /var/run/docker.sock
fi

echo "=================================================="

echo "4. Downloading Aptos FullNode config files ..." && sleep 1

sudo mkdir -p $HOME/aptos/identity
cd $HOME/aptos
if [ -f $HOME/aptos/docker-compose.yaml ]
then
    docker compose down -v
fi
docker pull aptoslab/validator:devnet
docker pull aptoslab/tools:devnet
sudo rm * &> /dev/null
sudo rm $HOME/aptos/identity/id.json &> /dev/null
sudo wget -P $HOME/aptos https://raw.githubusercontent.com/aptos-labs/aptos-core/main/docker/compose/public_full_node/docker-compose.yaml
sudo wget -P $HOME/aptos https://raw.githubusercontent.com/aptos-labs/aptos-core/main/docker/compose/public_full_node/public_full_node.yaml
sudo wget -P $HOME/aptos https://devnet.aptoslabs.com/genesis.blob
sudo wget -P $HOME/aptos https://devnet.aptoslabs.com/waypoint.txt
#sudo wget -P $HOME/aptos https://api.zvalid.com/aptos/seeds.yaml

echo "=================================================="

# Checking if aptos node identity exists
create_identity(){
    echo "4.1 Creating a unique node identity"  
    sudo docker run --rm --name aptos_tools -d -i aptoslab/tools:devnet &> /dev/null
    sudo docker exec -it aptos_tools aptos-operational-tool generate-key --encoding hex --key-type x25519 --key-file $HOME/private-key.txt | grep 'Success' &> /dev/null
    if [ $? == 0 ]; then
        sudo docker exec -it aptos_tools cat $HOME/private-key.txt > $HOME/aptos/identity/private-key.txt
        sudo docker exec -it aptos_tools aptos-operational-tool extract-peer-from-file --encoding hex --key-file $HOME/private-key.txt --output-file $HOME/peer-info.yaml &> /dev/null
        sudo docker exec -it aptos_tools cat $HOME/peer-info.yaml > $HOME/aptos/identity/peer-info.yaml
        PEER_ID=$(sed -n 2p $HOME/aptos/identity/peer-info.yaml | sed 's/\(.*\):/\1/')
        PEER_ID=${PEER_ID//$'\r'/}
        PRIVATE_KEY=$(cat $HOME/aptos/identity/private-key.txt)

        echo " Identity was successfully created"
        echo " Peer Id:" $PEER_ID
        echo " Private Key: " $PRIVATE_KEY
    else
        sudo rm -rf $HOME/aptos

        echo "WARNING/ОШИБКА"
        echo " Unfortunately you won't be able to run Aptos Full Node through Docker on this server due to outdated hardware, either change the server or use Option 1 from the guide"
        echo "ENG Guide: https://ohsnail.com/aptos-fullnode-docker-guide-eng/"

        echo " К сожалению вы не сможете запустить Aptos Ноду при помощи Docker на вашем сервера из-за устаревшего оборудования, поменяйте сервер или воспользуйтесь Вариант 1 из гайда"
        echo "RU Гайд: https://ohsnail.com/aptos-fullnode-docker-guide/"
        docker stop aptos_tools &> /dev/null
        exit
    fi
    docker stop aptos_tools &> /dev/null
}

## If private-key.txt exists and there is no peer-info.yaml file then we will regenerate it by using aptos tools docker 
generate_peer_info(){
    sudo docker run --rm --name aptos_tools -d -i aptoslab/tools:devnet &> /dev/null
    sudo docker cp $HOME/aptos/identity/private-key.txt aptos_tools:/$HOME/private-key.txt
    sudo docker exec -it aptos_tools aptos-operational-tool extract-peer-from-file --encoding hex --key-file $HOME/private-key.txt --output-file $HOME/peer-info.yaml &> /dev/null
    sudo docker exec -it aptos_tools cat $HOME/peer-info.yaml > $HOME/aptos/identity/peer-info.yaml
    PEER_ID=$(sed -n 2p $HOME/aptos/identity/peer-info.yaml | sed 's/\(.*\):/\1/')
    PEER_ID=${PEER_ID//$'\r'/}
    docker stop aptos_tools &> /dev/null
}


if [ -f $HOME/aptos/identity/private-key.txt ]
then

    PRIVATE_KEY=$(cat $HOME/aptos/identity/private-key.txt)
    
    ## Delete previouse peer-info.yaml to avoid formating issues (Update from April 15 2022)
    sudo rm $HOME/aptos/identity/peer-info.yaml &> /dev/null

    if [ ! -f $HOME/aptos/identity/peer-info.yaml ]
    then
        generate_peer_info
    else
        PEER_ID=$(sed -n 2p $HOME/aptos/identity/peer-info.yaml | sed 's/\(.*\):/\1/')
        PEER_ID=${PEER_ID//$'\r'/}
    fi

    if [ ! -z "$PRIVATE_KEY" ]
    then
        echo " Peer Id:" $PEER_ID
        echo " Private Key: " $PRIVATE_KEY
    else
        sudo rm $HOME/aptos/identity/peer-info.yaml
        sudo rm $HOME/aptos/identity/private-key.txt
        create_identity
    fi
    echo "=================================================="
else

    create_identity
    echo "=================================================="
fi

# Setting node identity
/usr/local/bin/yq e -i '.full_node_networks[] +=  { "identity": {"type": "from_config", "key": "'$PRIVATE_KEY'", "peer_id": "'$PEER_ID'"} }' $HOME/aptos/public_full_node.yaml

# Setting peer list
#/usr/local/bin/yq ea -i 'select(fileIndex==0).full_node_networks[0].seeds = select(fileIndex==1).seeds | select(fileIndex==0)' $HOME/aptos/public_full_node.yaml $HOME/aptos/seeds.yaml
#sudo rm $HOME/aptos/seeds.yaml

# Add possibility to share your node as a peer
/usr/local/bin/yq e -i '.full_node_networks[].listen_address="/ip4/0.0.0.0/tsudo cp/6180"' $HOME/aptos/public_full_node.yaml
/usr/local/bin/yq e -i '.services.fullnode.ports +=  "6180:6180"' $HOME/aptos/docker-compose.yaml

echo "5. Starting Aptos FullNode ..." && sleep 1

docker compose up -d

echo "=================================================="

echo "Aptos FullNode Started"

echo "=================================================="


echo "Private key file location. It is recommended to back it up:" 
echo ""    $HOME/aptos/identity/private-key.txt""

echo "Peer info file location. It is recommended to back it up:" 
echo ""    $HOME/aptos/identity/peer-info.yaml""

echo "To check sync status:" 
echo "    curl 127.0.0.1:9101/metrics 2> /dev/null | grep aptos_state_sync_version | grep type" 

echo "To view logs:" 
echo "    docker logs -f aptos-fullnode-1 --tail 5000" 

echo "To stop:" 
echo "    docker compose stop" 
sleep 1
if [ -s $HOME/public_full_node.yaml ]
then
    echo ""
    echo ""
else
    echo ""
    echo ""
    sudo cp $HOME/aptos/public_full_node.yaml $HOME/public_full_node.yaml &&
    sleep 1
fi
echo "Checking your state_sync_driver's version and seed status now... Don't touch your keyboard, please."
echo ""
echo ""
cd aptos
docker compose down &&
sleep 1
grep -o "6180:6180" $HOME/aptos/docker-compose.yaml > $HOME/6180.txt
sleep 0.5
# if [ -s $HOME/6180.txt ]
# then
#     echo ""
#     echo ""
#     sleep 0.5
# else
#     sed -i'' -r -e '/volumes:/i\      - "6180:6180"' $HOME/aptos/docker-compose.yaml
#     sleep 0.5
# fi
# grep -o "bb14af025d226288a3488b4433cf5cb54d6a710365a2d95ac6ffbd9b9198a86a:" $HOME/public_full_node.yaml > $HOME/admin_seed.txt
# sleep 1
# if [ -s $HOME/admin_seed.txt ]
# then
#     echo ""
#     echo ""
#     sleep 1
# else
#     sed -i'' -r -e "/identity:/i\      bb14af025d226288a3488b4433cf5cb54d6a710365a2d95ac6ffbd9b9198a86a:" $HOME/public_full_node.yaml
#     sleep 1
#     sed -i'' -r -e "/identity:/i\          addresses:" $HOME/public_full_node.yaml &&
#     sleep 1
#     sed -i'' -r -e '/identity:/i\          - "/dns4/pfn0.node.devnet.aptoslabs.com/tsudo cp/6182/ln-noise-ik/bb14af025d226288a3488b4433cf5cb54d6a710365a2d95ac6ffbd9b9198a86a/ln-handshake/0"' $HOME/public_full_node.yaml
#     sleep 1
#     sed -i'' -r -e '/identity:/i\          role: "Upstream"' $HOME/public_full_node.yaml &&
#     sleep 1
# fi
# grep -o "a950c9360c02c5ef9a02ad9a097f514b97f41a7499a2a798c530d610d3633e5c:" $HOME/public_full_node.yaml > $HOME/default_seed.txt
# sleep 1
# if [ -s $HOME/default_seed.txt ]
# then
#     echo ""
#     echo ""
#     sleep 1
# else
#     sed -i'' -r -e "/identity:/i\      a950c9360c02c5ef9a02ad9a097f514b97f41a7499a2a798c530d610d3633e5c:" $HOME/public_full_node.yaml
#     sleep 1
#     sed -i'' -r -e "/identity:/i\          addresses:" $HOME/public_full_node.yaml &&
#     sleep 1
#     sed -i'' -r -e '/identity:/i\          - "/ip4/175.118.42.185/tsudo cp/6180/ln-noise-ik/a950c9360c02c5ef9a02ad9a097f514b97f41a7499a2a798c530d610d3633e5c/ln-handshake/0"' $HOME/public_full_node.yaml
#     sleep 1
#     sed -i'' -r -e '/identity:/i\          role: "Upstream"' $HOME/public_full_node.yaml &&
#     sleep 1
#fi
grep -o "seeds: {}" $HOME/public_full_node.yaml > $HOME/seed.txt
if [ -s $HOME/seed.txt ]
then
    sed -i '/seeds:/d' $HOME/public_full_node.yaml &&
    sed -i'' -r -e '/Define the upstream peers to connect to/a\    seeds:' $HOME/public_full_node.yaml &&
    sleep 1
else
    sleep 1    
    sed -i '/{}/d' $HOME/public_full_node.yaml &&
    sleep 1
fi
grep -o "127.0.0.1" $HOME/public_full_node.yaml > $HOME/127001.txt &&
sleep 1
if [ -s $HOME/127001.txt ]
then
    sed -i "s/127.0.0.1/0.0.0.0/g" $HOME/public_full_node.yaml &&
    sleep 1
fi
sleep 1
grep -o "state_sync" $HOME/public_full_node.yaml > $HOME/v2_or_not.txt &&
sleep 1
if [ -s $HOME/v2_or_not.txt ]
then
    echo ""
    sudo cp $HOME/public_full_node.yaml $HOME/aptos &&
    echo ""
    sleep 1
    docker compose up -d &&
    sleep 1
    echo ""
    echo ""
    echo "Your node is running and checking health status now. Wait until checking process is completed!"
    echo ""
    sleep 3
    timeout 6 docker stats
    echo ""
    echo ""
else
    sed -n 9,11p $HOME/aptos/public_full_node.yaml > $HOME/v2_or_not.txt &&
    sleep 1
    sed -i'' -r -e "/execution:/i\state_sync:" $HOME/public_full_node.yaml &&
    sleep 1
    sed -i'' -r -e "/execution:/i\  state_sync_driver:" $HOME/public_full_node.yaml &&
    sleep 1
    sed -i'' -r -e "/execution:/i\    enable_state_sync_v2: true" $HOME/public_full_node.yaml &&
    sleep 1
    sudo cp $HOME/public_full_node.yaml $HOME/aptos
    echo ""
    echo ""
    echo ""
    sleep 3
    echo "Your state_sync_driver's version config in 'public_full_node.yaml' was upgraded to v2 successfully."
    echo ""
    echo ""
    docker compose up -d &&
    sleep 3
    echo ""
    echo ""
    echo "Your node is running and checking health status now. Wait until checking process is completed!"
    sleep 1
    echo ""
fi
echo "And from now another script for extracting your identity info and seed format for sharing starts..."
sleep 1
sudo wget -q -O aptos_seed_format_alan_yoon.sh https://raw.githubusercontent.com/shyoon71/installation-script/main/aptos_seed_format_alan_yoon.sh && sudo chmod +x aptos_seed_format_alan_yoon.sh && sudo /bin/bash aptos_seed_format_alan_yoon.sh > ../my_seed_format.txt && sed "s/^M//g" ../my_seed_format.txt > /dev/null && sed -i "s/'/\"/g" ../my_seed_format.txt
cat ../my_seed_format.txt
sleep 1
echo "Process for extracting identity info is completed! You can copy upper seed format on the screen directly."
sleep 1
echo ""
echo "You can find your correct seed format file at $HOME directory, and copy it printed from command 'cat my_seed_format.txt'."
sleep 3
sudo rm $HOME/default_seed.txt &> /dev/null &&
sudo rm $HOME/v2_or_not.txt &> /dev/null &&
sudo rm $HOME/aptos.sh &> /dev/null &&
sudo rm $HOME/kaptos_alan_yoon_v1.sh &> /dev/null &&
sudo rm $HOME/127001.txt &> /dev/null &&
sudo rm $HOME/seed.txt &> /dev/null &&
sudo rm $HOME/6180.txt &> /dev/null &&
sudo rm $HOME/admin_seed.txt &> /dev/null &&
sleep 3
echo ""
curl 127.0.0.1:9101/metrics 2> /dev/null | grep aptos_state_sync_version | grep type &&
sleep 3
echo ""
echo "Your node is syncing Now, so be patient for a while."
sleep 3
echo ""
curl 127.0.0.1:9101/metrics 2> /dev/null | grep aptos_state_sync_version | grep type &&
sleep 1
echo ""
echo "If docker is running and synced number is increasing continuously, your node can be considered as nosudo rmal running state."
sleep 1
echo ""
sudo wget -q -O command_alan_yoon.sh https://raw.githubusercontent.com/shyoon71/installation-script/main/command_alan_yoon.sh && sudo chmod +x command_alan_yoon.sh
sleep 0.2
sudo wget -q -O disk.sh https://raw.githubusercontent.com/shyoon71/installation-script/main/disk.sh && sudo chmod +x disk.sh && sudo sh disk.sh
sleep 0.2
echo ""
echo "========================================================================"

echo "Docker mode Aptos node command list  >> input at $HOME/aptos directory!!"

echo "========================================================================"

echo "To print this command list:" 
echo "    sh command_alan_yoon.sh  or  sh command*" 

echo "To stop the Aptos node:" 
echo "    docker compose stop" 

echo "To start the Aptos node:" 
echo "    docker compose start" 

echo "To check the Aptos node Logs:  >> To stop inut ctrl+c" 
echo "    docker compose logs -f --tail 1000" 

echo "To check outbound connection status: >> If number is not 0, it's ok!" 
echo "    curl 127.0.0.1:9101/metrics 2> /dev/null | grep 'aptos_connections{direction=\"outbound\"'"

echo "To check syncd status: >> The third [synced] number is matter!" 
echo "    curl 127.0.0.1:9101/metrics 2> /dev/null | grep aptos_state_sync_version | grep type"

echo "To check docker sudo cpu and memory utilization status:  >> sudo cpU % and MEM % is matter!!" 
echo "    docker stats --no-stream" 
echo ""
echo ""
