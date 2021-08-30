$starttime = "{0:G}" -f (Get-Date)

Write-Host -ForegroundColor White -BackgroundColor DarkRed "starting script - $($startTime)"

$csimport = Import-Csv '.\Security_Operations\Falcon\Files from portal\offlinehosts.csv'

foreach ($ip in $csimport) {


    Write-Host -ForegroundColor Yellow "Checking status of host $($ip.hostname)"
    
    IF((Test-Connection -ComputerName $ip.localip -Count 2 -Quiet -ErrorAction SilentlyContinue) -eq $true) {
    
        Write-Host -ForegroundColor Green "Host $($ip.hostname) with $($ip.localip) is online"

        Add-Content -Path .\Script_out\offlinehostsstatus.txt -Value "$($ip.hostname) with $($ip.localip) is online" 
    
        }

        ELSE {
        
        Write-Host -ForegroundColor Red "Host $($ip.hostname) with $($ip.localip) is offline"

        Add-Content -Path .\Script_out\offlinehostsstatus.txt -Value "$($ip.hostname) with $($ip.localip) is offine"
        }
    
     }  
     
      Write-Host "The script finished running"
$endtime = "{0:G}" -f (Get-Date)
Write-Host "Script finished at: $($endtime)"
Write-Host "Time elapsed: $(New-Timespan $startTime $endtime)" -ForegroundColor White -BackgroundColor DarkRed
 