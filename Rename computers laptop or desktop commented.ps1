<# According to https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-computersystem 
1 should be Desktop, 2 should be Laptop, 3 is technically Workstation#>
 
# Formatted code is arguably easier to read. This has been passed through Format Document in VS Code
$Timestamp = get-date -f yyyymmmmHHmm
 
$DefaultFolder = "C:\logs"
# Quotes around the $DefaultFolder variable are not required.
# Consider implicit boolean comparisons:
#     if (-not (Test-Path -Path $DefaultFolder))
if ((Test-Path -path "$DefaultFolder") -eq $False) {
    # Write-Output is standard-out, are you sure you want to write informational messages like this
    # to standard-out? This will pollute the output of any caller.
    #
    # Consider Write-Information or Write-Verbose.
    Write-Output "Création du dossier $DefaultFolder"
    # The created folder will be returned as output. Consider using one of the methods of
    # suppressing this:
    #     New-Item ... | Out-Null
    #     $null = New-Item ...
    #     New-Item ... > $null
    #     [void](New-Item ...)
    #
    New-Item "$DefaultFolder" -ItemType Directory
}
else {
    write-output "Dossier déjà présent"
}
 
# What happens if the attempt to create the log folder failed?
# Consider how you might exit the script with an error if that does happen.
$Logs = "$DefaultFolder\$Timestamp-rename.log"
Start-Transcript -path $Logs -Append
 
# Get-WmiObject was deprecated in PowerShell 3. Consider using Get-CimInstance in it's place.
$serial = (get-wmiobject win32_bios).serialnumber
$HardwareType = (Get-WmiObject -Class Win32_ComputerSystem -Property PCSystemType).PCSystemType
 
# All of these statements repeat the same code. Consider:
#     $prefix = switch ($HardwareType) {
#         1 { 'DT' }
#         2 { 'LT' }
#         3 { 'DT' }
#     }
#     Rename-Computer "$prefix-$serial"
if ($HardwareType -eq 2) {
    # ErrorActionPreference is a scoped variable, you do not need to do this memorization.
    # But even so, if you want to suppress errors from Rename-Computer, use:
    #     Rename-Computer ... -ErrorAction SilentlyContinue
    # I strongly recommend you do *not* suppress this. Silent failures are not nice to debug.
    # The error should be in the log file (the transcript).
<#$prefix = switch ($HardwareType) {
    1 { 'DT' }
    2 { 'LT' }
    3 { 'DT' }
    default { Write-Error "No prefix defined for hardware type $_"; exit 1 }
}
Rename-Computer "$prefix-$serial"#>

<#other positibility 
if ($HardwareType -in 1, 3) {
    $prefix = 'DT'
} elseif ($HardwareType -eq 2) {
    $prefix = 'LT'
} else {
    Write-Error "No prefix defined for hardware type $HardwareType"
    exit 1 
}
Rename-Computer "$prefix-$serial"#>

<# Another one
$prefix = switch ($HardwareType) {
    1 { 'DT' }
    2 { 'LT' }
    3 { 'DT' }
    default { Write-Error "No prefix defined for hardware type $_"; exit 1 }
}
Rename-Computer "$prefix-$serial"#>
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
    Write-output "Renommage du poste en "DT-$serial"" 
    Rename-Computer "DT-$serial"
    $ErrorActionPreference = $previouserrorpreferences
    [Environment]::Exit(3010)
}
 
if ($HardwareType -eq 3) {
    $previouserrorpreferences = $ErrorActionPreference
    $ErrorActionPreference = 'silentlycontinue'
    Write-output "Renommage du poste en "DT-$serial"" 
    Rename-Computer "DT-$serial"
    $ErrorActionPreference = $previouserrorpreferences
    [Environment]::Exit(3010)
}
# Non-zero exit codes often indicate a failure. Are you sure you want to exit like this?

    exit 1
