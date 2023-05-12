#get resource group tags

Write-Host "starting script"

$import = Import-Csv -Path $env:USERPROFILE\Downloads\azurestorageaccount-test.csv
$sub = Get-AzSubscription -SubscriptionName "CC-Test(Converted to EA)"  #Where-Object {$_.Name -like "cc-*"}
Set-AzContext -Subscription $sub | Out-Null
    $azSubName = $Sub.Name

foreach ($account in $import) {

    $sgaccount = Get-AzStorageAccount -Name $account.name -ResourceGroupName $account.RESOURCEGROUP
    $sgcontext = $sgaccount.Context

    $sgcontainer = Get-AzStorageContainer -Context $sgcontext

    foreach ($container in $sgcontainer) {
        
        $blob = Get-AzStorageContainer -Context $sgcontext -Name $container.name;
    
        $datacollection = [PSCustomObject][ordered]@{
            subscription = $azSubName
            Storageaccount = $sgaccount.StorageAccountName
            ResourceGrpName = $sgaccount.ResourceGroupName
            SgaccountLocation = $sgaccount.Location
            Sgallowpublicaccess = $sgaccount.AllowBlobPublicAccess
            SGAllowHTTPSonly = $sgaccount.EnableHttpsTrafficOnly
            SGTLSVersion = $sgaccount.MinimumTlsVersion
            Blobname = $blob.Name
            BlobPublicAccess = $blob.PublicAccess
            Bloburi = $blob.CloudBlobContainer.Uri
            TagSquad = (Get-AzResourceGroup -Name $account.RESOURCEGROUP).tags.squad
            TagServiceRegister = (Get-AzResourceGroup -Name $account.RESOURCEGROUP).tags.'service-register'
            TagProduct = (Get-AzResourceGroup -Name $account.RESOURCEGROUP).tags.Product
    }
    $datacollection | Export-Csv -Path $env:OneDrive\a2b\script_out\az-sgaccount-with-rsg-tags.csv -Append -NoTypeInformation -NoClobber

        
    }

}
