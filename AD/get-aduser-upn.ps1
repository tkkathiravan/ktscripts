$upncheck = Get-Content "C:\Users\kathiravan.thanappan\OneDrive - A2B Australia\A2B\Script_in\usersUPNPCTeam.txt" 

Foreach ($a in $upncheck) 
{
    $user = (Get-ADUser $a).userprincipalname

    Write-Host "user $($a) is $user" -BackgroundColor Blue -ForegroundColor White
}