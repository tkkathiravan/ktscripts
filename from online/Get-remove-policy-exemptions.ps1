
#get Azure policyexemptions and remove them.

$starttime = "{0:G}" -f (Get-Date)

Write-Host "starting script - $($startTime)"

$subs = Get-AzSubscription | Where-Object {$_.Name  -like "CC-*"}

foreach ($sub in $subs) {
    Set-AzContext -Subscription $sub | Out-Null
    $azSubName = $Sub.Name    

    Write-host -BackgroundColor DarkCyan "processing $($azSubName) subscription"

    $policyassignment = Get-AzPolicyAssignment -Name 'SecurityCenterBuiltIn'
    
    Write-host -BackgroundColor DarkGreen "processing policy $($policyassignment.ResourceName)"

    $PolicyExemption = Get-AzPolicyExemption -PolicyAssignmentIdFilter $policyassignment.ResourceId | Where-Object {$_.name -eq "ASC-Avulnerabilityassessmentsolutionshouldbeenabledonyo-builtin"}
    
    foreach ($exempt in $PolicyExemption) {

        Write-Host  -BackgroundColor Red "Processing to remove $($exempt.ResourceName) of $($exempt.ResourceGroupName)"

        Remove-AzPolicyExemption -Id $exempt.ResourceId -Force
    }
 
}
