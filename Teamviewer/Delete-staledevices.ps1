[CmdletBinding()]
param(
    [Parameter(Mandatory=$True)] [int32]$StaleDays,
    [Parameter(Mandatory=$False)] [String] $Token = "",
    [Parameter(Mandatory=$False)] [String] $OutputFile = "DeletedDevices.txt"
)

$bearer = "Bearer",$token
$counter = 0

$header = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$header.Add("authorization", $bearer)

$devices = (Invoke-RestMethod -Uri "Https://webapi.teamviewer.com/api/v1/devices" -Method Get -Headers $header).devices

$Days = ((Get-Date).AddDays(-$staleDays))
$Days = Get-Date $Days -Format s

foreach($device in $devices)
{
    if ($device.online_state -eq "Offline")
    {
        $ID = $device.device_id
        $Lastseen = $device.last_seen

        if ($Lastseen -ne $null)
        {
            $LastSeen = ($device.last_seen).Split("T")[0]
            [datetime]$DateLastSeen = $LastSeen

            if ($DateLastSeen -le $Days)
            {
                $counter ++
                $output = "Deleted device:" + $device.alias + " "
                Write-Host $output -ForegroundColor Yellow
                $output | Out-File -Append -FilePath $OutputFile
                # Uncomment the line below to actually delete the device
                Invoke-RestMethod -Uri "Https://webapi.teamviewer.com/api/v1/devices/$ID" -Method Delete -Headers $header
            }
        }
    }
}
Write-Host "$counter results saved to: $OutputFile" -ForegroundColor Green
