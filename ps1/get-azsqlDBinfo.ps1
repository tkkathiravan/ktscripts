#get Azure SQL server database server details

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
        
        $sqlservers = Get-AzSqlServer -ResourceGroupName $rg

        foreach ($sqlserv in $sqlservers) 
        {
            Write-host "Gathering Information From  $(($sqlserv).ServerName)" -ForegroundColor DarkMagenta
            $sqlserverinfo = Get-AzSqlServer -ServerName $sqlserv.ServerName -ResourceGroupName $sqlserv.ResourceGroupName
            $sqlAADenabled = IF ($aad = Get-AzSqlServerActiveDirectoryAdministrator -ResourceGroupName $sqlserv.ResourceGroupName -ServerName $sqlserv.ServerName) {($aad).DisplayName}
            $sqlAPT        = Get-AzSqlServerAdvancedThreatProtectionSetting -ResourceGroupName $sqlserv.ResourceGroupName -ServerName $sqlserv.ServerName -WarningAction SilentlyContinue
            $SQLDBs        = Get-AzSqlDatabase -ResourceGroupName $sqlserv.ResourceGroupName -ServerName $sqlserv.ServerName | Where-Object {$_.DatabaseName -ne 'master'}
            
            foreach ($sqldba in $SQLDBs) {
                                       write-host "Processing $(($sqdba).DatabaseName)" -ForegroundColor DarkCyan; 
                                       Get-AzSqlDatabase -ResourceGroupName $sqlserv.ResourceGroupName -ServerName $sqlserv.ServerName

                                       $sqlDB = [ordered]@{
                                        SQLDBName           = $sqlDB.DatabaseName
                                        SQLDBEdition        = $sqlDB.Edition
                                        SQLDBstatus         = $Sqldb.Status
                                        SQLDBRedundancy     = $Sqldb.ZoneRedundant   
                                       }
                                                           }
            $rgtags        = (Get-AzResourceGroup -Name $sqlserv.ResourceGroupName).Tags
            
            $datacollections = [PSCustomObject][ordered]@{
                Subscription        = $azSubName
                ResourceGrpName     = $sqlserverinfo.ResourceGroupName
                SQLServerName       = $sqlserverinfo.ServerName
                SQLServerLOcation   = $sqlserverinfo.Location
                SQLFQDN             = $sqlserverinfo.FullyQualifiedDomainName
                SQLServerTLSVersion = $sqlserverinfo.MinimalTlsVersion
                SQLServerPubNwAccss = $sqlserverinfo.PublicNetworkAccess
                SQLAdminLogin       = $sqlserverinfo.SqlAdministratorLogin
                SQLSrvAADEnabledStatus= $sqlAADenabled
                SQLServerAPTStatus  = $sqlAPT.ThreatDetectionState
                SQLDBName           = $sqlDB.DatabaseName
                SQLDBEdition        = $sqlDB.Edition
                SQLDBstatus         = $Sqldb.Status
                SQLDBRedundancy     = $Sqldb.ZoneRedundant             
                RGTagSquad          = $rgtags.squad
                RGTagSquad1         = $rgtags.Squad
                RGTagProduct        = $rgtags.Product
        
            }
            $datacollections | Export-Csv -Path $env:OneDrive\a2b\script_out\$azSubName"-AZSQLserverplusDatabaseInfo".csv -Append -NoTypeInformation -NoClobber -Force
        }
    
}
        }

Write-Host "The script finished running"
$endtime = "{0:G}" -f (Get-Date)
Write-Host "Script finished at: $($endtime)"
Write-Host "Time elapsed: $(New-Timespan $startTime $endtime)" -ForegroundColor White -BackgroundColor DarkRed