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
    if ($device.online_state -eq "Offline")
    {
        $ID = $device.device_id
        $Lastseen = $device.last_seen

        if ($Lastseen -eq $null)
            {
                $counter ++
                $output = $device.alias + ";" + $devicelast_seen + ";" + $device.device_id
                Write-Host $output -ForegroundColor Yellow
                $output | Out-File -Append -FilePath $OutputFile
            }
    }
}
Write-Host "$counter results saved to: $OutputFile" -ForegroundColor Green