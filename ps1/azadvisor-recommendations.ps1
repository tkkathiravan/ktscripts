
#collect the location of the Azure recommended hardware types: and select unique entries.

$type = (Get-AzAdvisorRecommendation -Category Cost | Where-Object {$_.impactedfield -eq "Microsoft.Subscriptions/subscriptions"} | ForEach-Object {$_.ExtendedProperties.values.split(",")[0]} ) |Sort-Object |Get-Unique


#collect the VMSIZE of the Azure recommended hardware types: and select unique entries.
$scope = (Get-AzAdvisorRecommendation -Category Cost | Where-Object {$_.impactedfield -eq "Microsoft.Subscriptions/subscriptions"} | ForEach-Object {$_.ExtendedProperties.Values.split(",")[1]}) | Sort-Object |Get-Unique


$Sku = (Get-AzAdvisorRecommendation -Category Cost | Where-Object {$_.impactedfield -eq "Microsoft.Subscriptions/subscriptions"} | ForEach-Object {$_.ExtendedProperties.Values.split(",")[2]}) | Sort-Object |Get-Unique

#get vm for each location from the $location array and match the vm hardware size whcih should be equal to the $vmsizes array
foreach ($a in $location) {

 Write-Progress -Activity "Processing Location: $a"

 foreach ($b in $vmsize) {

 Get-AzVM -Location $a | Where-Object {$_.HardwareProfile.VmSize -eq "$b"} | `
 
 Select ResourceGroupName,Name,Location,@{L="TAG";e={IF ($_.tags.keys.count -gt 1) {$_.tags.keys.split(",")[0] + ":" + $_.tags.values.split(",")[0]} ELSE {$_.tags.keys.split(",") + ":" + $_.tags.values.split(",")}}},@{Name="OSType"; E={$_.StorageProfile.OSDisk.OSType}}, @{Name="VMSIZE"; E={$_.HardwareProfile.VmSize}} | `

 Export-Csv -NoTypeInformation -Append -NoClobber -Path 'C:\Users\kathiravan.thanappan\OneDrive - A2B Australia\A2B\Excels\AZ-VM-RECOMMENDATIONS-OCT-7-2020.csv'
 
 }

   }


