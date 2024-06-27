<?php
// usage:
// php max_perf.php 2b7ac4b98d49d4c3802dbce439180be2 http://158.101.218.248:160/api_jsonrpc.php /root/zabbix-source/templates/db/mssql_odbc/template_db_mssql_odbc.yaml

// program expects to receive 3 arguments. all are mandatory
[, $auth, $api_url, $path] = $argv + array_fill(0, 4, '');

// check if 1st argument 'sid' has been specified
$auth !== '' or die('Define api key'.PHP_EOL);

// check if 2nd argument API URL has been defined
$api_url !== '' or die('Define api URL. for example http://127.0.0.1/api_jsonrpc.php'.PHP_EOL);

// check if 3rd argument is specified 
($path !== '' && file_exists($path)) or die("Incorrect path $path".PHP_EOL);

//echo $path,PHP_EOL;

// define a standart template import API
$request = json_encode([
    'jsonrpc' => '2.0',
    'method' => 'configuration.import',
    'params' => [
        'format' => 'yaml',
        'rules' => [
            'mediaTypes' => ['updateExisting' => false, 'createMissing' => true]
        ],
        'source' => file_get_contents($path)
    ],
    'auth' => $auth,
    'id' => (string)time()
]);

$response = file_get_contents($api_url, false, stream_context_create([
		'http' => [
			'method'  => 'POST',
			'header'  => 'Content-Type: application/json',
			'content' => $request
	]]));

$response = json_decode($response, true);

echo json_encode($response, JSON_PRETTY_PRINT),PHP_EOL;

