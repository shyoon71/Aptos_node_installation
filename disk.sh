#!/bin/bash

TOTAL=$(df -P | grep -v ^Filesystem | awk '{sum += $2} END { print sum/1024/1024 " GB" }')
USED=$(df -P | grep -v ^Filesystem | awk '{sum += $3} END { print sum/1024/1024 " GB" }')

echo "============================"
echo "DISK Total Size: \e[0m" $TOTAL
echo "DISK Used  Size: \e[0m" $USED
echo "============================"