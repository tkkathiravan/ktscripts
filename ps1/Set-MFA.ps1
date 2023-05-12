#set-mfa for users and then query and list MFA status of those accounts.

$starttime = "{0:G}" -f (Get-Date)

Write-Host -ForegroundColor White -BackgroundColor DarkRed "starting script - $($startTime)"

#connect to the mMS Office 365 service
#Connect-MsolService

$Accounts = Get-Content .\Script_in\enableMFa-8thlist-pending.txt
$MFA = New-Object –TypeName Microsoft.Online.Administration.StrongAuthenticationRequirement
$MFA.RelyingParty = "*"
$MFA.State = "Enabled"
$MFAOptions = @($MFA)
#set MFA for each user
ForEach ($A in $Accounts) {

    write-host -ForegroundColor Yellow "Setting up MFA for user $($A)"
    Set-MsolUser –UserPrincipalName $A –StrongAuthenticationRequirements $MFAOptions 

    }

    #get the MFA status of these users.
Get-Content -Path .\Script_in\enableMFa-9thlist.txt | ForEach-Object {

    Get-MsolUser -UserPrincipalName $_ | select-object displayname,`
    @{L="MFASTATE";e={$_.strongauthenticationrequirements.state}},`
    @{L="MFARelyingParty";e={$_.strongauthenticationrequirements.relyingparty}},`
    @{L="DefaultMFAMethodType";e={ ($_.StrongAuthenticationmethods | ? {$_.isdefault -eq $true}).methodtype} }
 }

 Write-Host "The script finished running"
$endtime = "{0:G}" -f (Get-Date)
Write-Host "Script finished at: $($endtime)"
Write-Host "Time elapsed: $(New-Timespan $startTime $endtime)" -ForegroundColor White -BackgroundColor DarkRed



####CHECK THE STTAUS OF ENABLED BUT MFA SETUP NOT COMPLETE USERS LIST#######

Get-Content -Path .\Script_in\enableMFa-8thlist.txt | ForEach-Object {

    Get-MsolUser -UserPrincipalName $_ | select-object displayname,`
    @{L="MFASTATE";e={$_.strongauthenticationrequirements.state}},`
    @{L="MFARelyingParty";e={$_.strongauthenticationrequirements.relyingparty}},`
    @{L="DefaultMFAMethodType";e={ ($_.StrongAuthenticationmethods | ? {$_.isdefault -eq $true}).methodtype} }
 } | Where-Object {$_.DefaultMFAMethodType -eq $null} | ft -AutoSize -Wrap