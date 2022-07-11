echo "Disk Usage Info"
echo "================================"
df -h | grep "Avail"; df -h | grep "/$"
echo "================================"
echo ""
echo "Node Uptime"
echo "================================"
pid=$(ps -ef|grep aptos-node)
echo "$pid"|sed -n -e '1p'
up=$(pgrep -f aptos-node)
ps -p $up -o etime
echo "================================"
echo ""