#get Azure SQL server database firewall details

$starttime = "{0:G}" -f (Get-Date)

Write-Host "starting script - $($startTime)"

$subs = Get-AzSubscription | Where-Object {$_.Name  -like "cc-*"}

foreach ($sub in $subs) 
{
    Set-AzContext -Subscription $sub | Out-Null
    $azSubName = $Sub.Name    

    Write-host "processing $($azSubName) subscription"

    $sqlserverslist = Get-AzSqlServer
    $resgroups = foreach ($sqlsrv in $sqlserverslist) {$sqlsrv.ResourceGroupName}
    $resgroups = $resgroups | Select-Object -Unique

    foreach ($rg in $resgroups) 
    {
       
        Write-host "Currently Processing Resourcegroup  $($rg)" -ForegroundColor DarkGreen

        $sqlservers = Get-AzSqlServer -ResourceGroupName $rg

        foreach ($sqlserver in $sqlservers)
            {
                Write-host "Currently Processing sqlserver:  $(($sqlserver).ServerName)" -ForegroundColor DarkGreen 
                
                $azsqlfwrule = Get-AzSqlServerfirewallrule -ResourceGroupName $rg -ServerName $sqlserver.ServerName
                  
             foreach ($rule in $azsqlfwrule) 
             {
                     
                write-host "Processing $(($rule).FirewallRuleName)" -ForegroundColor DarkCyan; 
                                       
                    $rgtags        = (Get-AzResourceGroup -Name $sqlserver.ResourceGroupName).Tags
            
            $datacollections = [PSCustomObject][ordered]@{
                Subscription        = $azSubName
                SQLServerName       = $rule.ServerName
                SQLserverResGrpName = $rule.ResourceGroupName
                SQLserverLocation   = $Sqlserver.Location
                FirewallRuleName    = $rule.FirewallruleName
                StartIPAddress      = $rule.StartIpAddress
                EndIPAddress      = $rule.EndIpAddress
                RGTagSquad          = $rgtags.squad
                RGTagSquad1         = $rgtags.Squad
                RGTagProduct        = $rgtags.Product
        
            }
            $datacollections | Export-Csv -Path $env:OneDrive\a2b\script_out\$azSubName"-AZSQLserverFWRules".csv -Append -NoTypeInformation -NoClobber
            }
    
        }
    }
}

Write-Host "The script finished running"
$endtime = "{0:G}" -f (Get-Date)
Write-Host "Script finished at: $($endtime)"
Write-Host "Time elapsed: $(New-Timespan $startTime $endtime)" -ForegroundColor White -BackgroundColor DarkRed