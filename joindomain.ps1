function Show-Menu
{
    param (
        [string]$Title = 'Ajout de poste dans le domaine'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "1: Choissez "1" pour un pc fixe"
    Write-Host "2: Choissez "2" pour un pc portable"
    Write-Host "Q: Faites "Q" pour quitter"
}

Show-Menu –Title 'Ajout d''un poste dans le domaine'
 $selection = Read-Host "Veuillez faire un choix"
 switch ($selection)
 {
     '1' {
            ECHO write-host "Veuillez entrer vos identifiants"
            Add-Computer -DomainName "forwardis.int" -OUPath "OU=DESKTOPS,OU=Computers,OU=Forwardis,DC=forwardis,DC=int"
     } '2' {
            Add-Computer -DomainName "forwardis.int" -OUPath "OU=LAPTOPS,OU=Computers,OU=Forwardis,DC=forwardis,DC=int"
     }'q' {
         return
     }
 }
