<#
.Synopsis
   This script helps with formatting resource id (Subscription ID) from the vm resource and formats the Tags Key Vakue in the Format: KEY:VALUE
.DESCRIPTION
   
.EXAMPLE
    $vmss = "CCPROD-SIEM-QRadarAIO" 
    Get-A2BVMsplittags -Vmname $vmss
   
.EXAMPLE
    Get-Content -Path 'C:\Users\kathiravan.thanappan\OneDrive - A2B Australia\a2b\Script_in\vmsin.txt' | ForEach-Object {Get-A2BVMsplittags -Vmname $_  |Export-Csv -NoTypeInformation -NoClobber -Append -Path 'C:\Users\kathiravan.thanappan\OneDrive - A2B Australia\a2b\Script_Out\out1.csv' } 
#>

Function Get-A2BVMsplittags

{

[CmdletBinding()]

Param 
    (
      [Parameter (
      
                  Mandatory = $True,
                  ValueFromPipelineByPropertyname = $True,
                  ValueFromPipeline = $True
                  )
      ]
        [string]$Vmname
    )


Begin {

       
}

Process {

        Foreach ($Vm in $Vmname) {
            
            Write-Progress -activity "currently processing resourcegroup: $Vm"
              
        Get-AzVM -Name $Vm |select Resourcegroupname,Name,Location,@{L="Resourceid";e={$_.id.split("/")[2]}},`
         @{L="KeyName";e= {IF ($_.tags.keys.count -gt 1) {$_.tags.keys.split(",")[0] + ":" + $_.tags.values.split(",")[0]} ELSE {$_.tags.keys.split(",") + ":" + $_.tags.values.split(",")}}},`
         @{L="KeyName1";e= {IF ($_.tags.keys.count -gt 1) {$_.tags.keys.split(",")[1] + ":" + $_.tags.values.split(",")[1]} ELSE {$_.tags.keys.split(",") + ":" + $_.tags.values.split(",")}}}
       
       # The selection has a expression to work with splitting tag values, if there are multiple tags it work in a way and if more than 1 it works differently.
        }

}

END {}


}
