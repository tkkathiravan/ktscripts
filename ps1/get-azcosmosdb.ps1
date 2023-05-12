#get Azure Cosmos DB details

$starttime = "{0:G}" -f (Get-Date)

Write-Host "starting script - $($startTime)"

$subs = Get-AzSubscription | Where-Object {$_.Name  -like "cc-*"}

foreach ($sub in $subs) 
{
    Set-AzContext -Subscription $sub | Out-Null
    $azSubName = $Sub.Name    

    Write-host "processing $($azSubName) subscription"
    
    $rgs = Get-AzResourceGroup

    foreach ($rg in $rgs) 
    {
       
        Write-host "Processing Resourcegroup  $(($rg).ResourceGroupName)" -ForegroundColor DarkGreen

        $cosmosdb = Get-AzCosmosDBAccount -ResourceGroupName $rg.ResourceGroupName

        foreach ($cdb in $cosmosdb)
            {
                Write-host "Processing CosmosDB:  $(($cdb).Name) in $(($rg).ResourceGroupName)" -ForegroundColor DarkGreen 
                
                $CSMSDB = Get-AzCosmosDBAccount -ResourceGroupName $rg.ResourceGroupName -Name $cdb.Name
                  
                $rgtags = (Get-AzResourceGroup -Name $rg.ResourceGroupName).Tags
            
            $datacollections = [PSCustomObject][ordered]@{
                Subscription        = $azSubName
                ResourceGroupName   = $CSMSDB.ResourceGroupName
                CosmosDBName        = $CSMSDB.Name
                Location            = $CSMSDB.Location
                Kind                = $CSMSDB.Kind
                AllowedFWIP         = $CSMSDB.IpRules.IpAddressOrRangeProperty  -join ","
                EnableMultipleWriteLocations = $CSMSDB.EnableMultipleWriteLocations
                FailoverPlcyName    = $CSMSDB.FailoverPolicies.Id
                FailoverLocation    = $CSMSDB.FailoverPolicies.LocationName
                PublicNwAccess      = $CSMSDB.PublicNetworkAccess
                DocEndpoint         = $CSMSDB.DocumentEndpoint
                DBAcntOffertype     = $CSMSDB.DatabaseAccountOfferType
                RGTagSquad          = $rgtags.squad
                RGTagSquad1         = $rgtags.Squad
                RGTagProduct        = $rgtags.Product
        
            }
            $datacollections | Export-Csv -Path $env:OneDrive\a2b\script_out\$azSubName"-AZCsomosdbaccountdetails-$(Get-Date -f 'dd-MM-yyyy')".csv -Append -NoTypeInformation -NoClobber
            }
    
        }
    }

Write-Host "The script finished running"
$endtime = "{0:G}" -f (Get-Date)
Write-Host "Script finished at: $($endtime)"
Write-Host "Time elapsed: $(New-Timespan $startTime $endtime)" -ForegroundColor White