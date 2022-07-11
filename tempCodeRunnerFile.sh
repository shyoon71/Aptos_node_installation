timeout 0.5s docker-compose logs -f | grep [:alnum:] | grep remote_peer | grep ReceiveVote | grep false > peers_tracking.txt
peers=$(sed -n -e '1p')
peer_id=$(echo "$peers" | cut -d "." -f4)
echo "$peer_id"