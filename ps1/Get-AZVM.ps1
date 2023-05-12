$starttime = "{0:G}" -f (Get-Date)

Write-Host "starting script - $($startTime)"

$subs = Get-AzSubscription -TenantId "0e38730c-f9b8-4d07-9f70-46b518bde035" | Where-Object {$_.state -eq "enabled"}

foreach ($sub in $subs) {
    Set-AzContext -Subscription $sub | Out-Null
    $azSubName = $Sub.Name    

    Write-host -BackgroundColor DarkCyan "processing $($azSubName) subscription"

    $virtulamachines = Get-AzVm

    $virtulamachines | Select-Object ResourceGroupName,Name,Location,ProvisioningState,@{L="OS";e={$_.StorageProfile.OsDisk.OsType}},@{L="AdminUN";e={$_.OSProfile.AdminUsername}},@{L="subs";e={($_.ID).split('/')[2]}} | Export-Csv -NoTypeInformation -NoClobber -Append -Path .\Script_out\azvm-apr2022.csv

}