#!/bin/bash

TOTAL=$(df -P | grep -v ^Filesystem | awk '{sum += $2} END { print sum/1024/1024 " GB" }')
USED=$(df -P | grep -v ^Filesystem | awk '{sum += $3} END { print sum/1024/1024 " GB" }')

echo "============================="
echo " DISK Total Size:" $TOTAL
echo " DISK Used  Size:" $USED
echo "============================="
