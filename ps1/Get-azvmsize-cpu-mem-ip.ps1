function Get-AzureVMInfo {
    <#
    .SYNOPSIS 
    Gets basic information on one or more Azure VMs.    
    .DESCRIPTION
    Get CPU, memory and IP configuration with a simple cmdlet.
    Pipeline input accepts multiple vm objects.
    .EXAMPLE
    Get-AzureVMInfo -VMName "VM1" -ResourceGroupName "RG1"
    This command gets the CPU, memory and internal IP for VM "VM1".
    .EXAMPLE
    Get-AzureVM | Get-AzureVMInfo
    This command gets all VMs in the current subscription, then uses the output to surface all basic configuration on these VMs.
    .EXAMPLE
    Get-AzureVM | Get-AzureVMInfo | Sort "Internal IP"
    This command gets all VMs in the current subscription, then uses the output to surface all basic configuration on these VMs, sorted by Internal IP.
    .EXAMPLE
    ---$vms = Get-Content -Path 'C:\Users\kathiravan.thanappan\OneDrive - A2B Australia\a2b\Script_in\vmsin.txt'
    ---$vms | ForEach-Object {Get-AzVM -Name $_ |Get-AzureVMInfo | Export-Csv -Append -NoTypeInformation -NoClobber -Path 'C:\Users\kathiravan.thanappan\OneDrive - A2B Australia\a2b\Excels\az_vm_hyb_applied_CPU_CORE_INFO.csv'} 
    .LINK
    https://github.com/martensnico/Azure.Helperscripts
    #>
    [cmdletbinding(DefaultParameterSetName = 'Name')]
    Param(        
        [Parameter(Mandatory = $true, ParameterSetName = 'Name')]
        [string]$VMName,
        [Parameter(Mandatory = $true, ParameterSetName = 'Name')]
        [string]$ResourceGroupName,
        [Parameter(ValueFromPipeline, Mandatory = $true, ParameterSetName = 'Object')]
        $VM
    )
    process {
        if ($pscmdlet.ParameterSetName -eq "Name") {
            $vm = Get-AzVM -Name $VMName -ResourceGroupName $ResourceGroupName
        }
        
        $sizeinfo = get-azvmsize -VMName $vm.name -ResourceGroupName $vm.ResourceGroupName | Where-Object {$_.Name -eq $vm.hardwareprofile.vmsize}
        $privateip = (Get-AzNetworkInterface | where-Object {$_.Id -eq $vm.NetworkProfile.NetworkInterfaces[0].Id}).IpConfigurations[0].PrivateIPAddress
        $vminfo = [pscustomobject][ordered] @{
            Name          = $vm.Name
            CPU           = $sizeinfo.numberofcores
            "Memory (GB)" = $sizeinfo.MemoryInMB * 1mb / 1gb
            "Internal IP" = $privateip      
        }
        $vminfo
    }
}