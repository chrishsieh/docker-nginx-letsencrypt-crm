$IPV4_IP = "xdebug.remote_host="+(
    Get-NetIPConfiguration|Where-Object{$_.IPv4DefaultGateway -ne $null -and $_.NetAdapter.Status -ne "Disconnected"}
).IPv4Address.IPAddress

$replace_file = ".\setting\xdebug.ini"
(Get-Content $replace_file) -replace ("xdebug.remote_host=(.*)$",$IPV4_IP) | out-file $replace_file
