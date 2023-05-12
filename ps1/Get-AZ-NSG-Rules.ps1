<#
.Synopsis
A script used to export all NSGs rules in all your Azure Subscriptions

.DESCRIPTION
A script used to get the list of all Network Security Groups (NSGs) in all your Azure Subscriptions.
Finally, it will export the report into a csv file in your Azure Cloud Shell storage.

.Notes
Created   : 04-January-2021
Updated   : 28-April-2021
Version   : 3.0
Author    : Charbel Nemnom
Twitter   : @CharbelNemnom
Blog      : https://charbelnemnom.com
Disclaimer: This script is provided "AS IS" with no warranties.
Modified BY : KT
Modification : Only use the prod/dev and test subscription and save to one drive script out. Also added network interface and vm name to the list
#>
$starttime = "{0:G}" -f (Get-Date)

Write-Host "starting script - $($startTime)"

$azSubs = Get-AzSubscription |Where-Object {$_.Name -like "CC-*"}

foreach ( $azSub in $azSubs ) {
    Set-AzContext -Subscription $azSub | Out-Null
    $azSubName = $azSub.Name

    $azNsgs = Get-AzNetworkSecurityGroup 
    
    foreach ( $azNsg in $azNsgs ) {
        # Export custom rules
        Get-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $azNsg | `
            Select-Object @{label = 'NSG Name'; expression = { $azNsg.Name } }, `
            @{label = 'NSG Location'; expression = { $azNsg.Location } }, `
            @{label = 'Rule Name'; expression = { $_.Name } }, `
            @{label = 'Source'; expression = { $_.SourceAddressPrefix } }, `
            @{label = 'Source Application Security Group'; expression = { $_.SourceApplicationSecurityGroups.id.Split('/')[-1] } },
            @{label = 'Source Port Range'; expression = { $_.SourcePortRange } }, Access, Priority, Direction, `
            @{label = 'Destination'; expression = { $_.DestinationAddressPrefix } }, `
            @{label = 'Destination Application Security Group'; expression = { $_.DestinationApplicationSecurityGroups.id.Split('/')[-1] } }, `
            @{label = 'Destination Port Range'; expression = { $_.DestinationPortRange } }, `
            @{label = 'Resource Group Name'; expression = { $azNsg.ResourceGroupName } }, `
            @{label = 'NetworkInterfaceName'; expression = { $azNsg.NetworkInterfaces.ID.Split('/')[8] } },
            @{label = 'VMNAME'; expression = { $nwintname=$azNsg.NetworkInterfaces.ID.Split('/')[8] ; if($nwintname) {( Get-AzNetworkInterface -Name $nwintname ).VirtualMachine.ID.split('/')[8] } ELSE {$null} } }  | `
            Export-Csv -Path "C:\Users\kathiravan.thanappan\OneDrive - A2B Australia\a2b\Script_out\$azSubName-nsg-Rules-$(Get-Date -f 'dd-MM-yyyy').csv" -NoTypeInformation -Append -force
        
        # Export default rules
        Get-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $azNsg -Defaultrules | `
            Select-Object @{label = 'NSG Name'; expression = { $azNsg.Name } }, `
            @{label = 'NSG Location'; expression = { $azNsg.Location } }, `
            @{label = 'Rule Name'; expression = { $_.Name } }, `
            @{label = 'Source'; expression = { $_.SourceAddressPrefix } }, `
            @{label = 'Source Port Range'; expression = { $_.SourcePortRange } }, Access, Priority, Direction, `
            @{label = 'Destination'; expression = { $_.DestinationAddressPrefix } }, `
            @{label = 'Destination Port Range'; expression = { $_.DestinationPortRange } }, `
            @{label = 'Resource Group Name'; expression = { $azNsg.ResourceGroupName } },
            @{label = 'NetworkInterfaceName'; expression = { $azNsg.NetworkInterfaces.ID.Split('/')[8] } },
            @{label = 'VMNAME'; expression = { $nwintname=$azNsg.NetworkInterfaces.ID.Split('/')[8] ; if($nwintname) {( Get-AzNetworkInterface -Name $nwintname ).VirtualMachine.ID.split('/')[8] } ELSE {$null} } }  | `
            Export-Csv -Path "C:\Users\kathiravan.thanappan\OneDrive - A2B Australia\a2b\Script_out\$azSubName-nsg-Rules-$(Get-Date -f 'dd-MM-yyyy').csv" -NoTypeInformation -Append -force
      
    }    
}
Write-Host "The script finished running"
$endtime = "{0:G}" -f (Get-Date)
Write-Host "Script finished at: $($endtime)"
Write-Host "Time elapsed: $(New-Timespan $startTime $endtime)" -ForegroundColor White