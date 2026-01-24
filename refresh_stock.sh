#!/bin/bash

# exit on any failure
set -e

# print commands
set -o xtrace

# read current directory to automatically understand where is php file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RELEASE=$(/usr/bin/curl -s -X POST -H "Content-Type: application/json" \
	-d '{"jsonrpc":"2.0","method":"apiinfo.version","params":{},"id":1}' \
	"$(cat ~/.zabbix-url)/api_jsonrpc.php" \
	| jq -r .result | sed -E 's/\.[0-9]+$//' )

echo "RELEASE=${RELEASE}"

# remove old directory
rm -rf /tmp/zabbix-release-${RELEASE}

# make fresh directory
mkdir -p /tmp/zabbix-release-${RELEASE}

# generate static session token by using menu "Users" => "API tokens"
SID=$(cat ~/.zabbix-auth)

# frontend endpoint
JSONRPC=$(cat ~/.zabbix-url)/api_jsonrpc.php

# download latest ${RELEASE} branch from official repository of vendor
curl --insecure \
--location \
--output "/tmp/zabbix-release-${RELEASE}/${RELEASE}.zip" \
"https://git.zabbix.com/rest/api/latest/projects/ZBX/repos/zabbix/archive?at=refs%2Fheads%2Frelease%2F${RELEASE}&format=zip"

# unzip
cd "/tmp/zabbix-release-${RELEASE}"
unzip "${RELEASE}.zip"
rm -rf "/tmp/zabbix-release-${RELEASE}/${RELEASE}.zip"

# do not print detailed commands
set +o xtrace

# start template import
find /tmp/zabbix-release-${RELEASE}/templates -type f -name '*.yaml' | \
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
rm -rf "/tmp/zabbix-release-${RELEASE}"

