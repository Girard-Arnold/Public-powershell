$groupname = Import-Csv -Path "$home\desktop\ftp.csv"
foreach($group in $groupname){

    new-adgroup -name $group.name -groupscope global -groupcategory security -path "GroupOUPath" -description "Donne acces au dossier $group sur le FTP"

}