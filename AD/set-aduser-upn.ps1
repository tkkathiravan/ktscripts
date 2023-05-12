
$users = Import-Csv "C:\Users\kathiravan.thanappan\OneDrive - A2B Australia\A2B\Script_in\adusersetupn.csv"

foreach ($item in $users) {
  
    Write-Host "Processing user $($item.name) for UPN Change...." -ForegroundColor Yellow -BackgroundColor Blue 

    try {
        
        $currentupn = (Get-ADUser $item.name).userprincipalname

        Write-Host "User $($item.name) Existing UPN = $currentupn ...." -ForegroundColor Black -BackgroundColor White 
        
        set-aduser $item.name -UserPrincipalName $item.upn -Verbose
    
        $newupn = (Get-ADUser $item.name).userprincipalname

        Write-Host "New UPN of user $($item.name) is $($newupn)  ...." -ForegroundColor Green -BackgroundColor Red

    }
    catch {
        
        Write-Warning -Message "$Error[0].Exception.Message"
    }
    
}