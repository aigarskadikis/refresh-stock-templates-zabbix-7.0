# Refresh stock templates for Zabbix 7.0
Use Zabbix API, PHP, bash to renew and overwrite all stock templates

Navigate to home
```
cd
```

Fetch this project
```
wget https://github.com/aigarskadikis/refresh-stock-templates-zabbix-7.0/archive/refs/heads/main.zip
```

Unpack archive
```
unzip main.zip
```

Navigate to project directory
```
cd refresh-stock-templates-zabbix-7.0-main
```

See the files used for URL and TOKEN
```
grep z70 refresh_stock.sh
```

Install URL of frontend
```
echo frontendURL | tee ~/.z70url
```

Install token
```
echo token | tee ~/.z70auth
```

Run program to renew all templates and media types
```
./refresh_stock.sh
```
