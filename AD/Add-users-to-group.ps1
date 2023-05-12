#Add users to adgroup  - Adding mfa enabled users to adgroup 'MFA Enable'

$starttime = "{0:G}" -f (Get-Date)

Write-Host -ForegroundColor White -BackgroundColor DarkRed "starting script - $($startTime)"

$un = Get-Content "C:\Users\kathiravan.thanappan\OneDrive - A2B Australia\A2B\Script_in\mfa-enabled.txt" 

Foreach ($a in $un) 
{
    
    $userdn = (Get-ADUser $a).distinguishedname

    $group = Get-ADGroup 'MFA Enable'
    
    Add-ADGroupMember -Identity $group -Members $userdn -Confirm:$false -ErrorAction Continue

    Write-Host -ForegroundColor White -BackgroundColor Blue "User $($a) added to group $group"

}


Write-Host "The script finished running"
$endtime = "{0:G}" -f (Get-Date)
Write-Host "Script finished at: $($endtime)"
Write-Host "Time elapsed: $(New-Timespan $startTime $endtime)" -ForegroundColor White -BackgroundColor DarkRed