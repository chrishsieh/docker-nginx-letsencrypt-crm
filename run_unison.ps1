
if (! ( Test-Path -Path "$PSScriptRoot\unison.exe" ) ) {
    Write-Host "Downloading unison..."

    $url = "http://github.com/bcpierce00/unison/releases/download/v2.51.2/unison-windows-2.51.2-text.zip"
    $output = "$PSScriptRoot\unison.zip"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -uri $url -OutFile $output -UseDefaultCredentials -SessionVariable ThisSession

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    function Unzip {
        param([string]$zipfile, [string]$outpath)

        [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
    }

    Unzip $output "$PSScriptRoot\unison"
    Copy-Item "$PSScriptRoot\unison\unison-windows-2.51.2-text\unison.exe" "$PSScriptRoot\unison.exe"
    Remove-Item "$PSScriptRoot\unison" -Recurse
    Remove-Item "$PSScriptRoot\unison.zip"
}

Write-Host "Folder path: $PSScriptRoot\..\CRM_sync"

if (! ( Test-Path "$PSScriptRoot\..\CRM_sync" -ne 1 ) ) {
    mkdir ../CRM_sync
}

unison.exe ../CRM_sync socket://127.0.0.1:5000/ -perms=0 -auto -numericids -batch -maxerrors 10 -repeat watch -silent
