#create a new vm scal set with a load balancer and public ip address.

New-AzVmss `
-ResourceGroupName "ops_test_kathir" `
-Location "australia east" `
-VMScaleSetName "opstestkathirScaleSet" `
-VirtualNetworkName "ops_test_kathir_Vnet" `
-SubnetName "ops_test_kathir_Subnet" `
-PublicIpAddressName "opstest_kathir_PublicIPAddress" `
-LoadBalancerName "opstest_kathir_LoadBalancer" `
-UpgradePolicyMode "Automatic"
