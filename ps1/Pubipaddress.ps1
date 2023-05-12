###get all public ip address details with tags


$starttime = "{0:G}" -f (Get-Date)

Write-Host "starting script - $($startTime)"

$subs = Get-AzSubscription | Where-Object {$_.Name  -like "cc-*"}

foreach ($sub in $subs) 
{
    Set-AzContext -Subscription $sub | Out-Null
    $azSubName = $Sub.Name    

    Write-host "processing $($azSubName) subscription"

    Get-AzPublicIpAddress | Select-Object Name,IpAddress,ResourceGroupName,PublicIpAllocationMethod,PublicIpAddressVersion, `
    @{Label='Sku';e={$_.sku.Name}},`
    @{L='AssociatedWith';e= { $_.IpConfiguration.Id.split('/')[7] + " : " + $_.IpConfiguration.Id.split('/')[8] } }, `
    @{Label='DNSSettings';e={$_.DnsSettings.fqdn}}, `
    @{L="TAG";e={$_.tag | ForEach-Object {$_.keys.split("'")[0] + ":" + $_.values.split("'")[0] } }}, `
    @{L="TAG1";e={$_.tag | ForEach-Object {$_.keys.split("'")[1] + ":" + $_.values.split("'")[1] } }} `
    | Export-Csv -NoClobber -Append -Path $env:OneDrive\a2b\script_out\$azSubName"-A2BPublicipaddress".csv

}

