<#
    .SYNOPSIS
        This script enbales flow log in the network security group for specific locations, locations are retreived from a file.
    .Author
        KT
    .Version 2
        V2 - added line 9 and 33.    This will get teh storage account list as variable  and use that variable to get the corrcet sg account based on location.
#>
#variables
$subscriptions = Get-AzSubscription
$ResourgeGroupName = "A2BNSGFLOWRG"
$storageAccounts = Get-azStorageAccount -ResourceGroupName $ResourgeGroupName
$retentionperiod = 7

$locations = Get-Content -Path .\Script_in\sglocations.txt
        
        Foreach($sub in $subscriptions) 
            {

            Set-azContext -SubscriptionName $sub.Name

    Write-Host "Processing subscription $($sub.Name)" -BackgroundColor Green

        Foreach ($location in $locations) 
            {

    Write-Host "Processing location - $location" -BackgroundColor Yellow

    $NW = Get-azNetworkWatcher -Location $location -ErrorVariable nwerror

    $nsgs = Get-azNetworkSecurityGroup | Where-Object {$_.Location -eq $NW.location}

        Foreach($nsg in $nsgs)
            {
    #$storageaccount  = Get-azStorageAccount -ResourceGroupName $ResourgeGroupName | Where-Object {$_.Location -eq $nsg.Location}
    $storageaccount  = $storageAccounts | Where-Object {$_.Location -eq $nsg.Location}
    
    Write-Host "Configuring $($nsg.name) to flow to $storageaccount.name" -BackgroundColor Yellow

            Get-azNetworkWatcherFlowLogStatus -NetworkWatcher $NW -TargetResourceId $nsg.Id
            Set-azNetworkWatcherConfigFlowLog -NetworkWatcher $NW -TargetResourceId $nsg.Id -StorageAccountId $storageaccount.Id -EnableFlowLog $true `
             -EnableRetention $true -RetentionInDays $retentionperiod -FormatVersion 2

    Write-Host "NSG Diagnostics Log enabled for $($nsg.Name) " -BackgroundColor Green 
        
        } #end foreach nsg 

        } #end foreach location
} #end foreach subscription
