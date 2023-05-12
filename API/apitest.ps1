#get Azure API Management service details

$starttime = "{0:G}" -f (Get-Date)

Write-Host "starting script - $($startTime)"

$subs = Get-AzSubscription | Where-Object {$_.Name  -like "*cc-*"}

foreach ($sub in $subs) {
    Set-AzContext -Subscription $sub | Out-Null
    $azSubName = $Sub.Name    

    Write-host "processing $($azSubName) subscription"

    $apilist = Get-AzApiManagement
 
    foreach ($api in $apilist) {

         Write-host "Currently Processing Resourcegroup  $(($api).Name)" -ForegroundColor DarkGreen
     
        #write-host "Processing $(($api).Name)" -ForegroundColor DarkCyan; 

        $apicontext = New-AzApiManagementContext -ResourceGroupName $api.ResourceGroupName -ServiceName $api.Name

        Get-AzApiManagementSubscription -Context $apicontext | Select-Object @{L="Api_Name";e={$api.Name}}, @{L="ScopeCategory";e={$_.scope.Split('/')[9]}},@{L="Product/Api-Name";e={$_.scope.Split('/')[10]}},subscriptionid,state,allowtracing,@{L="ResGrp";e={$api.ResourceGroupName}},@{L="Subscription";e={$azSubName}} `
        | Export-Csv -Path $env:OneDrive\a2b\script_out\$azSubName"-API-info".csv -Append -NoTypeInformation -NoClobber -Force

    }
      
        }
    

Write-Host "The script finished running"
$endtime = "{0:G}" -f (Get-Date)
Write-Host "Script finished at: $($endtime)"
Write-Host "Time elapsed: $(New-Timespan $startTime $endtime)" -ForegroundColor White -BackgroundColor DarkRed