
#set the vm running windows os in australia to have hybrid license enabled. This is on the Prod subscription.

select-azsubscription -subscriptionid "c17d3e23-8d04-4afc-b96b-b98f3b49eb82" 

$vmswithouthybridlic = Get-azvm | where {$_.storageprofile.osdisk.ostype -eq "windows" -and $_.licensetype -ne "Windows_Server" -and $_.Location -like "*australia*"}

foreach ($vm in $vmswithouthybridlic) {

$name = $vm.name

$rg = $vm.Resourcegroupname

write-host "Enabling Azure Hybrid on vm:" $name

$vm.licenseType = "Windows_Server"

Update-AzVM -resourcegroupname $rg -vm $vm
}


$afterchange = Get-azvm | where {$_.storageprofile.osdisk.ostype -eq "windows" -and $_.licensetype -eq "Windows_server" -and $_.Location -like "*australia*"} | select name, resourcegroupname, @{L="OS"; e = {$_.storageprofile.osdisk.ostype}}, @{L="License"; e = {$_.licensetype}}, @{L="Location"; e = {$_.location}}

return $afterchange.count


$afterchange | Export-Csv -NoTypeInformation -NoClobber -Path 'C:\Users\kathiravan.thanappan\OneDrive - A2B Australia\A2B\Excels\az_vm_hyb_applied.csv'