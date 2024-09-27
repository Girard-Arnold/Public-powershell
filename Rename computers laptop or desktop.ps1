<# According to https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-computersystem 
1 should be Desktop, 2 should be Laptop, 3 is technically Workstation#>

$Timestamp = get-date -f yyyymmmmHHmm

$DefaultFolder = "C:\GP"
if ((Test-Path -path "$DefaultFolder") -eq $False) {
    Write-Output "Création du dossier $DefaultFolder"
    New-Item "$DefaultFolder" -ItemType Directory
}
else {
write-output "Dossier déjà présent"
}

$Logs = "C:\GP\$Timestamp-rename.log"
Start-Transcript -path $Logs -Append

$serial = (get-wmiobject win32_bios).serialnumber
$HardwareType = (Get-WmiObject -Class Win32_ComputerSystem -Property PCSystemType).PCSystemType


if ($HardwareType -eq 2) {
$previouserrorpreferences = $ErrorActionPreference
$ErrorActionPreference = 'silentlycontinue'
Write-output "Renommage du poste en "LT-$serial"" 
Rename-Computer "LT-$serial"
$ErrorActionPreference = $previouserrorpreferences
[Environment]::Exit(3010)
}

if ($HardwareType -eq 1) {
$previouserrorpreferences = $ErrorActionPreference
$ErrorActionPreference = 'silentlycontinue'
Write-output "Renommage du poste en "DT-$serial" 
Rename-Computer "DT-$serial"
$ErrorActionPreference = $previouserrorpreferences
[Environment]::Exit(3010)
}

if ($HardwareType -eq 3) {
$previouserrorpreferences = $ErrorActionPreference
$ErrorActionPreference = 'silentlycontinue'
Write-output "Renommage du poste en "DT-$serial" 
Rename-Computer "DT-$serial"
$ErrorActionPreference = $previouserrorpreferences
[Environment]::Exit(3010)
}
exit 1