# Fonction obtenue de http://www.theservergeeks.com/how-to-powershell-password-generator/
Function Generate-Password {

    $Alphabets = 'a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z'
    $numbers = 0..9
    $specialCharacters = '!,@,#,$,%,&,*,(,),?,\,/,_,-,=,+'
    $array = @()
    $array += $Alphabets.Split(',') | Get-Random -Count 5
    $array[0] = $array[0].ToUpper()
    $array[-1] = $array[-1].ToUpper()
    $array += $numbers | Get-Random -Count 4
    $array += $specialCharacters.Split(',') | Get-Random -Count 3
    ($array | Get-Random -Count $array.Count) -join ""
}

Import-Module ActiveDirectory
$Resultpath = "$home\desktop\Results"
$CurrentDate = get-date -f yyyy-MM-dd
$CurrentTime = get-date -f hhmmss
$ExpiredList = Import-Csv -delimiter "," -Path "$home\desktop\users.csv"
foreach($account in $ExpiredList){
    $password = Generate-Password
    Add-content "$ResultPath\$Filepath" "Login : $env:userdomain\$($account.samaccountname)"
    Add-Content "$Resultpath\$Filepath" "Password : $($password)`r`n"
    Set-ADAccountPassword -identity $account.samaccountname -newpassword (ConvertTo-secureString -AsPlainText $password -force) -reset
    Set-ADAccountExpiration -identity $account.samaccountname -timespan 180.0:0
}
Send-MailMessage -From 'Reset Accounts <Accounts.reset@engie.solar>' -To 'Support Client <support.client@groupe-cyllene.com>' -Subject 'Prolongation/creation de compte Engie Solar' -Body "Comptes Engie Solar du $CurrentDate" -Attachments "$filepath" -SmtpServer 'SDSV152-VM.solairedirect.lan'

ECHO "Fin de script"

pause

