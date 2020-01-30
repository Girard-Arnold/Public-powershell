$SDRT = import-csv -path c:\users\admin\desktop\scripts\parcs\sdrt.csv
#This scripts replaces the description of computers in a .csv
#Requires a csv with 2 columns : Ordinateur and Site. Ordinateur contains the server name, Site contains the description.
#Change as needed.
foreach ($line in $SDRT)
{
    Set-ADComputer -identity "$($line.Ordinateur)" -Description "$($line.Site)"
}

Exit 
