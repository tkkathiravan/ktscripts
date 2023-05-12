$certexpiry = Get-AzAutomationAccount | Get-AzAutomationCertificate |select Name,Automationaccountname,creationtime,expirytime,resourcegroupname |format-table -auto -wrap

#Email this output.
$username = "opstestsendgrid-apikey"
$pw = convertto-securestring "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" -asplaintext -force
$credential =  New-Object System.Management.Automation.PSCredential $username,$pw
$From = "Azure-Runbook@a2baustralia.com"
$MailTo = "kathiravan.thanappan@a2baustralia.com"
$smtp = "smtp.sendgrid.net"
$fileDate = (get-date).AddDays(-1).ToString("yyMMdd")
$Body = "AZ Runbook Automation Account Certificates  Expiry Information"
$subject = " These Azure runbook automation accounts in our Tenant will expire on the mentioned dates as below. Prepare for renewal if expiring soon. " + $certexpiry

Send-MailMessage -From $From -To $MailTo -SmtpServer $smtp -Body $Body -Subject $subject -usessl -port 587 -credential $credential