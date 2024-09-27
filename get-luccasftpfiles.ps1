###
#Declaring used variables for easy editing
#Assemblypath points to the correct dll for the .net framework.
#xmlpath is for the configuration file containing the credentials.
#targetfolder is the destination folder for the Download
###

$assemblyPath = "E:\Sources Appli\Script\WinSCP\WinSCPnet.dll"
$xmlpath = "E:\Sources Appli\Script\WinSCP\config.xml"
$targetfolder = "E:\Ftp LUCCA\"
# Load the correct WinSCP .NET assembly for PowerShell
# This can be downloaded from WinSCP's website. Very important for a powershell script as per the documentation.
$assemblyPath = "E:\Sources Appli\Script\WinSCP\WinSCPnet.dll"

[Reflection.Assembly]::LoadFrom($assemblyPath)

# Load XML file with credentials
$config = [xml](Get-Content "$xmlpath")

# Extract the username and password. The password is in the path above, is encrypted and can only be decrypted from the account reportone.
$username = $config.Configuration.UserName
$encryptedPassword = $config.Configuration.Password

# Decrypt the password
$securePassword = $encryptedPassword | ConvertTo-SecureString
$plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword))

# Set up WinSCP session options for SFTP.
$sessionOptions = New-Object WinSCP.SessionOptions
$sessionOptions.Protocol = [WinSCP.Protocol]::Sftp
$sessionOptions.HostName = "ftp.eu1.luccasoftware.com"
$sessionOptions.UserName = $username
$sessionOptions.Password = $plainPassword
$sessionOptions.SshHostKeyFingerprint = "ssh-ed25519 255 Ddex0NLLm4ifi7pZK8h3gkN1EVcEq3LuYZTwVottyno" # Replace 'sshkey' with the actual SSH key fingerprint

# Initialize the WinSCP session
$session = New-Object WinSCP.Session

try {
    # Connect to the SFTP server
    $session.Open($sessionOptions)

    # Define the remote and local paths
    $remotePath = "/KPI-Finance/*"
    $localPath = "$targetfolder"

    # Download files
    $transferOptions = New-Object WinSCP.TransferOptions
    $transferOptions.TransferMode = [WinSCP.TransferMode]::Binary

    $transferResult = $session.GetFiles($remotePath, $localPath, $False, $transferOptions)

    # Throw on any error
    $transferResult.Check()

    Write-Host "Download successful!"

} catch {
    Write-Host "Error: $($_.Exception.Message)"
} finally {
    # Dispose of the session
    $session.Dispose()
}
