#get all prod subscription RG's
$resgrp = Get-AzResourceGroup
$resgrp.Count

#get all prod subscription RG's which dont have a tag
$rgtagnull = Get-AzResourceGroup | Where-Object {$_.Tags -eq $null}
$rgtagnull.Count
$rgtagnull | Select-Object Resourcegroupname,tags

#get all prod subscription RG's which has squad tag
$tagname = "squad"
$rgwithsquadtag =  Get-AzResourceGroup | Where-Object {$_.Tags.Keys -eq $tagname}
$rgwithsquadtag.count


#get all prod subscription RG's which dont have squad tag
$rgwouttagsqd = Get-AzResourceGroup | Where-Object {$_.Tags.Keys -notcontains $tagname}
$rgwouttagsqd | Select-Object Resourcegroupname,tags
$rgwouttagsqd.count


#get RG's equal MTI from the RG's variables which dont have the squad tag
$MTIRG = $rgwouttagsqd | Where-Object {$_.ResourceGroupName -like "*MTI*"}
$MTIRG.count

#Assign the squad tag to the identified MTI rg's

$MTIRGs =  Get-AzResourceGroup | Where-Object {$_.Tags.Keys -notcontains $tagname -and $_.ResourceGroupName -like "*MTI*"}
$MTIRGs.count

$tags = @{"squad" = "MTI"}
foreach ($rgmti in $MTIRGs) {Write-Host -ForegroundColor Cyan "Current rg is $($rgmti.resourcegroupname)" ; New-AzTag -Tag $tags -ResourceId $rgmti.resourceid -Confirm:$false -Verbose}

#update tags of resourcegroups payment operations

$tags = @{"squad" = "Payment Operations"}
$rg = Get-AzResourceGroup -Name A2BNSGFLOWRG
New-AzTag -ResourceId $rg.ResourceId -Tag $tags

#get rgs with 13cabs name
$13cabtag = Get-AzResourceGroup | Where-Object {$_.Tags.Keys -notcontains $tagname -and $_.ResourceGroupName -like "*13cab*" }

$tags = @{"squad" = "DnA"}
$rg = Get-AzResourceGroup -Name 13CABS-PROD-Reporting
New-AzTag -ResourceId $rg.ResourceId -Tag $tags

$tags = @{"squad" = "Payment Operations"}
$rg = Get-AzResourceGroup -Name CC-Prod-13cabs-API
New-AzTag -ResourceId $rg.ResourceId -Tag $tags

####cloudhsell

$cldshell = Get-AzResourceGroup | Where-Object {$_.Tags.Keys -notcontains $tagname -and $_.ResourceGroupName -like "*shell*"}
$cldshell.count
$cldshell | select resourcegroupname,tags

#set the Res grp name as squad name
foreach ($clsh in $cldshell) {Write-Host -ForegroundColor Cyan "Current rg is $($clsh.resourcegroupname)" ; $tags = @{"squad" = "$($clsh.resourcegroupname)"}; New-AzTag -Tag $tags -ResourceId $clsh.resourceid -WhatIf -Confirm:$false -Verbose}

$tags = @{"squad" = "Payment Operations"}
foreach ($clsh in $cldshell) {Write-Host -ForegroundColor Cyan "Current rg is $($clsh.resourcegroupname)" ; New-AzTag -Tag $tags -ResourceId $clsh.resourceid -Confirm:$false -Verbose}

###default
$def = Get-AzResourceGroup | Where-Object {$_.Tags.Keys -notcontains $tagname -and $_.ResourceGroupName -like "*default*"}
$def.count
$def | select resourcegroupname,tags

$tags = @{"squad" = "MTI"}
foreach ($a in $def) {Write-Host -ForegroundColor Cyan "Current rg is $($a.resourcegroupname)" ; New-AzTag -Tag $tags -ResourceId $a.resourceid -Confirm:$false -Verbose}

###dynamics
$dyn = Get-AzResourceGroup | Where-Object {$_.Tags.Keys -notcontains $tagname -and $_.ResourceGroupName -like "*dynamics*"}
$dyn.count
$dyn | select resourcegroupname,tags

$tags = @{"squad" = "Dynamics"}
foreach ($a in $dyn) {Write-Host -ForegroundColor Cyan "Current rg is $($a.resourcegroupname)" ; New-AzTag -Tag $tags -ResourceId $a.resourceid -Confirm:$false -Verbose}

