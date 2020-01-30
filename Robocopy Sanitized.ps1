#Ce script m'a servit à créer rapidement un autre script après qu'un client n'ait eu un crypto. Bien évidemment, on peut comprendre rapidement que faire
#cela avec robocopy était en fait inutile...

$lecteurNewValue = "E";
$arrayValue = Import-Csv -Delimiter ";" -Path "$FileInput"

foreach($CurrentLine in $arrayValue){

$ConcatValue = 'Robocopy "' + $CurrentLine."Colonne1" + '" "' + $lecteurNewValue + $CurrentLine.'Colonne1'.Substring(1,$CurrentLine.'Colonne1'.length -1) + '" /NIR /SEC';
write-host $ConcatValue

Add-Content -Path "$FileOutput" -Value $ConcatValue

} 
