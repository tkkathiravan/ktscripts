#get Azure SQL server database details

$starttime = "{0:G}" -f (Get-Date)

Write-Host "starting script - $($startTime)"

$subs = Get-AzSubscription | Where-Object {$_.Name  -like "cc-*"}

foreach ($sub in $subs) {
    Set-AzContext -Subscription $sub | Out-Null
    $azSubName = $Sub.Name    

    Write-host "processing $($azSubName) subscription"

    $sqlserverslist = Get-AzSqlServer
    $resgroups = foreach ($sqlsrv in $sqlserverslist) {$sqlsrv.ResourceGroupName}
    $resgroups = $resgroups | Select-Object -Unique

    foreach ($rg in $resgroups) {
       
        Write-host "Currently Processing Resourcegroup  $($rg)" -ForegroundColor DarkGreen
        
        $SQLDatabases = Get-AzSqlServer -ResourceGroupName $rg | ForEach-Object {Get-AzSqlDatabase -ResourceGroupName $_.ResourceGroupName -ServerName $_.ServerName}
                  
            foreach ($sqldba in $SQLDatabases) {
                     
                write-host "Processing $(($sqldba).DatabaseName)" -ForegroundColor DarkCyan; 
                                       
                    $rgtags        = (Get-AzResourceGroup -Name $sqldba.ResourceGroupName).Tags
            
            $datacollections = [PSCustomObject][ordered]@{
                Subscription        = $azSubName
                SQLDBResGroupName   = $Sqldba.ResourceGroupName
                SQLDBName           = $sqldba.DatabaseName
                SQLServerName       = $Sqldba.ServerName
                SQLDBLocation       = $Sqldba.Location
                SQLDBEdition        = $sqldba.Edition
                SQLDBstatus         = $Sqldba.Status
                SQLDBRedundancy     = $Sqldba.ZoneRedundant
                RGTagSquad          = $rgtags.squad
                RGTagSquad1         = $rgtags.Squad
                RGTagProduct        = $rgtags.Product
        
            }
            $datacollections | Export-Csv -Path $env:OneDrive\a2b\script_out\$azSubName"-AZSQLDatabaseInfo".csv -Append -NoTypeInformation -NoClobber -Force
        }
    
}
        }

Write-Host "The script finished running"
$endtime = "{0:G}" -f (Get-Date)
Write-Host "Script finished at: $($endtime)"
Write-Host "Time elapsed: $(New-Timespan $startTime $endtime)" -ForegroundColor White -BackgroundColor DarkRed