#--------------------------------------------------------------------------------------------
# Input
#--------------------------------------------------------------------------------------------
#Region Input
    # Environment Settings
        $Settings_DeleteOtherRebootSchedules = $true
        $Settings_DeleteOtherRebootSchedules_Pattern = "CI - Scheduled Reboot - *"

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
        $Meta_Remediation_Result    = $false

    # Logging
        $Path_Log_Directory = "$($env:vr_Directory_Logs)\ConfigurationBaselines\Remediation"
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

    # Cleanup Other Reboot Schedules
        if ($Settings_DeleteOtherRebootSchedules -eq $false) {
            $Temp_Log_Body    = @"

Cleanup Existing Reboot Tasks: Disabled
Status: Skipped

-----------------------------------------------------------------------------------
"@

            Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop
        }
        else {
            try {
                # Creat COM Object
                    $Object_Schedule = New-Object -ComObject Schedule.Service -ErrorAction Stop

                # Connect to COM Object
                    $Object_Schedule.connect()

                # Get Folder Object
                    $Object_Schedule_FolderRoot = $Object_Schedule.GetFolder($Path_ScheduledTask)

                # Get Scheduled Tasks
                    $Object_ScheduledTask_Cleanup = $Object_Schedule_FolderRoot.GetTasks(0) | Where-Object -Property Name -like $Settings_DeleteOtherRebootSchedules_Pattern -ErrorAction Stop

                if (($Object_ScheduledTask_Cleanup | Measure-Object).Count -in "",$null,"0") {
                    $Temp_Log_Body    = @"

Cleanup Existing Reboot Tasks: Enabled
Count: $(($Object_ScheduledTask_Cleanup | Measure-Object).Count)
Status: Not Applicable

-----------------------------------------------------------------------------------
"@

                    Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop
                }
                else {
                    $Temp_Log_Body    = @"
Cleanup Existing Reboot Tasks: Enabled
Count: $(($Object_ScheduledTask_Cleanup | Measure-Object).Count)

-----------------------------------------------------------------------------------
"@

                    Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop

                    foreach ($Item in $Object_ScheduledTask_Cleanup) {
                        $Object_Schedule_FolderRoot.DeleteTask("$($Item.Name)",0)

                        $Temp_Log_Body    = @"
Task Name: $($Item.Name)
Task Path: $($item.Path)
Status: Deleted

-----------------------------------------------------------------------------------
"@

                        Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop
                    }
                }
        }
        catch [System.IO.DirectoryNotFoundException] {
            $Temp_Log_Error    = @"

Warning: Task Folder Not Found

-----------------------------------------------------------------------------------
"@

            Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Error -Append -ErrorAction Stop
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
            # Check if Folder Existss
                try {
                    $Object_Schedule.GetFolder($Path_ScheduledTask)
                }
                catch {
                    $Object_Schedule_FolderParent = $Object_Schedule.GetFolder("\")
                    $Object_Schedule_FolderParent.CreateFolder($Path_ScheduledTask)
                }

            # Create Task
                $Object_Schedule_FolderRoot = $Object_Schedule.GetFolder($Path_ScheduledTask)
                $Object_Schedule_FolderRoot.RegisterTask($Name_ScheduledTask,$XML_ScheduledTask_Content,2,"SYSTEM",$null,5,$null)

            # Check for Newly Created Task
                $Object_ScheduledTask_Existing_Result = $Object_Schedule_FolderRoot.GetTasks(0) | Where-Object -Property Name -eq $Name_ScheduledTask -ErrorAction Stop

                if ($Object_ScheduledTask_Existing_Result -notin "",$null) {
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
            $Temp_XML = ([xml]$Object_ScheduledTask_Existing_Result.XML).Task
            $Temp_Log_Body    = @"

Name: $($Name_ScheduledTask)
Author: $($Temp_XML.RegistrationInfo.Author)
Description: $($Temp_XML.RegistrationInfo.Description)
Path: $($Path_ScheduledTask)
Week Interval: $($Temp_XML.Triggers.CalendarTrigger.ScheduleByWeek.WeeksInterval)
Days of Week: $($Temp_XML.Triggers.CalendarTrigger.ScheduleByWeek.DaysOfWeek.ChildNodes.Name)
Time of Day: $($Temp_XML.Triggers.CalendarTrigger.StartBoundary)
Execute: $($Temp_XML.Actions.Exec.Command)
Argument: $($Temp_XML.Actions.Exec.Arguments)

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
