 
# #########################################################################################
# NAME: Monitor-ADPrivileged-Group-Membership-changes.ps1
#
# MODIFIED BY: KT
#  
# COMMENT:  This script is monitoring group(s) in Active Directory and send an email when
#     someone is added or removed 
# 
# REQUIRES:  
#  -A Scheduled Task 
# NOTES: The output file of the group memebership is saved to the drive from where the
#    script is triggered.
# 
# VERSION HISTORY 
# 1.0.29.06.2022 Initial Version. Modified from Quest ADsnapin to use Current powershell
# 
# #########################################################################################
   
 
BEGIN {
    TRY {
        # Monitor the following groups 
        $Groups = "Domain Admins", "Enterprise Admins", "Administrators"
 
        # The report is saved locally 
        #$ScriptPath = (Split-Path ((Get-Variable MyInvocation).Value).MyCommand.Path) 
        #$DateFormat = Get-Date -Format "yyyyMMdd_HHmmss"
 
        # Email information
        $Emailfrom = "corpdc@13cabs.com.au"
        $Emailto = "kathiravan.thanappan@13cabs.com.au"
        $EmailServer = "RELAY.13CABS.com.au"
   
        # Quest Active Directory Snapin 
        #if (!(Get-PSSnapin Quest.ActiveRoles.ADManagement -ErrorAction Silentlycontinue)) 
        #{Add-PSSnapin Quest.ActiveRoles.ADManagement}
    }
    CATCH { Write-Warning "BEGIN BLOCK - Something went wrong" }
}
 
PROCESS {
 
    TRY {
        FOREACH ($item in $Groups) {
 
            # Let's get the Current Membership
            $GroupName = Get-adgroup $item -Properties *
            $Members = Get-ADGroupMember $item -Recursive | Select-Object Name, SamAccountName, Distinguishedname 
            $EmailSubject = "SOC MONITORING - $GroupName Membership Change"
            $Domain = ($GroupName).CanonicalName.Split('.')[0]
            
            # Store the group membership in this file 
            $StateFile = "$($Domain)_$($GroupName.name)-membership.csv"
    
            # If the file doesn't exist, create one
            If (!(Test-Path $StateFile)) {  
                $Members | Export-csv $StateFile -NoTypeInformation
            }
    
            # Now get current membership and start comparing it to the last lot we recorded 
            # catching changes to membership (additions / removals) 
            $Changes = Compare-Object $Members $(Import-Csv $StateFile) -Property Name, SamAccountName, Distinguishedname | 
            Select-Object Name, SamAccountName, Distinguishedname,
            @{n = 'State'; e = {
                    If ($_.SideIndicator -eq "=>") {
                        "Removed" 
                    }
                    Else { "Added" }
                }
            }
   
            # If difference in group membership, mail them to $Email 
            If ($Changes) {  
                $body = $($Changes | Format-List | Out-String) 
                $smtp = new-object Net.Mail.SmtpClient($EmailServer) 
                $smtp.Send($emailFrom, $emailTo, $EmailSubject, $body) 
            } 
            #Save current state of the group membership to the csv file
            $Members | Export-csv $StateFile -NoTypeInformation -Encoding Unicode
        }
    }
    CATCH { Write-Warning "PROCESS BLOCK - Something went wrong" }
 
}#PROCESS
END { "Script Completed" }
 
#end region script