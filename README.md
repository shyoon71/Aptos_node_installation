Installation-script

  I adopted Andrew | zValid(Discord id @drawrowfly#4024)'s script as the main installation script

# Auto Setup/Update Script :

  1. Docker mode for devnet
  
  wget -q -O kaptos_alan_yoon_v1.sh https://raw.githubusercontent.com/shyoon71/installation-script/main/kaptos_alan_yoon_v1.sh && chmod +x kaptos_alan_yoon_v1.sh && sudo sh ./kaptos_alan_yoon_v1.sh

  2. Docker mode for testnet
  
  wget -q -O testnet_alanyoon.sh https://raw.githubusercontent.com/shyoon71/installation-script/main/testnet_alanyoon.sh && chmod +x testnet_alanyoon.sh && sudo sh ./testnet_alanyoon.sh

  3. Compiling mode for devnet
  
  wget -q -O kaptos_alan_yoon_v2.sh https://raw.githubusercontent.com/shyoon71/installation-script/main/kaptos_alan_yoon_v2.sh && chmod +x kaptos_alan_yoon_v2.sh && sudo sh ./kaptos_alan_yoon_v2.sh

# Auto Restart Script :

  1. Docker mode for common
  
  sudo wget -q -O aptos_restart.sh https://raw.githubusercontent.com/shyoon71/installation-script/main/aptos_restart.sh && sudo chmod +x aptos_restart.sh && sudo nohup ./aptos_restart.sh > restart_log.out &

< restart criteria >

  1.1 scan term: 5 min
  
  1.2 target log phrase: aptos_state_sync_continuous_syncer_errors, aptos_state_sync_timeout
  
  1.3 print error count(/min) if there are difference beween terms  
  
  1.4 target log figure: aptos_storage_ledger_version
  
  1.5 restart node if syncing speed has fallen below 20% between terms
  
  1.6 download and update restart script, refresh log(~/aptos/restart_log.out) every two days 

# Notion guide page :

 Main - https://superb-mulberry-ce1.notion.site/Aptos-Node-Installation-Guide-6cc0e1081bda4e47b2a8b9fa0d81ef47

  1. Step By Step (Testnet-Ph1: completed) - https://www.notion.so/Step-By-Step-Testnet-Ph1-1bb8e3491f9642a4a3ce07c5a5c424c3

  2. Step By Step (Testnet-Ph2: waiting..) - https://www.notion.so/Step-By-Step-Testnet-Ph2-6-bd9d91ea9418467ab4a9b8ac805c95bc

  3. Auto Scripts (Devnet) - https://www.notion.so/Auto-Scripts-Devnet-d4f15da037114b4785f4c55e16d34d0a

  4. Auto Script (Auto Restart) - https://www.notion.so/Auto-Script-Auto-Restart-589bcb66304f4a4294439bd960042fd0

  5. Monitoring (Prometheus and Grafana: No kubernetes) - https://www.notion.so/Monitoring-Prometheus-and-Grafana-3462e2dfc3b64a4a94d659b84ac19182

  6. Memory Solution for Low Spec. Server - https://www.notion.so/Memory-Solution-for-Low-Spec-Server-ad02e5f103e14fa48bbdea6809f67cde
