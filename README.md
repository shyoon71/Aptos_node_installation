# installation-script

This script provides the following two functions
1. Backup and restoring your seeds info in public_full_node.yaml
2. Check version of state_sync_driver in your public_full_node.yaml, upgrade version as v2 if not v2

I adopted Andrew | zValid(Discord id @drawrowfly#4024)'s script as the main installation script

installation Script Command :

sudo su

cd ~

wget -q -O kaptos_alan_yoon_v1.sh https://raw.githubusercontent.com/shyoon71/installation-script/main/kaptos_alan_yoon_v1.sh && chmod +x kaptos_alan_yoon_v1.sh && sudo sh ./kaptos_alan_yoon_v1.sh
