#using custom script extensionm to install iis and adda  file to wwwroot.

Set-AzVMExtension -ResourceGroupName 'ops_test_kathir' `
	-VMName testwinvm2 `
	-ExtensionName iis `
	-Publisher 'Microsoft.compute' `
	-Location 'australia east' `
	-ExtensionType customscriptextension `
	-TypeHandlerVersion 1.8 `
	-SettingString '{"commandtoexecute":"powershell Add-windowsfeature web-server; powershell add-content -path \"c:\\inetpub\\wwwroot\\default.htm\" -value $($env:computername)"}'

#note: settingsstring syntax '{"CommandToExecute": "the command we want to run in the shell"}'