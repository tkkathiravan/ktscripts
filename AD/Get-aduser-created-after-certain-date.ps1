#collect all users gathered after a certain date.


$days = Read-host "Enter the number of days you want to go back and check for users created:"
$date = (get-date).AddDays(-$days)
$csvpath = "$env:OneDrive\A2B\Script_out\13CabsUsersCreatedbefore-$($days)Days.csv"

$collection = Get-ADUser -filter {enabled -eq $true} -Properties name,UserPrincipalName,whenCreated | Where-Object {$_.whencreated -gt $date}
$collection | Select-Object name,UserPrincipalName,whenCreated | `
 Export-Csv -NoTypeInformation -NoClobber -Path $csvpath