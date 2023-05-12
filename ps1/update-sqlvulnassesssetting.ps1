#get-azsqlserver and update the vulnerability assessment setting for this sql server with a storage account for each location
Author: KT
$seqlsrvr = Get-AzSqlServer

foreach ($server in $seqlsrvr) {

    If ($server.Location -eq 'australiaeast') {

        Write-Host "Procesing $($server.ServerName) from location $($server.Location)" -ForegroundColor Green

        Get-AzSqlServerVulnerabilityAssessmentSetting -ResourceGroupName $server.ResourceGroupName -ServerName $server.ServerName -WarningAction SilentlyContinue | Where-Object {$_.RecurringScansInterval -eq 'None'} | `

        Update-AzSqlServerVulnerabilityAssessmentSetting -ResourceGroupName $server.ResourceGroupName -ServerName $server.ServerName -RecurringScansInterval Weekly -NotificationEmail "soc@a2baustralia.com" -StorageAccountName sqlvulnsgeau -ScanResultsContainerName 'sqlprod-vulnerability-assessment' -WarningAction SilentlyContinue

    }

    elseif ($server.Location -eq 'australiasoutheast') 
    
    {
        
        Write-Host "Procesing $($server.ServerName) from location $($server.Location)" -ForegroundColor Green

        Get-AzSqlServerVulnerabilityAssessmentSetting -ResourceGroupName $server.ResourceGroupName -ServerName $server.ServerName -WarningAction SilentlyContinue | Where-Object {$_.RecurringScansInterval -eq 'None'} | `

        Update-AzSqlServerVulnerabilityAssessmentSetting -ResourceGroupName $server.ResourceGroupName -ServerName $server.ServerName -RecurringScansInterval Weekly -NotificationEmail "soc@a2baustralia.com" -StorageAccountName sqlvulnsgseau -ScanResultsContainerName 'sqlprod-vulnerability-assessment' -WarningAction SilentlyContinue
    } 
    
    Else

    {
        
     Write-Host "$($server.ServerName) is not in location australiaeast or australiasoutheast" -ForegroundColor Green
        
    }
   
}
