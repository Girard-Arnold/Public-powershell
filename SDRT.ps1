$SDRT = import-csv -path c:\users\admin\desktop\scripts\parcs\sdrt.csv

foreach ($line in $SDRT)
{
    Set-ADComputer -identity "$($line.Ordinateur)" -Description "$($line.Site)"
}

Exit 