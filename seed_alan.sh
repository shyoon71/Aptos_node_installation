#!/bin/bash

wget -q -O aptos_seed_format_alan_yoon.sh https://raw.githubusercontent.com/shyoon71/installation-script/main/aptos_seed_format_alan_yoon.sh && chmod +x aptos_seed_format_alan_yoon.sh && sudo /bin/bash aptos_seed_format_alan_yoon.sh
rm seed_alan.sh > /dev/null &&
echo ""
