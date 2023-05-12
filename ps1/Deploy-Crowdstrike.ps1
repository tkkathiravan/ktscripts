
Write-Host Enter Windows if vm os is windows, Enter Linux if OS is Linux
$os = Read-Host -Prompt "Enter os Type:"
If ($os -eq "Windows") {
$resourcegroupname = Read-Host -Prompt "Enter ResourceGroupName:"
$vmname = Read-Host -Prompt "Enter vmname:"
Set-AzVMCustomScriptExtension -ResourceGroupName $resourcegroupname `
-VMName $vmname -Name "CSFALCONINSTALLSCRIPT" `
-FileUri "https://crowdstrikedeploysg.blob.core.windows.net/crowdstrike-install-script/falcon_windows_install.ps1" `
-Run "falcon_windows_install.ps1 -FalconClientId ce39e52b6c284871b0ddf0ef08dc85be -FalconClientSecret fAEh8cbJmQ3xUa9l5PzCYeq172uDZ6V4TRk0LMXI" -Location "australiasoutheast"
}
Else {Write-host "Follow the Linux script for CS installation for Linux "}