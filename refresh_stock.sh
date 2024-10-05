#!/bin/bash

# remove old dir. start fresh
rm -rf /tmp/7.0.zip
rm -rf /tmp/zabbix-release-7.0

# generate a SID by using:
# "Administration" => "General" => "API tokens"
SID=$(cat ~/.z70auth)

# API endpoint
JSONRPC=$(cat ~/.z70url)

# download latest 7.0 branch
curl -kL https://github.com/zabbix/zabbix/archive/refs/heads/release/7.0.zip -o /tmp/7.0.zip

# unzip
cd /tmp
unzip 7.0.zip

# go back to previous directory where PHP program is located
cd -

# start template import
find /tmp/zabbix-release-7.0/templates -type f -name '*.yaml' | \
while IFS= read -r TEMPLATE
do {
php delete_missing.php $SID $JSONRPC $TEMPLATE | jq .result | grep "true" > /dev/null && echo "OK $TEMPLATE" 
# if 'true' not received the print the template name
[[ $? -ne 0 ]] && echo "failed $TEMPLATE"
} done

find /tmp/zabbix-release-7.0/templates/media -type f -name '*.yaml' | \
while IFS= read -r MEDIA
do {
php media_type.php $SID $JSONRPC $MEDIA | jq .result | grep "true" > /dev/null && echo "OK $MEDIA"
# if 'true' not received the print the template name
[[ $? -ne 0 ]] && echo "failed $MEDIA"
} done

