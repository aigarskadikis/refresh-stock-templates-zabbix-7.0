#!/bin/bash

# current directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# remove old directory
rm -rf /tmp/zabbix-release-7.0

mkdir -p /tmp/zabbix-release-7.0

# generate a SID by using:
# "Administration" => "General" => "API tokens"
SID=$(cat ~/.z70auth)

# Frontend endpoint
JSONRPC=$(cat ~/.z70url)/api_jsonrpc.php

# download latest 7.0 branch from github
curl -kL "https://git.zabbix.com/rest/api/latest/projects/ZBX/repos/zabbix/archive?at=refs%2Fheads%2Frelease%2F7.0&format=zip" -o "/tmp/zabbix-release-7.0/7.0.zip"

# unzip
cd /tmp/zabbix-release-7.0
unzip 7.0.zip

cd -

# start template import
find /tmp/zabbix-release-7.0/templates -type f -name '*.yaml' | \
while IFS= read -r TEMPLATE
do {
#php "$SCRIPT_DIR/delete_missing.php" "$SID" "$JSONRPC" "$TEMPLATE" | jq .result

php "$SCRIPT_DIR/delete_missing.php" "$SID" "$JSONRPC" "$TEMPLATE" | jq .result | grep "true" > /dev/null && echo "OK $TEMPLATE" 
# if 'true' not received the print the template name
[[ $? -ne 0 ]] && echo "failed $TEMPLATE"
} done

# remove working directory
rm -rf /tmp/zabbix-release-7.0

