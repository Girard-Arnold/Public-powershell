Start-Process -FilePath cmd.exe -Verb Runas -ArgumentList ‘/k C:\pstools\PsExec.exe -i -s powershell.exe’ 

Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceClasses\{0ecef634-6ef0-472a-8085-5ad023ecbccd}\##?#SWD#PRINTENUM#*"| Remove-Item -Recurse -Force
Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{1ed2bbf9-11f0-4084-b21f-ad83a8e6dcdc}\*" -exclude "Properties" | Remove-Item -Recurse -Force

Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Enum\SWD\PRINTENUM\*"| Remove-Item -Recurse -Force
New-Item -Path “HKLM:\SYSTEM\CurrentControlSet\Enum\SWD\PRINTENUM\PrintQueues” -Name Properties –Force

Get-ItemProperty "HKLM:\SYSTEM\ControlSet001\Enum\SWD\PRINTENUM\*"| Remove-Item -Recurse -Force
New-Item -Path “HKLM:\SYSTEM\ControlSet001\Enum\SWD\PRINTENUM\PrintQueues” -Name Properties –Force

Get-ItemProperty "HKLM:\SYSTEM\ControlSet002\Enum\SWD\PRINTENUM\*"| Remove-Item -Recurse -Force
New-Item -Path “HKLM:\SYSTEM\ControlSet002\Enum\SWD\PRINTENUM\PrintQueues” -Name Properties –Force

get-childitem "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceContainers\" -ErrorAction SilentlyContinue -Recurse -exclude "{00000000-0000-0000-FFFF-FFFFFFFFFFFF}"|where-object {$_.property -like "SWD\PRINTENUM*"}| foreach-object {(get-item $_.PSParentPath).PSParentPath}|Remove-Item -recurse -Force

Get-childItem “HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\V4 Connections\*” | Remove-Item -Recurse -Force
Get-childItem "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\Providers\Client Side Rendering Print Provider\*" | Remove-Item -Recurse -Force

$RegPath = “HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\Providers\Client Side Rendering Print Provider”
New-ItemProperty -path $RegPath -name “RemovePrintersAtLogoff” -PropertyType DWORD -Value 0 -force | Out-Null