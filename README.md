# For beginners who want to install node and experience the amazing Aptos network

# Auto Setup/Update Script :

I adopted Andrew | zValid(Discord id @drawrowfly#4024)'s scripts as the main installation script.

  1. Docker mode for devnet
  
  wget -q -O kaptos_alan_yoon_v1.sh https://raw.githubusercontent.com/shyoon71/installation-script/main/kaptos_alan_yoon_v1.sh && chmod +x kaptos_alan_yoon_v1.sh && sudo sh ./kaptos_alan_yoon_v1.sh

  2. Docker mode for testnet
  
  wget -q -O testnet_alanyoon.sh https://raw.githubusercontent.com/shyoon71/installation-script/main/testnet_alanyoon.sh && chmod +x testnet_alanyoon.sh && sudo sh ./testnet_alanyoon.sh

  3. Compiling mode for devnet
  
  wget -q -O kaptos_alan_yoon_v2.sh https://raw.githubusercontent.com/shyoon71/installation-script/main/kaptos_alan_yoon_v2.sh && chmod +x kaptos_alan_yoon_v2.sh && sudo sh ./kaptos_alan_yoon_v2.sh

# Auto Restarting Script :
  
  sudo wget -q -O aptos_restart.sh https://raw.githubusercontent.com/shyoon71/installation-script/main/aptos_restart.sh && sudo chmod +x aptos_restart.sh && sudo nohup ./aptos_restart.sh > restart_log.out &

< operational criteria >

  1. log scan term: 1 min
  
  2. target log phrase:
 
    2-1. aptos_state_sync_continuous_syncer_errors{error_label="unexpected_error"}

    2-2. aptos_state_sync_continuous_syncer_errors{error_label="data_stream_notification_timeout"}
    
    2-3. aptos_state_sync_timeout_total
  
  3. print total error count(/min) if there are errors count > 10 per minute between terms
  
  4. target log figure: 

    4-1. aptos_state_sync_version{type="synced"}
  
  5. print synced version numbers if syncing speed has fallen below 20% between terms
  
  6. restart node if synced version stuck or syncing speed has fallen below 20% between terms with error count > 10 per minute
  
  7. Forcibly starting the node after 10 minutes has elapsed while the node has already stopped abruptly due to an uncertain cause and the docker remains in the exited state.
  
  8. print message with ledger version if node completes catchup version 
  
  9. download and update restart script, refresh log(~/aptos/restart_log.out) every week 

# Notion Guide Page :

 Main - https://superb-mulberry-ce1.notion.site/Aptos-Node-Installation-Guide-6cc0e1081bda4e47b2a8b9fa0d81ef47

  1. Step By Step (Testnet-Ph1: completed) - https://www.notion.so/Step-By-Step-Testnet-Ph1-1bb8e3491f9642a4a3ce07c5a5c424c3

  2. Step By Step (Testnet-Ph2: waiting..) - https://www.notion.so/Step-By-Step-Testnet-Ph2-6-bd9d91ea9418467ab4a9b8ac805c95bc

  3. Auto Scripts (Devnet) - https://www.notion.so/Auto-Scripts-Devnet-d4f15da037114b4785f4c55e16d34d0a

  4. Auto Script (Auto Restarting) - https://www.notion.so/Auto-Script-Auto-Restart-589bcb66304f4a4294439bd960042fd0

  5. Monitoring (Prometheus and Grafana: Korean) - https://superb-mulberry-ce1.notion.site/Monitoring-Node-Background-Service-3462e2dfc3b64a4a94d659b84ac19182

  6. Monitoring (Prometheus and Grafana: English) - https://superb-mulberry-ce1.notion.site/Monitoring-Node-English-Version-52f03d307c5b405fb7483569c6fd47ca

  7. Memory Swap Solution for Low Spec. Server - https://www.notion.so/Memory-Solution-for-Low-Spec-Server-ad02e5f103e14fa48bbdea6809f67cde
