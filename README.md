# For beginners who want to install node and experience the amazing Aptos network

# CLI Validator Check Script :

  It is not good to monitor the validator node through the web page because there is a high risk of opening and using metrics and api ports during the AIT test period. So I wrote a script that can automatically execute the main commands so that we can conveniently check the status of the node on the terminal console.
  
  wget -q -O cli_checker_validator.sh https://raw.githubusercontent.com/shyoon71/installation-script/main/cli_checker_validator.sh && chmod +x cli_checker_validator.sh && sudo bash ./cli_checker_validator.sh

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
  
  3. print total error count(/min) if there are errors count > 1 per minute between terms
  
  4. target log figure: aptos_state_sync_version{type="synced"}
  
  5. print synced version numbers if syncing speed has fallen below 20% between terms
  
  6. if synced version stuck or syncing speed has fallen below 20% between terms with error count > 10 per minute, start tracing synced version and restart node after 5 minutes if it has no changes 
  
  7. Forcibly restarting the node after 5 minutes has elapsed while the node has already "stopped abruptly" due to an uncertain cause and the docker remains in the exited state.
  
  8. print message with ledger version if node completes catchup version 
  
  9. log(~/$WORKSPACE/restart_log.out) file refresh itself and rename old log file as .old every week

  10. if you want to delete script running at background, follow command below
  
      ps -ef | grep aptos_restart.sh
      kill -9 PID PID (maybe 2 process)

# Notion Guide Page :

  Main - https://superb-mulberry-ce1.notion.site/Aptos-Node-Installation-Guide-6cc0e1081bda4e47b2a8b9fa0d81ef47

  1. Step By Step (Testnet-Ph1: completed) - https://www.notion.so/Step-By-Step-Testnet-Ph1-1bb8e3491f9642a4a3ce07c5a5c424c3

  2. Step By Step (Testnet-Ph2: waiting..) - https://www.notion.so/Step-By-Step-Testnet-Ph2-6-bd9d91ea9418467ab4a9b8ac805c95bc

  3. Auto Scripts (Devnet) - https://www.notion.so/Auto-Scripts-Devnet-d4f15da037114b4785f4c55e16d34d0a

  4. Auto Script (Auto Restarting) - https://www.notion.so/Auto-Script-Auto-Restart-589bcb66304f4a4294439bd960042fd0

  5. Monitoring (Prometheus and Grafana: Korean) - https://superb-mulberry-ce1.notion.site/Monitoring-Node-Background-Service-3462e2dfc3b64a4a94d659b84ac19182

  6. Monitoring (Prometheus and Grafana: English) - https://superb-mulberry-ce1.notion.site/Monitoring-Node-English-Version-52f03d307c5b405fb7483569c6fd47ca

  7. Memory Swap Solution for Low Spec. Server - https://www.notion.so/Memory-Solution-for-Low-Spec-Server-ad02e5f103e14fa48bbdea6809f67cde
