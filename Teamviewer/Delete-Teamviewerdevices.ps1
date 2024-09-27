[CmdletBinding()]
param(
    [Parameter(Mandatory=$False)] [String] $Token = "",
    [Parameter(Mandatory=$False)] [String] $DevicesToDeleteFile = "Teamviewerdevicestodelete.txt"
)

# Read the list of device IDs from the file
$DevicesToDelete = Get-Content -Path $DevicesToDeleteFile | ForEach-Object { $_.Trim() }

$bearer = "Bearer",$token
$counter = 0

$header = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$header.Add("authorization", $bearer)

foreach($ID in $DevicesToDelete)
{
    Write-Host "Deleting device with ID: $ID" -ForegroundColor Yellow
    # Uncomment the line below to actually delete the device
    Invoke-RestMethod -Uri "Https://webapi.teamviewer.com/api/v1/devices/$ID" -Method Delete -Headers $header
    $counter++
}

Write-Host "Total devices deleted: $counter" -ForegroundColor Green
