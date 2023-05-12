
#get Azure SQL server database details


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
                Write-host "Currently Processing sqlserver:  $(($sqlserver).ServerName)" -ForegroundColor Yellow
                
                $azsqlfwrule = Get-AzSqlServerfirewallrule -ResourceGroupName $rg -ServerName $sqlserver.ServerName | Where-Object {$_.startipaddress -ne "103.53.115.22" -and $_.firewallrulename -ne "AllowAllWindowsAzureIps"}
                  
             foreach ($rule in $azsqlfwrule) 
             {
                     
                write-host "Processing Removal of $(($rule).FirewallRuleName)" under $(($sqlserver).ServerName) -ForegroundColor DarkCyan; 

                Remove-AzSqlServerFirewallRule -FirewallRuleName $rule.FirewallRuleName -ServerName $sqlserver.ServerName -ResourceGroupName $resgrp -WhatIf

        }
    }
}
}

Write-Host "The script finished running"
$endtime = "{0:G}" -f (Get-Date)
Write-Host "Script finished at: $($endtime)"
Write-Host "Time elapsed: $(New-Timespan $startTime $endtime)" -ForegroundColor White -BackgroundColor DarkRed