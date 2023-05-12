



$azSubs = Get-AzSubscription |Where-Object {$_.Name -like "CC-*"}

foreach ( $azSub in $azSubs ) {
    Set-AzContext -Subscription $azSub | Out-Null
    #$azSubName = $azSub.Name

    $virtualmachines = Get-AzVM

    $virtualmachines | ForEach-Object  {$_ | Select-Object Name,resourcegroupname,@{L="Extensionname";e={$_.extensions.ID | ForEach-Object {$_ -split('/') |Select-Object -Last 1} }}}

}