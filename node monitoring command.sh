#!/bin/bash

echo "노드 구동 상태 확인을 시작합니다..."
echo ""
sleep 3
echo "CPU 부하율과 Memory 점유율 수치가 실시간으로 변하는 지 확인바랍니다."
echo "노드 스타트 후 초기 싱크 캐치업이 끝난 안정적인 상태라면 Memory 점유율은 50% 이하여야 합니다 "
sleep 2
timeout 6 docker stats &&
sleep 1
echo "본인 노드 로컬 싱크정보 버전이 Aptos 블록체인의 버전을 지속적으로 따라가고 있는 지 확인바랍니다."
echo "https://explorer.devnet.aptos.dev/ 의 LATEST VERSION ID 와 로그 상의 local_synced_version: 오른쪽 수치 간에 차이가 크지 않아야 합니다"
sleep 2
timeout 15 docker compose logs -f --tail 1000 | grep "Applied transaction output chunk!" | grep local_synced_version &&
sleep 1


echo ""
echo ""
echo ""
echo ""