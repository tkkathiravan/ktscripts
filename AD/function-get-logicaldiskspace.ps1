
Function Get-A2BDrive {
    [cmdletbinding()]
    
    param (
        [Parameter (Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        
        $computername
    )

    $Driveinfo = Get-CimInstance Win32_logicaldisk -ComputerName $computername

     $Finaldata = [Ordered]@{ 
     
        Drivename = $Driveinfo.DeviceID;
        Volumename = $Driveinfo.VolumeName;
        VolumeSize = $Driveinfo.Size;
        VolumeFreespace = $Driveinfo.FreeSpace;
        ServerName = $computername;
     
       } 
    Write-Output  $finaldata
        
    }
    
   Get-A2BDrive -computername localhost
   
    
  Get-Content C:\temp\comp.txt | ForEach-Object{ Get-A2BDrive -computername $_ |Export-Csv -NoTypeInformation -Path c:\temp\testcsv.csv -Append}  