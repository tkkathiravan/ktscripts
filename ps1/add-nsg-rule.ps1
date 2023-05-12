
#get network security group
$nsg = Get-AzNetworkSecurityGroup -ResourceGroupName 'ops_test_kathir' -Name 'testopswinvm2-nsg'

#add a rule and  to the pipe network security 
$nsg | Add-AzNetworkSecurityRuleConfig -Name allowhttp -Description "Allow http port" -Access Allow `
    -Protocol tcp -Direction Inbound -Priority 320 -SourceAddressPrefix "*" -SourcePortRange * `
    -DestinationAddressPrefix * -DestinationPortRange 80

#update the network security group with the new rule.
$nsg | Set-AzNetworkSecurityGroup