#switch to select a subscription

Connect-AzAccount -Credential (Get-Credential)
$subscriptions = Get-AzSubscription

$msg = read-host "Select SUBSCRIPTION you want to work with:"

switch ($msg)
        {
            'PROD' {Select-AzSubscription -Subscription $subscriptions.name[0] -Force}
            'TEST' {Select-AzSubscription -Subscription $subscriptions.name[1] -Force}
            'DEV' {Select-AzSubscription -Subscription $subscriptions.name[2] -Force}
            Default {Select-AzSubscription -Subscription $subscriptions.name[0] -Force}
        }