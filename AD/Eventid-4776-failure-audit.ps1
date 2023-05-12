#get sec event log id 4776 failure audit and get the username and source workstation.

Get-EventLog -LogName Security -InstanceId 4776 -EntryType FailureAudit |Where-Object {$_.ReplacementStrings[1] -eq "rav.singh"} | select @{L="Username";e={$_.ReplacementStrings[1]}},@{L="SourceComputername";e={$_.ReplacementStrings[2]}}