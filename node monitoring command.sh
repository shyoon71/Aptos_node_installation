#!/bin/bash

echo ""
echo "\e[1m\e[33m노드가 정상적인 구동 상태인지 확인하겠습니다... \e[0m"
echo ""
cd
sleep 3
timeout 15 docker stats &&
echo ""
echo ""
echo "\e[1m\e[33mCPU 부하율과 Memory 점유율 수치가 실시간으로 변하는 지 확인바랍니다. \e[0m"
echo ""
echo "\e[1m\e[33m노드 스타트 후 싱크 캐치업이 끝난 안정적인 상태라면 CPU 부하율과 Memory 점유율은 40% 이하가 바람직합니다. \e[0m"
sleep 5
cd ./aptos
sleep 1
timeout 10 docker compose logs -f --tail 1000 | grep "Applied transaction output chunk!" | grep local_synced_version &&
echo ""
sleep 1
echo "\e[1m\e[33m로그에서 싱크정보 버전 실시간 추출 중... \e[0m"
echo ""
a=0
while [ $a -lt 10 ]
do
   curl 127.0.0.1:9101/metrics 2> /dev/null | grep "aptos_state_sync_version{.*\"synced\"}" | awk '{print $2}'
   sleep 1
   a=`expr $a + 1`
done
echo ""
echo ""
echo "\e[1m\e[33m본인 노드 싱크정보 버전이 Aptos 블록체인의 버전을 지속적으로 따라가면서 증가하는 지 확인바랍니다. \e[0m"
echo ""
echo "\e[1m\e[33mhttps://explorer.devnet.aptos.dev/ 의 LATEST VERSION ID 와 로그에서 추출된 싱크정보 버전 간에 차이가 크지 않아야 합니다. \e[0m"
echo ""
echo ""
echo ""
IP=$(ip route get 8.8.8.8 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}')
echo "\e[1m\e[33m외부 네트워크와 연결될 수 있는 지 포트 오픈 상태를 확인하겠습니다... \e[0m"
echo ""
nc -zvv $IP 9101 &&
sleep 5
echo ""
nc -zvv $IP 8080 &&
sleep 5
echo ""
nc -zvv $IP 6180 &&
sleep 3
echo ""
echo ""
echo "\e[1m\e[32m3개 포트 모두 port [tcp/*] succeeded! 메세지를 출력해야 합니다. 만약 Connection refused 메세지가 출력되면 비정상입니다. \e[0m"
echo ""
echo "\e[1m\e[33m9101(METRICS) 8080(API) 2개는 웹페이지 모니터링, 6180(PEER INBOUND) 1개는 인바운드 접속용입니다. \e[0m"
echo ""
echo ""
sleep 2
