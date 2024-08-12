#--------------------------------------------------------------------------------------------
# Input
#--------------------------------------------------------------------------------------------
#Region Input

    # Scheduled Task Data
        $Name_ScheduledTask             = "IIS-AutoCertRebind"
        $Path_ScheduledTask             = "\Microsoft\Windows\CertificateServicesClient\"
        $Property_ScheduledTask_Author  = "VividRock"
        [string]$XML_ScheduledTask_CertificateRebind = @'
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <URI>\Microsoft\Windows\CertificateServicesClient\IIS-AutoCertRebind</URI>
  </RegistrationInfo>
  <Triggers>
    <EventTrigger>
      <Enabled>true</Enabled>
      <Subscription>&lt;QueryList&gt;&lt;Query Id='0'&gt;&lt;Select Path='Microsoft-Windows-CertificateServicesClient-Lifecycle-System/Operational'&gt;*[System[EventID=1001]]&lt;/Select&gt;&lt;/Query&gt;&lt;/QueryList&gt;</Subscription>
      <ValueQueries>
        <Value name="NewCertHash">Event/UserData/CertNotificationData/NewCertificateDetails/@Thumbprint</Value>
        <Value name="OldCertHash">Event/UserData/CertNotificationData/OldCertificateDetails/@Thumbprint</Value>
      </ValueQueries>
    </EventTrigger>
  </Triggers>
  <Principals>
    <Principal id="System">
      <UserId>S-1-5-18</UserId>
      <RunLevel>HighestAvailable</RunLevel>
      <LogonType>InteractiveToken</LogonType>
    </Principal>
  </Principals>
  <Settings>
    <MultipleInstancesPolicy>Queue</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>true</StopIfGoingOnBatteries>
    <AllowHardTerminate>true</AllowHardTerminate>
    <StartWhenAvailable>false</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
    <IdleSettings>
      <StopOnIdleEnd>true</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Enabled>true</Enabled>
    <Hidden>false</Hidden>
    <RunOnlyIfIdle>false</RunOnlyIfIdle>
    <WakeToRun>false</WakeToRun>
    <ExecutionTimeLimit>PT1H</ExecutionTimeLimit>
    <Priority>7</Priority>
    <RestartOnFailure>
      <Interval>PT10M</Interval>
      <Count>3</Count>
    </RestartOnFailure>
  </Settings>
  <Actions Context="System">
    <Exec>
      <Command>%SystemRoot%\System32\inetsrv\appcmd.exe</Command>
      <Arguments>renew binding /oldcert:$(OldCertHash) /newcert:$(NewCertHash)</Arguments>
    </Exec>
  </Actions>
</Task>
'@

    # Metadata
        $Meta_Remediation_Result    = $false

    # Logging
        $Path_Log_Directory = "$($env:vr_Directory_Logs)\ConfigurationBaselines\Remediation"
        $Name_Log_File      = "CI - IIS - Certificate Rebind Enabled"
        $Path_Log_File      = $Path_Log_Directory + "\" + $Name_Log_File + ".log"

#EndRegion Input
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

    # Write Log Header
        $Temp_Log_Header    = @"
-----------------------------------------------------------------------------------
  $($Name_Log_File)
-----------------------------------------------------------------------------------
  Author:      Dustin Estes
  Company:     VividRock
  Date:        February 03, 2024
  Copyright:   VividRock LLC - All Rights Reserved
  Purpose:     Perform remediation of a Configuration Item and return boolean results.
-----------------------------------------------------------------------------------
  Script Name: $($MyInvocation.MyCommand.Name)
  Script Path: $($PSScriptRoot)
  Executed:    $((Get-Date).ToUniversalTime().ToString("yyyy-MM-dd HH:mm:ss"))
-----------------------------------------------------------------------------------

"@

        Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Header -ErrorAction Stop

