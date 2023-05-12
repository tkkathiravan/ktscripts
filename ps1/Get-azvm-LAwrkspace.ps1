# Get vms in a subscription, get its extension where its Windows or linux monitoring agent or security center vuln assessment extension and collect it Log Analytics workspace id and its provisioning state

$starttime = "{0:G}" -f (Get-Date)

Write-Host "starting script - $($startTime)"

$subs = Get-AzSubscription | Where-Object {$_.Name  -like "cc-*"}

foreach ($sub in $subs) 
{
    Set-AzContext -Subscription $sub | Out-Null
    $azSubName = $Sub.Name    

    Write-host "processing $($azSubName) subscription"
   
    get-azvm | ForEach-Object { 
        
        Write-Host "processing $($_.Name) in $($_.ResourceGroupName)" -ForegroundColor Yellow; 
    
        Get-AzVMExtension -ResourceGroupName $_.resourcegroupname -VMName $_.name | Where-Object {$_.ExtensionType -eq "MicrosoftMonitoringAgent" -or $_.ExtensionType -eq "OmsAgentForLinux" -or $_.ExtensionType -eq "WindowsAgent.AzureSecurityCenter"}} | `
            Select-Object ResourceGroupName,VMName,Location,ExtensionType,ProvisioningState, `
                @{L="LAWSID";e={($_.publicsettings | ConvertFrom-Json).workspaceId}}, `
                @{L="Lawrkspacename";e={$allwrkspceid = Get-AzOperationalInsightsWorkspace; $vmxnsion = ($_.publicsettings | ConvertFrom-Json).workspaceId;  foreach ($a in $allwrkspceid) {if ($a.customerid.Guid -match $vmxnsion) {$a.Name} } }} |`
       
        Export-Csv -NoTypeInformation -Append -Path $env:OneDrive\a2b\script_out\$azSubName"-LAWSPC-VM-ProvisionStatus".csv

} 

Write-Host "The script finished running"
$endtime = "{0:G}" -f (Get-Date)
Write-Host "Script finished at: $($endtime)"
Write-Host "Time elapsed: $(New-Timespan $startTime $endtime)" -ForegroundColor White -BackgroundColor DarkRed