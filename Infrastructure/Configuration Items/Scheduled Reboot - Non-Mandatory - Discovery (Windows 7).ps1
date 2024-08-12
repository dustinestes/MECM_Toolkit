#--------------------------------------------------------------------------------------------
# Input
#--------------------------------------------------------------------------------------------
#Region Input

    # Reboot Settings
        $Settings_CalculatedRebootTime_UTC = 0 # [int64]$(Get-Date ((Get-Date -Date "$(Get-Date -Format yyyy)-$(Get-Date -Format MM)-01T01:30:00").ToUniversalTime()) -Uformat %s)

    # Scheduled Task Data
        $Name_ScheduledTask = "CI - Scheduled Reboot - Weekly Sunday at 0130 (Local Time) - Non-Mandatory"
        $Path_ScheduledTask = "\VividRock\MECM Toolkit\Scheduled Reboots"

    [string]$XML_ScheduledTask_Content = @"
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Date>2024-08-05T10:00:00.000000</Date>
    <Author>VividRock</Author>
    <Description>A scheduled weekly reboot created and enforced by MECM and performed by the Scheduled Task service.</Description>
  </RegistrationInfo>
  <Triggers>
    <CalendarTrigger>
      <StartBoundary>2024-08-01T01:30:00</StartBoundary>
      <Enabled>true</Enabled>
      <ScheduleByWeek>
        <DaysOfWeek>
          <Sunday />
        </DaysOfWeek>
        <WeeksInterval>1</WeeksInterval>
      </ScheduleByWeek>
    </CalendarTrigger>
  </Triggers>
  <Principals>
    <Principal id="Author">
      <UserId>SYSTEM</UserId>
      <RunLevel>LeastPrivilege</RunLevel>
    </Principal>
  </Principals>
  <Settings>
    <MultipleInstancesPolicy>StopExisting</MultipleInstancesPolicy>
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
    <WakeToRun>true</WakeToRun>
    <ExecutionTimeLimit>PT1H</ExecutionTimeLimit>
    <Priority>7</Priority>
  </Settings>
  <Actions Context="Author">
    <Exec>
      <Command>Powershell.exe</Command>
      <Arguments>-NoProfile -NoLogo -WindowStyle Hidden -ExecutionPolicy Bypass -Command "&amp;amp;  New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Name 'RebootBy' -Value $($Settings_CalculatedRebootTime_UTC) -PropertyType QWord -Force -ErrorAction SilentlyContinue ; New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Name 'RebootValueInUTC' -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue ; New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Name 'NotifyUI' -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue ; New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Name 'HardReboot' -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue ; New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Name 'OverrideRebootWindowTime' -Value 0 -PropertyType QWord -Force -ErrorAction SilentlyContinue ; New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Name 'OverrideRebootWindow' -Value 0 -PropertyType DWord -Force -ErrorAction SilentlyContinue ; New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Name 'PreferredRebootWindowTypes' -Value @('') -PropertyType MultiString -Force -ErrorAction SilentlyContinue ; New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Name 'GraceStartTimeStamp' -Value '0' -PropertyType DWord -Force -ErrorAction SilentlyContinue ; New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Name 'GraceSeconds' -Value '0' -PropertyType DWord -Force -ErrorAction SilentlyContinue ; Restart-Service -Name 'CcmExec' "</Arguments>
    </Exec>
  </Actions>
</Task>
"@

    # Metadata
        $Meta_Discovery_Result      = $false
        $Meta_Discovery_Desired     = $true
        $Meta_Discovery_Actual      = $null

    # Logging
        $Path_Log_Directory = "$($env:vr_Directory_Logs)\ConfigurationBaselines\Discovery"
        $Name_Log_File      = $Name_ScheduledTask
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
Purpose:     Perform discovery of a Configuration Item and return boolean results.
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
# Discovery
#   Error Range: 1200 - 1299
#--------------------------------------------------------------------------------------------
#Region Discovery

# Test for Scheduled Task
    try {
        # Creat COM object
            $Object_Schedule = New-Object -ComObject Schedule.Service -ErrorAction Stop

        # Connect to COM object
            $Object_Schedule.connect()

        # Get parent folder information
            $Object_Schedule_FolderRoot = $Object_Schedule.GetFolder($Path_ScheduledTask)

        # Get Scheduled Task
            $Object_ScheduledTask_Existing = $Object_Schedule_FolderRoot.GetTask($Name_ScheduledTask)

        # Compare XML Configuration
            $XML_ScheduledTask_Actual   = ([xml]$Object_ScheduledTask_Existing.Xml).Task
            $XML_ScheduledTask_Desired  = ([xml]$XML_ScheduledTask_Content).Task

            if (
                $XML_ScheduledTask_Actual.Triggers.CalendarTrigger.StartBoundary -eq $XML_ScheduledTask_Desired.Triggers.CalendarTrigger.StartBoundary -and
                $XML_ScheduledTask_Actual.Triggers.CalendarTrigger.ScheduleByWeek.DaysOfWeek.ChildNodes.Name -eq $XML_ScheduledTask_Desired.Triggers.CalendarTrigger.ScheduleByWeek.DaysOfWeek.ChildNodes.Name -and
                $XML_ScheduledTask_Actual.Triggers.CalendarTrigger.ScheduleByWeek.WeeksInterval -eq $XML_ScheduledTask_Desired.Triggers.CalendarTrigger.ScheduleByWeek.WeeksInterval -and
                $XML_ScheduledTask_Actual.Principals.Principal.id -eq $XML_ScheduledTask_Desired.Principals.Principal.id -and
                $XML_ScheduledTask_Actual.Principals.Principal.RunLevel -eq $XML_ScheduledTask_Desired.Principals.Principal.RunLevel -and
                $XML_ScheduledTask_Actual.Principals.Principal.UserId -eq $XML_ScheduledTask_Desired.Principals.Principal.UserId -and
                $XML_ScheduledTask_Actual.Actions.Exec.Command -eq $XML_ScheduledTask_Desired.Actions.Exec.Command -and
                $XML_ScheduledTask_Actual.Actions.Exec.Arguments -eq $XML_ScheduledTask_Desired.Actions.Exec.Arguments
            ) {
                $Meta_Discovery_Result = $true
                $Temp_Log_Body    = @"

Success: Scheduled Task XML Matches

"@

                Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop
            }
            else {
                $Meta_Discovery_Result = $false
                $Temp_Log_Error    = @"

Warning: Scheduled Task XML Does Not Match

"@

                Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Error -Append -ErrorAction Stop
            }
    }
    catch [System.IO.DirectoryNotFoundException] {
        $Meta_Discovery_Result = $false
        $Temp_Log_Error    = @"

Warning: Task Folder Not Found

"@

        Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Error -Append -ErrorAction Stop
    }
    catch [System.IO.FileNotFoundException] {
        $Meta_Discovery_Result = $false
        $Temp_Log_Error    = @"

Warning: Scheduled Task Not Found

"@

        Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Error -Append -ErrorAction Stop
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

#EndRegion Discovery
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Output
#   Error Range: 1300 - 1399
#--------------------------------------------------------------------------------------------
#Region Output

# Write Log Footer
    try {
        $Temp_Log_Body    = @"

Task Name:   $($Name_ScheduledTask)

Desired State: $($Meta_Discovery_Desired)
Actual State: $([bool]$Meta_Discovery_Actual)

Discovery Result: $($Meta_Discovery_Result)

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
    Return $Meta_Discovery_Result

#EndRegion Output
#--------------------------------------------------------------------------------------------
