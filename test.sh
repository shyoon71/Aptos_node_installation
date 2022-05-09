#!/bin/bash

grep -o "127.0.0.1" /root/public_full_node.yaml > /root/127001.txt
sleep 0.1
if [ -s /root/127001.txt ]
then
    sed -i "s/127.0.0.1/0.0.0.0/g" /root/public_full_node.yaml &&
    sleep 0.1
fi
