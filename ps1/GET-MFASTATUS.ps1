#A2B GET-MFASTATUS

Get-MsolUser -All | `
Select-Object displayname, islicensed, userprincipalname, usertype,usagelocation,passwordneverexpires, `
@{L="MFAStatusEnabled";e={if($_.StrongAuthenticationMethods){$true} Else {$false}}}, `
@{L="MFAMethodType1";e={IF($_.StrongAuthenticationUserDetails.email) {$_.StrongAuthenticationUserDetails.email} `
Elseif ($_.StrongAuthenticationUserDetails.Phonenumber){$_.StrongAuthenticationUserDetails.Phonenumber} `
Else {$false}}}, `
@{L="MFAMethodType2";e={IF($_.StrongAuthenticationPhoneAppDetails.AuthenticationType) {$_.StrongAuthenticationPhoneAppDetails.AuthenticationType} Else {$False}}}, `
@{L="MFAEnforced-Status";e={IF($_.StrongAuthenticationRequirements.state) {$_.StrongAuthenticationRequirements.state} Else {$false}}} | `
Export-Csv -NoTypeInformation -Append -Path 'C:\Users\kathiravan.thanappan\OneDrive - A2B Australia\A2B\Script_out\AzureAd_users_withMFA_Status_March23.csv'