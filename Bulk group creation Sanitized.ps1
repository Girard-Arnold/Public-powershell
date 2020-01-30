$groupname = Import-Csv -Path "$home\desktop\ftp.csv"
$GroupOuPath = OU=Societe,OU=Groupes techniques,DC=domain,DC=TLD
foreach($group in $groupname){

    new-adgroup -name $group.name -groupscope global -groupcategory security -path "$GroupOuPath" -description "Donne acces au dossier $group sur le FTP"

}

ECHO "Fin de script"
