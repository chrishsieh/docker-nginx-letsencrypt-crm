$Docker_Compose_file = "docker-compose.yml"
$Build_Code_Version = 'latest'
$Dev = Read-Host -Prompt 'For development ? (yes or no)'
if ($Dev -ne "yes") {$Dev = "no"}

if ($Dev -eq "yes") {
	$ServerType = Read-Host -Prompt 'Input web server type(nginx or apache)'
	if ( $ServerType -ne "apache" ) { $ServerType = "nginx"}

	if ( $ServerType -eq "nginx" ) {
		$OSType = Read-Host -Prompt 'Input OS type(debian or alpine)'
		if ( $OSType -ne "alpine" ) { $OSType = "debian"}
		$Docker_Compose_file = "docker-compose-dev.yml"
		if ( $OSType -eq "alpine" ) { $Build_Code_Version = 'alpine-latest'}
	}
	else {
		$Docker_Compose_file = "docker-compose-dev-apache.yml"
	}

	$replace_file = ".\$Docker_Compose_file"

	if ( $ServerType -eq "nginx" ) {
		(Get-Content $replace_file) -replace ("image: chrishsieh/php-fpm-dev:(.*)$", "image: chrishsieh/php-fpm-dev:$Build_Code_Version") | Out-File -encoding ASCII $replace_file
	}

	if ( $OSType -eq "alpine") {
		(Get-Content $replace_file) -replace ("OWNER_UID: (.*)$", "OWNER_UID: 82") | Out-File -encoding ASCII $replace_file
	} else {
		(Get-Content $replace_file) -replace ("OWNER_UID: (.*)$", "OWNER_UID: 33") | Out-File -encoding ASCII $replace_file
	}
	Write-Host "$Docker_Compose_file updated"

	Write-Host "Getting Host IP ..."
	.\replace_xdebug_host_ip.ps1
	Write-Host "xdebug.ini updated"
}

$replace_file = ".\Vagrantfile"
(Get-Content $replace_file) -replace ("docker-compose(.*).yml", $Docker_Compose_file) | Out-File -encoding ASCII $replace_file
if ($Docker_Compose_file -ne "docker-compose.yml") {
    (Get-Content $replace_file) -replace ("v.memory =(.*)$", "v.memory = 4096") | Out-File -encoding ASCII $replace_file
} else {
    (Get-Content $replace_file) -replace ("v.memory =(.*)$", "v.memory = 1024") | Out-File -encoding ASCII $replace_file
}
Write-Host "Vagrantfile updated"