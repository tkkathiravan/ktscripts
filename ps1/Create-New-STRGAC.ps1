<#
    .SYNOPSIS
#>
$location = Get-Content .\Script_in\sglocations.txt

$rgname = "A2BNSGFLOWRG"

foreach ($loc in $location) {

    If ($loc.Length -gt 13) {

        $sgname = "nsgflwsg" + $loc.Substring(0,3) + $loc.Substring($loc.Length -9)
            
    New-AzStorageAccount -Name $sgname -ResourceGroupName $rgname -SkuName Standard_LRS -Location $loc -Kind StorageV2 -AccessTier Hot `
    -Tag @{"squad"="Payment Operations";"product"="nsgflowlog";} -ErrorVariable sgerror

    }
    
    Else {
        
        $sgname = "nsgflwsg" + $loc

        New-AzStorageAccount -Name $sgname -ResourceGroupName $rgname -SkuName Standard_LRS -Location $loc -Kind StorageV2 -AccessTier Hot `
         -Tag @{"squad"="Payment Operations";"product"="nsgflowlog";} -ErrorVariable sgerror
    }
}

