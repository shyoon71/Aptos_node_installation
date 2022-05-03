#!/bin/bash

echo ""
echo "\e[1m\e[33m노드 구동 상태 확인을 시작합니다... \e[0m"
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
a=0
while [ $a -lt 10 ]
do
   curl 127.0.0.1:9101/metrics 2> /dev/null | grep "aptos_state_sync_version{.*\"synced\"}" | awk '{print $2}'
   sleep 1
   a=`expr $a + 1`
done
echo ""
echo ""
echo "본인 노드 로컬 싱크정보 버전이 Aptos 블록체인의 버전을 지속적으로 따라가고 있는 지 확인바랍니다."
echo ""
echo "https://explorer.devnet.aptos.dev/ 의 LATEST VERSION ID 와 로그 상의 local_synced_version: 오른쪽 수치 간에 차이가 크지 않아야 합니다"
echo ""
echo ""
echo ""
echo ""
sleep 2

sleep 1


echo ""
echo ""
echo ""
echo ""