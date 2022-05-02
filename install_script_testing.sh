#!/bin/bash

clear
echo ""
echo ""
echo ""
cd ~
sleep 1
if [ -f /root/aptos/public_full_node.yaml ]
then
    cp /root/aptos/public_full_node.yaml ./public_full_node.yaml.old &&
    cp /root/aptos/public_full_node.yaml ./
    sleep 2
else
    touch ./public_full_node.yaml &&
    sleep 2
fi
if [ -s /root/public_full_node.yaml ]
then
    echo ""
    echo ""
    echo ""
    sleep 1
    echo "Your "public_full_node.yaml" file was copied and saved in /root directory."
    echo "Backup process completed!"
    echo ""
    echo ""
    echo ""
else
    echo "You don't have any old files this time, so backup and restoring process will be possible when you update node next time."
    echo ""
    echo ""
    echo ""
fi
sleep 2
# wget -q -O aptos.sh https://api.zvalid.com/aptos.sh && chmod +x aptos.sh && sudo /bin/bash aptos.sh
echo "UPDATING START !! Don't touch your keyboard, please."
echo ""
echo ""
echo ""
sleep 1
docker-compose down &&
sleep 1
rm waypoint.txt &&
rm genesis.blob &&
curl https://devnet.aptoslabs.com/waypoint.txt --output waypoint.txt &&
sleep1
curl https://devnet.aptoslabs.com/genesis.blob --output genesis.blob &&
sleep 1
docker volume rm aptos_db -f 2> /dev/null &&
sleep 1
rm -r /var/lib/docker/volumes/aptos_db/_data/db 2> /dev/null &&
sleep 1
docker-compose pull &&
sleep 1
docker-compose up -d &&
sleep 1
echo ""
if [ -s /root/public_full_node.yaml ]
then
    echo ""
    echo ""
else
    cp /root/aptos/public_full_node.yaml /root/public_full_node.yaml &&
    sleep 2
fi
echo ""
echo ""
echo "Checking your state_sync_driver's version and seed status now... Don't touch your keyboard, please."
echo ""
echo ""
cd aptos
docker compose down &&
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
    sed -i'' -r -e "/identity:/i\        addresses:" /root/public_full_node.yaml &&
    sleep 1
    sed -i'' -r -e '/identity:/i\        - "/ip4/175.118.42.185/tcp/6180/ln-noise-ik/a950c9360c02c5ef9a02ad9a097f514b97f41a7499a2a798c530d610d3633e5c/ln-handshake/0"' /root/public_full_node.yaml
    sleep 1
    sed -i'' -r -e '/identity:/i\        role: "Upstream"' /root/public_full_node.yaml &&
    sleep 1
    sed -i 's/seeds: {}/seeds:/g' /root/public_full_node.yaml &&
    sleep 1
fi
sleep 3
grep -o "state_sync" /root/public_full_node.yaml > /root/v2_or_not.txt &&
sleep 2
if [ -s /root/v2_or_not.txt ]
then
    echo ""
    echo ""
    cp /root/public_full_node.yaml /root/aptos &&
    echo "Your "public_full_node.yaml" file was restored successfully!"
    echo ""
    echo ""
    sleep 2
    docker compose up -d &&
    sleep 2
    echo ""
    echo ""
    echo "Your node is running and checking health status now. Wait until checking process is completed!"
    echo ""
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
    cp /root/public_full_node.yaml /root/aptos
    echo ""
    echo ""
    echo ""
    sleep 2
    echo "Your state_sync_driver's version config in public_full_node.yaml was upgraded to v2 successfully."
    echo ""
    echo ""
    docker compose up -d &&
    sleep 2
    echo ""
    echo ""
    echo "Your node is running and checking health status now. Wait until checking process is completed!"
    echo ""
    echo ""
    echo ""
fi
echo "And from now another script for extracting your identity info and seed format for sharing starts..."
echo "\e[1m\e[32mThis script was made by Andrew | zValid(discord id: @drawrowfly#4024), thanks to Andrew! \e[0m"
echo ""
echo ""
echo ""
wget -q -O aptos_identity.sh https://api.zvalid.com/aptos_identity.sh && chmod +x aptos_identity.sh && sudo /bin/bash aptos_identity.sh > ../my_seed_format.txt && sed "s/^M//g" ../my_seed_format.txt
echo ""
echo ""
echo "Alan: Process for extracting identity info is completed! You can copy upper seed format on the screen now."
echo "Or you can find your seed format at /root/my_seed_format.txt after this script process ends."
sleep 10
echo ""
echo ""
echo ""
curl 127.0.0.1:9101/metrics 2> /dev/null | grep aptos_state_sync_version | grep type &&
sleep 5
echo ""
echo ""
echo "\e[1m\e[35mAlan: Your node is syncing Now, so be patient for a while. \e[0m"
sleep 5
echo ""
echo ""
curl 127.0.0.1:9101/metrics 2> /dev/null | grep aptos_state_sync_version | grep type &&
sleep 5
echo ""
echo ""
echo "If your synced number is increasing continuously, your node can be considered as normal running state."
echo ""
echo ""
echo "Done!! Have a nide day! from Alan Yoon"
echo ""
echo ""
