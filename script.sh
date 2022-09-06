#!/bin/bash

# Must vault and vals installed!!!
# Must define as an env VAULT_ADDR
# Environment path must be defined as an argument!!!

# For example: 
# ./script.sh westerops-prod/dongu-app values.yaml

# VAULT KV PUT
VAULT_KV_PATH=$1
VALUES_NAME=$2
vault kv put westerops-prod/credentials $(cat test.yaml | grep ^\* | cut -c 2- | sed -e 's/^[[:space:]]*//g' | vals env -f - | tr "\n" " ")

# ARRANGING ENVIRONMENT VARIABLES IN YAML

for param in $(grep ^\* $VALUES_NAME | cut -c 2- | cut -f 1 -d":" | tr -d "[:blank:]")
  do
    sed -i "s|$param.*|$param: ref+vault://$VAULT_KV_PATH/credentials#/$param|1" $VALUES_NAME
  done
sed -i "s/^*//g" $VALUES_NAME

