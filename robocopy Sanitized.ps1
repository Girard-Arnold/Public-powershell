$lecteurNewValue = "E";
$arrayValue = Import-Csv -Delimiter ";" -Path "$FileInput"

foreach($CurrentLine in $arrayValue){

$ConcatValue = 'Robocop "' + $CurrentLine."Colonne1" + '" "' + $lecteurNewValue + $CurrentLine.'Colonne1'.Substring(1,$CurrentLine.'Colonne1'.length -1) + '" /NIR /SEC';
write-host $ConcatValue

Add-Content -Path "$FileOutput" -Value $ConcatValue

} 
