#Declaring all needed variables
$Date=((Get-Date).AddDays(-1)).ToString('yyyy-MM-dd')
$datapath = "E:\FichierMyReport"
$Sourcepath = "E:\Sources Appli"
$extractionCounter = 1
$fileCounter = 1



Set-Location "$datapath"

# Purging old files to prevent the renaming process from randomly failing.
Write-Output "Purging old items"
Get-ChildItem "*.xlsx" | Remove-Item
Get-ChildItem "*.csv" | Remove-Item


Get-ChildItem "GMA*$date.zip" | ForEach-Object {
    start-sleep 2
    Write-Output "Extracting file $extractionCounter\: $_.Name"
    Expand-Archive -Path $_.FullName -DestinationPath $datapath -Force
    $extractionCounter++
}
get-childitem "CRM*$Date.zip" | ForEach-Object {
    start-sleep 2
    Write-Output "Extracting file $extractionCounter\: $_.Name"
    Expand-Archive -Path $_.FullName -DestinationPath $datapath -Force
    $extractionCounter++
}
get-childitem "*GMA_plan*.xlsx" | Remove-Item
get-childitem "*CRM_plan*.xlsx" | Remove-Item
get-childitem "*PLAN*.csv" | Remove-Item
get-childitem "*(conflicted*.*" | Remove-Item


# Process each file containing 'CONF' in the name.
Get-ChildItem -Filter "*CONF*" | ForEach-Object {
    $originalFileName = $_.Name
    Write-Output "Processing file $fileCounter\: $originalFileName"

    # Extract the 20 first characters, and the last 4. That means csv files will be renamed with a double period at the end ie: ..csv. This is not an oversight, Myreport files are already based on this file format and catching it implies rewriting things in Myreport.
    $fileBaseName = $originalFileName.Substring(0, [Math]::Min(20, $originalFileName.Length))
    $fileExtension = $originalFileName.Substring($originalFileName.Length - 4)

    $newFileName = "${fileBaseName}.${fileExtension}"

    Write-Output "File Extension: $fileExtension"
    Write-Output "File Base Name: $fileBaseName"
    Write-Output "New File Name: $newFileName"

    # Check if the new filename already exists and delete it if so
    if (Test-Path -Path $newFileName) {
        Write-Output "Deleting existing file: $newFileName"
        Remove-Item -Path $newFileName
        Start-sleep 3
    } else {
        Write-Output "File $newFileName does not exist."
    }

    # Rename the original file to the new filename
    Write-Output "Renaming $originalFileName to $newFileName"
    Rename-Item -Path $originalFileName -NewName $newFileName

    Start-Sleep -Seconds 5
    $fileCounter++
}

Write-Output "Number of zip files processed : $extractioncounter"
Write-Output "Number of files: $fileCounter"
if ($extractionCounter -ne $fileCounter) {
Write-Output "Warning, the number of files does not match the number of zip files"
}

# Move zip files to "Old" folder, and remove ZIP files older than 4 days

If (Test-Path -path "$datapath\old") {
    Write-Output "Directory already exists"
} else {
    New-Item -itemtype "directory" -path "$datapath\old"
}

Get-ChildItem -Path $datapath "*.zip" | move-item -destination "$datapath\Old" -Force
Get-ChildItem -path "$datapath\Old\*.zip" | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-4) } | Remove-Item

If (Test-Path -path "$Sourcepath\old") {
    Write-Output "Directory already exists"
} else {
    New-Item -itemtype "directory" -path "$Sourcepath\old"
}
Get-ChildItem -Path "$Sourcepath\*.zip" | Move-Item -destination "$Sourcepath\old" -Force
Get-ChildItem -path "$Sourcepath\old\*.zip" | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-4) } | Remove-Item
Write-Output "Cleanup complete. If parts of the script failed, check the "old" folder."

exit 0