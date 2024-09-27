[CmdletBinding()]
param(
    [Parameter(Mandatory=$False)] [String] $Token = "",
    [Parameter(Mandatory=$False)] [String] $OutputFile = "TeamviewerDevices.txt"
)

$bearer = "Bearer",$token
$counter = 0

$header = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$header.Add("authorization", $bearer)

$devices = (Invoke-RestMethod -Uri "Https://webapi.teamviewer.com/api/v1/devices" -Method Get -Headers $header).devices

foreach($device in $devices)
{
                $counter ++
                $output = $device.alias + ";" + $device.device_id
                Write-Host $output -ForegroundColor Yellow
                $output | Out-File -Append -FilePath $OutputFile

}
Write-Host "Results saved to: $OutputFile" -ForegroundColor Green
