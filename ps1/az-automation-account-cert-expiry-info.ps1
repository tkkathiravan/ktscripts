#Get Azure automation account certificates, expiry dates and email to noc@cabcharge.com.au

$subscriptions = Get-AzSubscription

Select-AzSubscription -Subscription $subscriptions.name[0]

Get-AzAutomationAccount | ForEach-Object  {Get-AzAutomationCertificate -ResourceGroupName $_.ResourceGroupName -AutomationAccountName $_.AutomationAccountName} | `
select resourcegroupname,Automationaccountname,name,expirytime | Export-Csv -NoTypeInformation -NoClobber -Path c:\temp\azautomationaccount-cert-expiryinfo.csv

