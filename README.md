# Refresh stock templates for Zabbix 7.0
Use Zabbix API, PHP, bash to renew and overwrite all stock templates

Validate home directory of user "zabbix"
```bash
grep "zabbix" /etc/passwd
```

Make home directory
```bash
mkdir -p /var/lib/zabbix
```

If this script was run before then clean up remainings
```bash
rm "/tmp/zabbix-release-7.0" -rf
rm "/var/log/zabbix/refresh_70_templates*" -rf
```

Open service user "zabbix"
```bash
su - zabbix -s /bin/bash
```

Fetch this project
```bash
curl -kL "https://github.com/aigarskadikis/refresh-stock-templates-zabbix-7.0/archive/refs/heads/main.zip" -o main.zip
```

Unpack archive
```bash
unzip main.zip
```

Remove archive
```
rm -rf main.zip
```

Navigate to project directory
```bash
cd refresh-stock-templates-zabbix-7.0-main
```

See the files used for URL and TOKEN
```bash
grep z70 refresh_stock.sh
```

Install URL of frontend
```bash
echo "https://127.0.0.1:44370" | tee ~/.z70url
```

Install token
```bash
echo "af021232df58dc3fbbf7a6b3bcf70239dd73367afd8534363463ff24c823a0c3" | tee ~/.z70auth
```

Run program to renew all templates and media types
```bash
./refresh_stock.sh
```

Exit service user
```bash
exit
```

Install cronjob:
```
echo "57 3 * * * zabbix /var/lib/zabbix/refresh-stock-templates-zabbix-7.0-main/refresh_stock.sh > /var/log/zabbix/refresh_70_templates.log 2>&1" | sudo tee /etc/cron.d/refresh_zabbix70_templates
```
