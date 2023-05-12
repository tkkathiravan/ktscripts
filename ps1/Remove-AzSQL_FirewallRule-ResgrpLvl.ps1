
#get Azure SQL server firewall rules based on a resource group and remove

$starttime = "{0:G}" -f (Get-Date)

Write-Host "starting script - $($startTime)"

        #get the resource groupname
        $resourcegroup = Get-AzResourceGroup -Name "CC-PROD-DATAMARTS-PROJECTS"

        Write-host "Currently Processing Resourcegroup  $($resourcegroup.resourcegroupname)" -ForegroundColor DarkGreen

        #collect SQlservers in the resourcegroup
        $sqlservers = Get-AzSqlServer -ResourceGroupName $resourcegroup.resourcegroupname

        foreach ($sqlserver in $sqlservers)
            {
                Write-host "Currently Processing sqlserver:  $(($sqlserver).ServerName)" -ForegroundColor DarkGreen 
                
                $azsqlfwrule = Get-AzSqlServerfirewallrule -ResourceGroupName $resourcegroup.resourcegroupname -ServerName $sqlserver.ServerName | Where-Object {$_.startipaddress -ne "103.53.115.22" -and $_.firewallrulename -ne "AllowAllWindowsAzureIps"} 
                
                Write-host "No of Firewall Rules in $($sqlserver.ServerName) is $($azsqlfwrule.count)" -ForegroundColor DarkGreen

             foreach ($rule in $azsqlfwrule) 
             {
                     
                write-host "Processing $(($rule).FirewallRuleName)" -ForegroundColor DarkCyan; 

                    Remove-AzSqlServerFirewallRule -FirewallRuleName $rule.FirewallRuleName -ServerName $sqlserver.ServerName -ResourceGroupName $resourcegroup.resourcegroupname

        } #end of SQl server fw rule
    } #End of Sql server

Write-Host "The script finished running"
$endtime = "{0:G}" -f (Get-Date)
Write-Host "Script finished at: $($endtime)"
Write-Host "Time elapsed: $(New-Timespan $startTime $endtime)" -ForegroundColor White -BackgroundColor DarkRed