#EndRegion Header
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Environment
#   Error Range: 1100 - 1199
#--------------------------------------------------------------------------------------------
#Region Environment

    # Test for Existence
        try {
            $Temp_ScheduledTask_PreExisting = Get-ScheduledTask -TaskPath $Path_ScheduledTask -TaskName $Name_ScheduledTask -ErrorAction Stop
        }
        catch [Microsoft.PowerShell.Cmdletization.Cim.CimJobException] {
            # Do Nothing
        }
        catch {
            $Temp_Log_Error    = @"

  Error ID: 1101
  Command:  $($PSItem.CategoryInfo.Activity)
  Message:  $($PSItem.Exception.Message)

-----------------------------------------------------------------------------------
"@

            Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Error -Append -ErrorAction Stop
            Exit 1101
    }

#EndRegion Environment
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Remediation
#   Error Range: 1200 - 1299
#--------------------------------------------------------------------------------------------
#Region Remediation

    # Create Scheduled Task
        try {
            if ($Temp_ScheduledTask_PreExisting.Settings.Enabled -eq $false) {
                Enable-ScheduledTask -TaskPath $Path_ScheduledTask -TaskName $Name_ScheduledTask -ErrorAction Stop | Out-Null

                $Temp_Log_Body    = @"

  Exists: $([bool]$Temp_ScheduledTask_PreExisting)
  Enabled: $($Temp_ScheduledTask_PreExisting.Settings.Enabled)

  Status: Enabled Scheduled Task

-----------------------------------------------------------------------------------
"@

                Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop
            }
            else {
                # Create Task
                    $Temp_ScheduledTask_Result = Register-ScheduledTask -TaskPath $Path_ScheduledTask -TaskName $Name_ScheduledTask -Xml $XML_ScheduledTask_CertificateRebind -ErrorAction Stop

                # Set Author of Task
                    $Temp_ScheduledTask_Modify = Get-ScheduledTask -TaskPath $Path_ScheduledTask -TaskName $Name_ScheduledTask -ErrorAction Stop
                    $Temp_ScheduledTask_Modify.Author = $Property_ScheduledTask_Author
                    $Temp_ScheduledTask_Modify | Set-ScheduledTask -ErrorAction Stop

                $Temp_Log_Body    = @"

  Name: $($Temp_ScheduledTask_Result.TaskName)
  Path: $($Temp_ScheduledTask_Result.TaskPath)
  Author: $($Temp_ScheduledTask_Modify.Author)
  State: $($Temp_ScheduledTask_Result.State)

-----------------------------------------------------------------------------------
"@

                Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop
            }

            # Check for Task
                $Temp_ScheduledTask_Validation = Get-ScheduledTask -TaskPath $Path_ScheduledTask -TaskName $Name_ScheduledTask -ErrorAction Stop

                if (([bool]$Temp_ScheduledTask_Validation -eq $true) -and ($Temp_ScheduledTask_Validation.Settings.Enabled -eq $true)) {
                    $Meta_Remediation_Result = "Success"
                }
                else {
                    $Meta_Remediation_Result = "Failure"
                }
        }
        catch {
            $Temp_Log_Error    = @"

  Error ID: 1201
  Command:  $($PSItem.CategoryInfo.Activity)
  Message:  $($PSItem.Exception.Message)

-----------------------------------------------------------------------------------
"@

            Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Error -Append -ErrorAction Stop
            Exit 1201
        }

#EndRegion Remediation
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Output
#   Error Range: 1300 - 1399
#--------------------------------------------------------------------------------------------
#Region Output

    # Write Log Footer
        try {
            $Temp_Log_Body    = @"

  Remediation Result: $($Meta_Remediation_Result)

-----------------------------------------------------------------------------------
"@

            Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop
        }
        catch {
            $Temp_Log_Error    = @"

  Error ID: 1301
  Command:  $($PSItem.CategoryInfo.Activity)
  Message:  $($PSItem.Exception.Message)

-----------------------------------------------------------------------------------
"@

            Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Error -Append -ErrorAction Stop
            Exit 1301
        }

    # Return Value to MECM
        if ($Meta_Remediation_Result -eq "Success") {
            Exit 0
        }
        else {
            Exit 2000
        }

#EndRegion Output
#--------------------------------------------------------------------------------------------
