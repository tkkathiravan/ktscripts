
#Function to select a subscription to work with when working woth azure

$String = Get-Content -Path c:\temp\text.txt
$PW = ConvertTo-SecureString -String $String -AsPlainText -Force
$UN = "kathiravan.thanappan@a2baustralia.com"

$Creds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $UN, $PW

Connect-AzAccount -Credential $Creds

Function Select-A2Bsubscription {
    
    Param ([string]$TenantENV
        )

   $Subscriptions = Get-AzSubscription    
   
switch ($TenantENV)
   {
     'PROD' {Select-AzSubscription -Subscription $Subscriptions.name[0] -Force}
     'TEST' {Select-AzSubscription -Subscription $Subscriptions.name[1] -Force}
     'DEV' {Select-AzSubscription -Subscription $Subscriptions.name[2] -Force}
     Default {Select-AzSubscription -Subscription $Subscriptions.name[0] -Force}
   }

            
        }
Select-A2Bsubscription -TenantENV dev