###dynamics
$dy = Get-AzResourceGroup | Where-Object {$_.Tags.Keys -notcontains $tagname -and $_.ResourceGroupName -like "*azurebackup*"}
$dy.count
$dy | select resourcegroupname,tags

$tags = @{"squad" = "MTI"}
foreach ($a in $dy) {Write-Host -ForegroundColor Cyan "Current rg is $($a.resourcegroupname)" ; New-AzTag -Tag $tags -ResourceId $a.resourceid -Confirm:$false -Verbose}

##VSS

$tags = @{"squad" = "A2B-VSS-DEVOPS"; "product" = "VSS-DEVOPS-CloudLoadTesting-RG" }
$res = Get-AzResourceGroup -ResourceGroupName "VS-clt-c6534e71-f34d-44fd-a3db-5666672ace7c-Group"
New-AzTag -ResourceId $res.ResourceId -Tag $tags -Verbose

#dispath
$tags = @{"squad" = "Dispatch"}
$res = Get-AzResourceGroup -ResourceGroupName "CC-PROD-DISPATCH-HOSTING-AUS-SE"
New-AzTag -ResourceId $res.ResourceId -Tag $tags -Verbose

#it operations
$tags = @{"squad" = "IT Operations"}
$res = Get-AzResourceGroup -ResourceGroupName "CC-PROD-DISPATCH-HOSTING-AUS-SE"
New-AzTag -ResourceId $res.ResourceId -Tag $tags -Verbose

$res = Get-AzResourceGroup -ResourceGroupName "appservbackup"
New-AzTag -ResourceId $res.ResourceId -Tag $tags -Verbose

#Network operators
$tags = @{"squad" = "Networks and Operators"}
$res = Get-AzResourceGroup -ResourceGroupName "ARM_Deploy_Staging"
New-AzTag -ResourceId $res.ResourceId -Tag $tags -Verbose

#ssl
$tags = @{"squad" = "Payment Operations"}
$res = Get-AzResourceGroup -ResourceGroupName "CC-PROD-SSL-CERTIFICATES"
New-AzTag -ResourceId $res.ResourceId -Tag $tags -Verbose

#legends of tomorrow

$tags = @{"squad" = "legends of tomorrow"}
$res = Get-AzResourceGroup -ResourceGroupName "act-digital-ticket-prod"
New-AzTag -ResourceId $res.ResourceId -Tag $tags -Verbose

#Last check to see any resource groups without Squad name

KATHIR:/>$rgwouttagsqd = Get-AzResourceGroup | Where-Object {$_.Tags.Keys -notcontains $tagname}
$rgwouttagsqd | Select-Object Resourcegroupname,tags
$rgwouttagsqd.count
0

##**************************####

$rgwouttagsqd = Get-AzResourceGroup | Where-Object {$_.Tags.Keys -notcontains $tagname}
$rgwouttagsqd | Select-Object Resourcegroupname,tags
$rgwouttagsqd.count

#get resourcegroups without any resources

$rgwoutrscrs = Get-AzResourceGroup
foreach ($item in $rgwoutrscrs) {
    if((Get-AzResource -ResourceGroupName $item.ResourceGroupName).Equals($null)) {

        Write-Host -BackgroundColor Green "$($item.ResourceGroupName) is empty."
    }

    Else {
        Write-Host -BackgroundColor Green "$($item.ResourceGroupName) is NOT Empty."
    }
}

#####TEST SUBSCRIPTION

#legends of tomorrow

$tags = @{"squad" = "shotgunners"}
$res = Get-AzResourceGroup -ResourceGroupName "test-statement-processor"
New-AzTag -ResourceId $res.ResourceId -Tag $tags -Verbose

## Sharpies Melbourne
$tags = @{"squad" = "Sharpies Melbourne"}
$res = Get-AzResourceGroup -ResourceGroupName "13driver-rg"
New-AzTag -ResourceId $res.ResourceId -Tag $tags -Verbose

##TEST
$tags = @{"squad" = ""}
$res = Get-AzResourceGroup -ResourceGroupName "CC-TEST-ENT-APP-RG"
New-AzTag -ResourceId $res.ResourceId -Tag $tags -Verbose