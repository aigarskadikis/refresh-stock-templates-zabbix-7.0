#!/bin/bash

# exit on any failure
set -e

# print commands
set -o xtrace

# read current directory to automatically understand where is php file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# remove old directory
rm -rf /tmp/zabbix-release-7.0

# make fresh directory
mkdir -p /tmp/zabbix-release-7.0

# generate static session token by using menu "Users" => "API tokens"
SID=$(cat ~/.zabbix-7.0-auth)

# frontend endpoint
JSONRPC=$(cat ~/.zabbix-7.0-url)/api_jsonrpc.php

# download latest 7.0 branch from official repository of vendor
curl --insecure \
--location \
--output "/tmp/zabbix-release-7.0/7.0.zip" \
"https://git.zabbix.com/rest/api/latest/projects/ZBX/repos/zabbix/archive?at=refs%2Fheads%2Frelease%2F7.0&format=zip"

# unzip
cd "/tmp/zabbix-release-7.0"
unzip "7.0.zip"
rm -rf "/tmp/zabbix-release-7.0/7.0.zip"

# do not print detailed commands
set +o xtrace

# start template import
find /tmp/zabbix-release-7.0/templates -type f -name '*.yaml' | \
while IFS= read -r TEMPLATE
do {
php "$SCRIPT_DIR/delete_missing.php" "$SID" "$JSONRPC" "$TEMPLATE" | \
jq .result | \
grep "true" > /dev/null && echo "OK $TEMPLATE"
# if 'true' not received the print the template name
[[ $? -ne 0 ]] && echo "failed $TEMPLATE"
} done

# print commands
set -o xtrace

# remove working directory
rm -rf "/tmp/zabbix-release-7.0"

