#get storage accounts across all subscriptions with resource group tags
$starttime = "{0:G}" -f (Get-Date)

Write-Host "starting script at: $($startTime)"

$subs = Get-AzSubscription | Where-Object {$_.Name -like "cc-*"}

try {
    foreach($sub in $subs)
{
    Set-AzContext -Subscription $sub | Out-Null
    $azSubName = $Sub.Name  
    Write-Host "current subscription is $($azSubName)"

    $sgaccounts = Get-AzStorageAccount

    foreach ($strgaccount in $sgaccounts) {

        $rg = (Get-AzResourceGroup -Name $strgaccount.ResourceGroupName).tags
        
        $strgcontext = $strgaccount.Context
    
        Write-Host "Currently processing storage account $($strgcontext.StorageAccountName)" -ForegroundColor Yellow

        $strgcontainer = Get-AzStorageContainer -Context $strgcontext -ErrorAction SilentlyContinue
    
        foreach ($container in $strgcontainer) {
            
            $blob = Get-AzStorageContainer -Context $strgcontext -Name $container.name -ErrorAction SilentlyContinue;
        
            $datacollections = [PSCustomObject][ordered]@{
                Subscription        = $azSubName
                Storageaccount      = $strgaccount.StorageAccountName
                ResourceGrpName     = $strgaccount.ResourceGroupName
                SgaccountLocation   = $strgaccount.Location
                SgaccountSKU        = $strgaccount.Sku.Name
                SgaccountKIND       = $strgaccount.Kind
                SgaccountAccessTier = $strgaccount.AccessTier
                SgaccountCreateTime = $strgaccount.CreationTime -f "{0:G}"
                Sgallowpublicaccess = $strgaccount.AllowBlobPublicAccess
                SGAllowHTTPSonly    = $strgaccount.EnableHttpsTrafficOnly
                SGTLSVersion        = $strgaccount.MinimumTlsVersion
                Blobname            = $blob.Name
                BlobPublicAccess    = $blob.PublicAccess
                Bloburi             = $blob.CloudBlobContainer.Uri
                BlobLastmodifieddate= $blob.LastModified.UtcDateTime -f "{o:G}"
                TagSquad            = $rg.squad
                TagSquad1           = $rg.Squad
                TagProduct          = $rg.tags.Product
        }
        $datacollections | Export-Csv -Path $env:OneDrive\a2b\script_out\az-devsubsc-sgaccount-with-rsg-tags.csv -Append -NoTypeInformation -NoClobber
                
        }
    
    }
}
}
catch {
  Write-Host "error occurred $($Error)"
}

$endtime = "{0:G}" -f (Get-Date)
Write-Host "Script finished at: $($endtime)"
Write-Host "Time elapsed: $(New-Timespan $startTime $endtime)" -ForegroundColor White -BackgroundColor DarkRed


