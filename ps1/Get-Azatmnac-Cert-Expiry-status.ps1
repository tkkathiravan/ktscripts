
#Get Azure automation account certificates, expiry dates and email to noc@cabcharge.com.au

$subscriptions = Get-AzSubscription

foreach ($subscription in $subscriptions) {

Select-AzSubscription -Subscription $subscription;

$certcol = Get-AzAutomationAccount | ForEach-Object { Get-AzAutomationCertificate -ResourceGroupName $_.ResourceGroupName -AutomationAccountName $_.AutomationAccountName | Where-Object {$_.ExpiryTime -gt (Get-Date).AddMonths(-1)} | `
select resourcegroupname,Automationaccountname,name,expirytime}

$array += $certcol

}

#Format Module
$out = $array | Sort-Object -Property Expirytime | ConvertTo-Html

#Email Module

$From = "Azure-Runbook@a2baustralia.com"
$MailTo = "kathiravan.thanappan@a2baustralia.com"
$smtp = "relay.13cabs.com.au"
$fileDate = (get-date).AddDays(-1).ToString("yyyyMMdd")
$subject = "Azure Runbook Automation Account Certificates  Expiry Information - $fileDate"
$Body = " These Azure runbook automation accounts in our Tenant will expire on the mentioned dates as below. Prepare for renewal if expiring soon $out"

Send-MailMessage -From $From -To $MailTo -SmtpServer $smtp -Body $Body -Subject $subject -BodyAsHtml