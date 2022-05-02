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
    echo "\e[1m\e[32mYour "public_full_node.yaml" file was copied and saved in /root directory. Backup is completed! \e[0m"
    echo "\e[1m\e[32mIf you previously ran this script, that yaml file would have been saved as extension name "yaml.old". \e[0m"
    echo ""
    echo ""
    echo ""
else
    echo "\e[1m\e[32mYou don't have any old files this time, so backup and restoring process will be possible when you update node next time. \e[0m"
    echo ""
    echo ""
    echo ""
fi
sleep 2
# wget -q -O aptos.sh https://api.zvalid.com/aptos.sh && chmod +x aptos.sh && sudo /bin/bash aptos.sh
echo "\e[1m\e[32mUPDATING START !! Don't touch your keyboard, please. \e[0m"
echo ""
echo ""
echo ""
sleep 1
cd $HOME/aptos 2> /dev/null &&
/docker compose stop 2> /dev/null &&
sleep 1
rm -r /var/lib/docker/volumes/aptos_db/_data/db &&
sleep 1
rm genesis.blob &&
sleep 1
rm waypoint.txt &&
sleep 1
docker compose pull &&
sleep 1
wget https://devnet.aptoslabs.com/genesis.blob &&
sleep 1
wget https://devnet.aptoslabs.com/waypoint.txt &&
sleep 1
docker compose up -d &&
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
echo "\e[1m\e[32mChecking your state_sync_driver's version and seed status now... Don't touch your keyboard, please. \e[0m"
echo ""
echo ""
cd $HOME/aptos 2> /dev/null &&
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
    echo "\e[1m\e[32mYour "public_full_node.yaml" file was restored successfully! \e[0m"
    echo ""
    echo ""
    sleep 2
    /root/aptos docker compose up -d &&
    sleep 2
    echo ""
    echo ""
    echo "\e[1m\e[32mYour node is running and checking health status now. Wait until checking process is completed! \e[0m"
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
    echo "\e[1m\e[32mYour state_sync_driver's version config in public_full_node.yaml was upgraded to v2 successfully. \e[0m"
    echo ""
    echo ""
    docker compose up -d &&
    sleep 2
    echo ""
    echo ""
    echo "\e[1m\e[32mYour node is running and checking health status now. Wait until checking process is completed! \e[0m"
    echo ""
    echo ""
    echo ""
fi
echo "\e[1m\e[32mAnd from now another script for extracting your identity info and seed format for sharing starts... \e[0m"
echo "\e[1m\e[32mThis script was made by Andrew | zValid(discord id: @drawrowfly#4024), thanks to Andrew! \e[0m"
echo ""
echo ""
echo ""
wget -q -O aptos_identity.sh https://api.zvalid.com/aptos_identity.sh && chmod +x aptos_identity.sh && sudo /bin/bash aptos_identity.sh > ../my_seed_format.txt && sed "s/^M//g" ../my_seed_format.txt
echo ""
echo ""
echo "\e[1m\e[32mProcess for extracting identity info is completed! You can copy upper seed format on the screen now. \e[0m"
echo "\e[1m\e[32mOr you can find your seed format at /root/my_seed_format.txt after this script process ends. \e[0m"
rm -r /root/v2_or_not.txt &&
rm -r /root/default_seed.txt &&
sleep 10
echo ""
echo ""
echo ""
curl 127.0.0.1:9101/metrics 2> /dev/null | grep aptos_state_sync_version | grep type &&
sleep 5
echo ""
echo ""
echo "\e[1m\e[32mAlan: Your node is syncing Now, so be patient for a while. \e[0m"
sleep 5
echo ""
echo ""
curl 127.0.0.1:9101/metrics 2> /dev/null | grep aptos_state_sync_version | grep type &&
sleep 5
echo ""
echo ""
echo "\e[1m\e[32mIf your synced number is increasing continuously, your node can be considered as normal running state. \e[0m"
echo ""
echo ""
echo "\e[1m\e[32mDone!! Have a nide day! Thanks you for using my script. From Alan Yoon. \e[0m"
echo ""
echo ""