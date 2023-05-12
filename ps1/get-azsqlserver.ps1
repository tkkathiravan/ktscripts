$sqlservers = Get-AzSqlServer |Where-Object {$_.location -eq 'australiaeast'}

foreach ($srvr in $sqlservers) {

        Get-AzSqlDatabase -ServerName $srvr.servername -ResourceGroupName $srvr.resourcegroupname | select ResourceGroupName,ServerName,DatabaseName,Location,Capacity,SkuName | Export-Csv -Path 'C:\Users\kathiravan.thanappan\OneDrive - A2B Australia\A2B\Excels\AzureSQL_List_PROD.csv' -NoClobber -NoTypeInformation -Append
    
    
     }