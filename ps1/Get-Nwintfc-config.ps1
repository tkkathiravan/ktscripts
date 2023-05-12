#get all network interface in a subscription and using the ipconfiguration proprty, collect data required.

$subs = Get-AzSubscription

    foreach ($sub in $subs) {

    Select-AzSubscription -Subscription $sub

$nwintfce = Get-AzNetworkInterface

$dataobjs = @()

foreach ($nwint in $nwintfce) {

            IF ($nwint.VirtualMachine -ne $null) {

            Write-Host $nwint.Name


        $pubipNICname =  $nwint.IpConfigurations.publicipaddress.id.split('/') | Select-Object -Last 1 -ErrorAction SilentlyContinue

        $publicipaddr = Get-AzPublicIpAddress -Name $pubipNICname
    
        $ipprops = [ordered]@{
            
            VMNAME              = $nwint.VirtualMachine.Id.split('/') |Select-Object -Last 1
            RESGRP              = $nwint.ResourceGroupName
            LOCATION            = $nwint.Location
            privateip           = $nwint.ipconfigurations.privateipaddress
            privateipallocmthd  = $nwint.ipconfigurations.PrivateIpAllocationMethod
            PUBLICIPADDRESS     = $publicipaddr.IpAddress
            PUBLIIPNAME         = $publicipaddr.Name
            PUBLIIPSku          = $publicipaddr.Sku.Name
            PUBIPALLOCMETHOD    = $publicipaddr.PublicIpAllocationMethod
            PUBIPVERSION        = $publicipaddr.PublicIpAddressVersion
            NSG                 = $nwint.NetworkSecurityGroup.Id.Split('/') | Select-Object -Last 1
            NetworkinterafceName= $nwint.Name
            subnet              = $nwint.IpConfigurations.subnet.id.split('/') | Select-Object -Last 1
            }

            $dataobj = New-Object -TypeName psobject -Property $ipprops
            $dataobjs+=$dataobj
            
         }
         }
         
         $dataobjs | Select-Object vmname,resgrp,location,privateip,privateipallocmthd,publicipaddress,pubipallocmethod,PUBLIIPNAME,PUBLIIPSku,pubipversion,NetworkinterafceName,NSG,subnet, -Unique | Export-Csv -NoTypeInformation -NoClobber -Path c:\temp\allvms-vm-ip-nsgv2.csv -Append
         }

    Write-Host $dataobjs

    