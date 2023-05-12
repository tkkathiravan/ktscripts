#get-azsqlserver and update the vulnerability assessment setting for this sql server with a storage account for each location
$seqlsrvr = Get-AzSqlServer

foreach ($server in $seqlsrvr) {

    If ($server.Location -eq 'australiaeast') {

        Write-Host "Procesing $($server.ServerName) from location $($server.Location)" -ForegroundColor Green

        IF (Get-AzSqlServerAudit -ResourceGroupName $server.ResourceGroupName -ServerName $server.ServerName -WarningAction SilentlyContinue | Where-Object {$_.BlobStorageTargetState -eq 'Disabled' -and $_.LogAnalyticsTargetState -ne 'Enabled'} )

        {
            Set-AzSqlServerAudit -ResourceGroupName $server.ResourceGroupName -ServerName $server.ServerName -BlobStorageTargetState Enabled `
                -StorageAccountResourceId "/subscriptions/c17d3e23-8d04-4afc-b96b-b98f3b49eb82/resourceGroups/A2B-SecOps-Prod-Subs-EAU/providers/Microsoft.Storage/storageAccounts/sqlvulnsgea" `
                -StorageKeyType Primary -WarningAction SilentlyContinue -WhatIf
        } #exit IF sqlserveraudit didnt match required paramters
}# IF Location

    elseif ($server.Location -eq 'australiasoutheast') 
    
    {
        
        Write-Host "Procesing $($server.ServerName) from location $($server.Location)" -ForegroundColor Green

        IF (Get-AzSqlServerAudit -ResourceGroupName $server.ResourceGroupName -ServerName $server.ServerName -WarningAction SilentlyContinue | Where-Object {$_.BlobStorageTargetState -eq 'Disabled' -and $_.LogAnalyticsTargetState -ne 'Enabled'} )

        {
            Set-AzSqlServerAudit -ResourceGroupName $server.ResourceGroupName -ServerName $server.ServerName -BlobStorageTargetState Enabled `
                -StorageAccountResourceId "/subscriptions/c17d3e23-8d04-4afc-b96b-b98f3b49eb82/resourceGroups/A2B-SecOps-Prod-Subs-SEAU/providers/Microsoft.Storage/storageAccounts/sqlvulnsgseau" `
                -StorageKeyType Primary -WarningAction SilentlyContinue -WhatIf
        } #exitIF sqlserveraudit didnt match required paramters
        
    } #elseif Location
    
    Else

    {
        
     Write-Host "$($server.ServerName) is not in location australiaeast or australiasoutheast" -ForegroundColor Green
        
    }
   
} #end


    #SEAU - /subscriptions/c17d3e23-8d04-4afc-b96b-b98f3b49eb82/resourceGroups/A2B-SecOps-Prod-Subs-SEAU/providers/Microsoft.Storage/storageAccounts/sqlvulnsgseau
    #EAU  - /subscriptions/c17d3e23-8d04-4afc-b96b-b98f3b49eb82/resourceGroups/A2B-SecOps-Prod-Subs-EAU/providers/Microsoft.Storage/storageAccounts/sqlvulnsgea



    