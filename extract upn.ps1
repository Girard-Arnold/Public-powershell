####Extraction des UPN dans une OU specifique et export vers un CSV
$filepath = "$home\desktop"
$filename = "resultupn.csv"
get-aduser -filter * -searchbase "OU=users,OU=societe,DC=societe,DC=int" -properties * | select-object name, userprincipalname | export-csv -delimiter ";" -path "$path\$filename"
ECHO "Resultat disponible dans "$filepath\$filename""
ECHO "Fin de script"
END
