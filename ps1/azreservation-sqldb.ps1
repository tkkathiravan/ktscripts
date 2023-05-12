<#
.DESCRIPTION: 
.LINK:
    
#>

Clear-Host

#Start Time
$startTime = "{0:G}" -f (Get-Date)
Write-Host "*** Script started on $startTime ***`n`n" -ForegroundColor White -BackgroundColor Blue

Write-Host "Script executed under $((Get-AzContext).Account.Id)" -ForegroundColor Cyan

$AZSubscriptions = Get-AzSubscription

ForEach ($AZSubscription in $AZSubscriptions)
{
	Write-Host "Selecting Azure Subscription [$($AZSubscription.Name)] - $($AZSubscription.Id)" -ForegroundColor Yellow
	
	Select-AzSubscription -SubscriptionId $AZSubscription.Id

  Get-AzReservation | ForEach-Object {Get-AzSqlDatabase -ServerName $_.ServerName -ResourceGroupName $_.ResourceGroupName}  | select servername,databasename | Out-GridView
    
}
