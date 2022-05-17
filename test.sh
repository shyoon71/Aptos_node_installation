touch layout.yaml && sleep 0.2

echo '---
root_key: "0x5243ca72b0766d9e9cbf2debf6153443b01a1e0e6d086c7ea206eaf6f8043956"
users:
  - '$ID'
chain_id: 23' > layout.yaml && sleep 0.5

aptos key generate --output-file root-key.yaml && sleep 1

ROOT=$(cat root-key.yaml) && sleep 0.2

sed -i '/root_key:/d' layout.yaml

sed -i'' -r -e '/---/a\root_key: ""$ROOT""' layout.yaml && sleep 1