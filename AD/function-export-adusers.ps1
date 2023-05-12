# synopsis - This function export the users by the OU name specified

#Ex: Export-INTADusers -OUNAME "sydney" - in this example sydney is the OU and it exports it from that ou.


Function Export-INTADusers{
    Param ( 
        [string]$OUNAME)

$OUlocation = "OU=" + $OUNAME + ",DC=int,DC=net"
$Filepath = "C:\Users\Administrator\Documents\" + $OUNAME + ".csv"

Get-ADUser -Filter * -Properties * -SearchBase $OUlocation | 
select Name, samaccountname,userprincipalname,enabled |
Export-Csv -NoTypeInformation -NoClobber -Path $Filepath

}

Export-INTADusers -OUNAME sydney