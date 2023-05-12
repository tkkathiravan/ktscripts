#get Azure API Management service details

$starttime = "{0:G}" -f (Get-Date)

Write-Host "starting script - $($startTime)"

$subs = Get-AzSubscription | Where-Object {$_.Name  -like "*cc-*"}

foreach ($sub in $subs) {
    Set-AzContext -Subscription $sub | Out-Null
    $azSubName = $Sub.Name    

    Write-host "processing $($azSubName) subscription"

    $apimgmtlist = Get-AzApiManagement
 
    foreach ($apimgmt in $apimgmtlist) {

         Write-host "Currently Processing  $(($apimgmt).Name)" -ForegroundColor DarkGreen
     
    $apicontext = New-AzApiManagementContext -ResourceGroupName $apimgmt.ResourceGroupName -ServiceName $apimgmt.Name

    $apislist = Get-AzApiManagementApi -Context $apicontext

        foreach($api in $apislist){

        #$productid = Get-AzApiManagementProduct -Context $apicontext -ApiId $api.ApiId

          $datacollections = [pscustomobject][ordered]@{
                Subscription            = $azSubName
                APIResGroupName         = $apimgmt.ResourceGroupName
                ApiMgmtService          = $apimgmt.Name
                Location                = $apimgmt.Location
                #ApiMgmtpublicip        = $apimgmt.PublicIPAddresses
                ApiMgmtsku              = $apimgmt.Sku
                ApiMgmtpublishermail    = $apimgmt.PublisherEmail
                DeveloperPortalUrl      = $apimgmt.DeveloperPortalUrl
                PortalUrl               = $apimgmt.PortalUrl
                APIID                   = $api.APIID
                Apiname                 = $api.Name
                Apiserviceurl           = $api.serviceUrl
                path                    = $api.path
                APIType                 = $api.ApiType
                #APIProtocol            = $api.Protocols
                APISubscriptionrequired = $api.Subscriptionrequired
                SubkyHdrName            = $api.SubscriptionKeyHeaderName
        }
        
        $datacollections | Export-Csv -Path $env:OneDrive\a2b\script_out\$azSubName"-AZ-ALL-API".csv -Append -NoTypeInformation -NoClobber -Force
            }
            
        }
    }

Write-Host "The script finished running"
$endtime = "{0:G}" -f (Get-Date)
Write-Host "Script finished at: $($endtime)"
Write-Host "Time elapsed: $(New-Timespan $startTime $endtime)" -ForegroundColor White -BackgroundColor DarkRed
