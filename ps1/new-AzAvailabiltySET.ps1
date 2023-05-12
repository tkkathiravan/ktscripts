

#create an availability set

New-AzAvailabilitySet `
   -Location "EastUS" `
   -Name "myAvailabilitySet" `
   -ResourceGroupName "myResourceGroupAvailability" `
   -Sku aligned `
   -PlatformFaultDomainCount 2 `
   -PlatformUpdateDomainCount 2


#create multiple vms within an availability set

 for ($i=1; $i -le 2; $i++) {new-azvm -ResourceGroupName 'ops_test_kathir' `
-name avsetvm$i `
-location 'australia east' `
-VirtualNetworkName 'ops_test_kathir_vnet' `
-Subnetname 'ops_test_kathir_vnet_subnet' `
-SecurityGroupName 'testopswinvm2-nsg' `
-AvailabilitySetName 'ops_test_kathir_AvailSet' `
-Credential $cres}