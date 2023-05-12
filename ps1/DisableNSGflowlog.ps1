<#
    .SYNOPSIS
        This script disables flow log in the network security group for specific locations, locations are retreived from a file.
    .Author
        KT
    .Version 1
        Disbale the network security groups to stop sending logs to storage account
        Storage account is a required parameter though is not ued in disabling
        as we set up nsg flow log, we have an additional storage account in australia east called "funcrv3q52hdyj5e4" created for the function deployment.
        so ignore that storage account when disabling.
#>
#variables
$subscriptions = Get-AzSubscription
$ResourgeGroupName = "A2BNSGFLOWRG"
$storageAccounts = Get-azStorageAccount -ResourceGroupName $ResourgeGroupName | Where-Object {$_.StorageAccountName -ne "funcrv3q52hdyj5e4"}
#$retentionperiod = 7

$locations = Get-Content -Path .\Script_in\sglocations.txt
        
        Foreach($sub in $subscriptions) 
            {

            Set-azContext -SubscriptionName $sub.Name

    Write-Host "Processing subscription $($sub.Name)" -BackgroundColor Magenta

        Foreach ($location in $locations) 
            {

    Write-Host "Processing location - $location" -BackgroundColor Blue

    $NW = Get-azNetworkWatcher -Location $location -ErrorVariable nwerror

    $nsgs = Get-azNetworkSecurityGroup | Where-Object {$_.Location -eq $NW.location}

        Foreach($nsg in $nsgs)
            {
    #$storageaccount  = Get-azStorageAccount -ResourceGroupName $ResourgeGroupName | Where-Object {$_.Location -eq $nsg.Location}
    $storageaccount  = $storageAccounts | Where-Object {$_.Location -eq $nsg.Location}
    
    Write-Host "Processing disabling the flow log in $($nsg.name)" -BackgroundColor Yellow

            #Get-azNetworkWatcherFlowLogStatus -NetworkWatcher $NW -TargetResourceId $nsg.Id | Select-Object TargetResourceId,enabled
            Set-azNetworkWatcherConfigFlowLog -NetworkWatcher $NW -TargetResourceId $nsg.Id -StorageAccountId $storageaccount.Id -EnableFlowLog $false `
              | Select-Object TargetResourceId,enabled

    Write-Host "NSG Diagnostics Log disabled for $($nsg.Name)" -BackgroundColor Green
        
        } #end foreach nsg 

        } #end foreach location
} #end foreach subscription
