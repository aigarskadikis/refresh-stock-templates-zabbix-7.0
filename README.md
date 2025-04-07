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
grep "7.0" refresh_stock.sh
```

Install URL of frontend
```bash
echo "https://127.0.0.1:44370" | tee ~/.zabbix-7.0-url
```

Install token
```bash
echo "token" | tee ~/.zabbix-7.0-auth
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

Version 7.2 compatibility. Replace keyword "7.0" with 7.2
```bash
sed 's|7.0|7.2|g' refresh_stock.sh > 7.2.sh
```

Set executable
```
chmod +x 7.2.sh
```

Make sure the frontend URL and token exists
```
echo "https://127.0.0.1:44372" | tee ~/.zabbix-7.2-url
echo "token" | tee ~/.zabbix-7.2-auth
```
