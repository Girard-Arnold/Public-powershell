####Extraction des UPN dans une OU specifique et export vers un CSV
$filepath = "$home\desktop"
$filename = "resultupn.csv"
# Le but notamment est de comparer le mail et l'UPN notamment dans le cadre d'une migration vers O365.
get-aduser -filter * -searchbase "OU=users,OU=societe,DC=societe,DC=int" -properties * | select-object name, userprincipalname | export-csv -delimiter ";" -path "$path\$filename" -notypeinformation
ECHO "Resultat disponible dans "$filepath\$filename""
ECHO "Fin de script"
END
