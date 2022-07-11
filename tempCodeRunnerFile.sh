up=$(pgrep -f aptos-node)
up2=$(ps -p $up -o etime)
up3=$(echo "$up2"|sed -n -e '2p')
day=$(echo $up3 | cut -d '-' -f1)
hour=$(echo $up3 | cut -d ':' -f2)
min=$(echo $up3 | cut -d ':' -f3)
echo "Node has been running for " $day "days" $hour "hours" $min "minutes"