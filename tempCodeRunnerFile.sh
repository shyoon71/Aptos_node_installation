echo "Checking Liveness"
echo "================================"
curl 127.0.0.1:80 2> /dev/null; curl 127.0.0.1:8080 2> /dev/null
live=$(curl 127.0.0.1:80) ; live2=$(curl 127.0.0.1:8080)
echo "================================"
if [ -z $live ]
then
    if [ -z $live2 ]
    then
        echo "Can't fetch out your connection status."
        echo "Node looks like have no liveness"
    else
        echo "ok."    
    fi
else
    echo "ok."
fi