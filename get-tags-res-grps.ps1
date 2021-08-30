#get resource group tags

$subs = Get-AzSubscription | Where-Object {$_.Name -like "cc-*"}

foreach ($sub in $subs) {

    Set-AzContext -Subscription $sub | Out-Null

    Get-AzResourceGroup | Select-Object resourcegroupname,location,@{l="squad";e={$_.tags.squad}},@{l="service-register";e={$_.tags.'service-register'}},@{l="product";e={$_.tags.'product'}} | `
    Export-Csv -NoTypeInformation -Append $env:OneDrive\a2b\script_out\az-res-grp-tags.csv

}
