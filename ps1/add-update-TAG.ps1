#update existing tags for resources
$tags = @{"squad" = "Dynamics"}
$res = Get-AzResource -Tagvalue "Dyanmics"
foreach ($r in $res) {Update-AzTag -ResourceId $r.ResourceId -Tag $tags -Operation Replace -Verbose}
#######

$tagkeyname = "Product"
$res = Get-AzResource -TagName " Product"
foreach ($r in $res) {

    $r | Where-Object {$_.Tags.Keys -eq " Product"} 
    
    Update-AzTag -ResourceId $r.ResourceId -Tag  -Operation Replace -Verbose}


#update tags of resourcegroups

$tags
$rg = Get-AzResourceGroup -Name ERP-M7-PROD
New-AzTag -ResourceId $rg.ResourceId -Tag $tags

#**********************************************#

##Set-AzSubscription Context
$devcontext = Set-AzContext -Subscription "CC-Accounts-Dev(Converted to EA)" -Name DEV
$prodcontext = Set-AzContext -Subscription "CC-Prod(Converted to EA)" -Name PROD
$testcontext = Set-AzContext -Subscription "CC-test(Converted to EA)" -Name Test

Get-AzResourceGroup | Where-Object {$_.ResourceGroupName -like "*VS-clt*"} | Select-Object ResourceGroupName,Location

$tags = @{"squad" = "A2B-VSS-DEVOPS"; "product" = "VSS-DEVOPS-CloudLoadTesting-RG" }
$res = Get-AzResourceGroup | Where-Object {$_.ResourceGroupName -like "*VS-clt*"}
foreach ($r in $res) {New-AzTag -ResourceId $r.ResourceId -Tag $tags -Verbose}


#########

$rgwithoutsquadtag = Get-AzResourceGroup | Where-Object {$_.Tags.Keys -ne "*squad*"} | Select-Object ResourceGroupName
$rgwithoutsquadtag.Count