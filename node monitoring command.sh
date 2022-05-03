#!/bin/bash

clear &&
echo ""
echo "\e[1m\e[33m지금부터 노드가 정상적인 구동 상태인지 확인하겠습니다... \e[0m"
echo ""
echo ""
cd
echo "\e[1m\e[33m도커 프로세스가 사용하는 CPU 부하율과 Memory 점유율 수치가 실시간으로 변하는 지 확인바랍니다. \e[0m"
sleep 6
echo ""
echo "\e[1m\e[33m노드 스타트 후 싱크 캐치업이 끝난 안정적인 상태라면 CPU 부하율과 Memory 점유율은 40% 이하가 바람직합니다. \e[0m"
sleep 6
a=0
while [ $a -lt 5 ]
do
   docker stats --no-stream
   sleep 2
   a=`expr $a + 1`
done
sleep 6
echo ""
cd ./aptos
sleep 1
echo "\e[1m\e[33m블록체인 상에서 이 노드가 실제로 트랜젝션을 만들고 있는 지 확인하겠습니다. \e[0m"
sleep 6
echo ""
timeout 10 docker compose logs -f --tail 1000 | grep "Applied transaction output chunk!" | grep local_synced_version &&
echo ""
echo "\e[1m\e[33m노드가 정상 동작한다면 트랜잭션 로그가 지속적으로 출력되어야 합니다. \e[0m"
sleep 6
echo ""
echo "\e[1m\e[33mAptos 블록체인 내 다른 노드와 접속하여 싱크 진행 중인 지 확인하기 위해 싱크정보 버전을 실시간 추출 중입니다... \e[0m"
sleep 6
echo ""
a=0
while [ $a -lt 10 ]
do
   curl 127.0.0.1:9101/metrics 2> /dev/null | grep "aptos_state_sync_version{.*\"synced\"}" | awk '{print $2}'
   sleep 2
   a=`expr $a + 1`
done
echo ""
echo "\e[1m\e[33m본인 노드 싱크정보 버전이 Aptos 블록체인의 버전을 지속적으로 따라가면서 증가하는 지 확인바랍니다. \e[0m"
sleep 3
apt-get install w3m > /dev/null
echo ""
echo "\e[1m\e[33mhttps://explorer.devnet.aptos.dev/ 의 LATEST VERSION ID 와 로그에서 추출된 싱크정보 버전 간에 차이가 크지 않아야 합니다. \e[0m"
sleep 6
echo ""
echo "\e[1m\e[33m브라우저로 Aptos 블록체인 대쉬보드에 접속하겠습니다. 위 수치와 근접한 지 확인바랍니다. 20초 이후에는 창이 닫힙니다. \e[0m"
timeout 20 w3m https://explorer.devnet.aptos.dev/
echo ""
echo ""
IP=$(ip route get 8.8.8.8 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}')
echo "\e[1m\e[33m외부 네트워크와 연결될 수 있는 지 포트 오픈 상태를 확인하겠습니다... \e[0m"
echo ""
sleep 5
nc -zvv $IP 9101 &&
sleep 5
echo ""
nc -zvv $IP 8080 &&
sleep 5
echo ""
nc -zvv $IP 6180 &&
sleep 2
echo ""
echo "\e[1m\e[33m3개 포트 모두 체크 결과 출력이 succeeded! 메세지이어야 합니다. 만약 Connection refused 메세지가 출력되면 오픈되지 않은 것입니다. \e[0m"
sleep 6
echo ""
echo "\e[1m\e[33m포트가 열리지 않는 대부분의 원인은 노드(도커)가 기동하지 않거나 도커 설정에 원인이 있습니다. 또한 VPS에서 포트포워딩 네트워크 설정이 필요한 경우도 있습니다. . \e[0m"
sleep 6
echo ""
echo "\e[1m\e[33m9101(METRICS) 8080(API) 2개는 웹페이지 모니터링, 6180(PEER INBOUND) 1개는 인바운드 접속용입니다. \e[0m"
echo ""
echo ""
echo ""
sleep 2
echo "\e[1m\e[33m이상으로 터미널에서 확인할 수 있는 노드 구동 상태 점검 작업을 마치겠습니다. \e[0m"
echo ""
echo ""
