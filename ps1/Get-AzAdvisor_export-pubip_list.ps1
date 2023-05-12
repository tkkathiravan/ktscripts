 
 Select-A2Bsubscription -TenantENV Prod
 Get-AzAdvisorRecommendation | Where-Object {$_.ImpactedField -eq "Microsoft.Network/publicIPAddresses"} | select impactedvalue,@{L="RG";e={$_.resourceid.split("/")[4]}} | Export-Csv -NoTypeInformation -Path 'C:\Users\kathiravan.thanappan\OneDrive - A2B Australia\A2B\Excels\impacted_IP_Prod.csv'

 
 Import-Csv -Path 'C:\Users\kathiravan.thanappan\OneDrive - A2B Australia\A2B\Excels\impacted_IP_prod.csv' | ForEach-Object {Get-AzPublicIpAddress -ResourceGroupName $_.RG -Name $_.impactedvalue |select Resourcegroupname,Name,location,ipaddress,publicipallocationmethod,PublicIpAddressVersion } | Export-Csv -Path 'C:\Users\kathiravan.thanappan\OneDrive - A2B Australia\A2B\Excels\AZ-RECOMMENDATIONS-PUBIP-PROD.csv'
