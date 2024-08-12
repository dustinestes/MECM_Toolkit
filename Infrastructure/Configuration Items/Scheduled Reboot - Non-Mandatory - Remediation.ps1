#--------------------------------------------------------------------------------------------
# Input
#--------------------------------------------------------------------------------------------
#Region Input
    # Environment Settings
        $Environment_Settings_DeleteOtherRebootSchedules = $true
        $Environment_Settings_DeleteOtherRebootSchedules_Pattern = "CI - Scheduled Reboot - *"

    # Reboot Settings
        $Reboot_Settings_TimeOfReboot       = "01:30"
        $Reboot_Settings_TimeOfReboot_DayOffset = "0"
            $Calculated_RebootTime_UTC      = "0"

    # Scheduled Task Data
        $ScheduledTask_Name                 = "CI - Scheduled Reboot - Weekly Sunday at 0130 (Local Time) - Non-Mandatory"
        $ScheduledTask_Author               = "VividRock"
        $ScheduledTask_Description          = "A scheduled weekly reboot created and enforced by MECM and performed by the Scheduled Task service."
        $ScheduledTask_Path                 = "\VividRock\MECM Toolkit\Scheduled Reboots"
        $ScheduledTask_Trigger_WeekInterval = "1"
        $ScheduledTask_Trigger_DaysOfWeek   = "Sunday"
        $ScheduledTask_Trigger_At           = Get-Date -Hour 01 -Minute 30 -Second 00 -Format "HH:mm:ss"
        $ScheduledTask_Trigger_Expiration   = (Get-Date).AddYears(10).ToString('s')
        $ScheduledTask_Action_Execute       = "Powershell.exe"
        $ScheduledTask_ScriptBlock_Expanded = " New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Name 'RebootBy' -Value $($Calculated_RebootTime_UTC) -PropertyType QWord -Force -ErrorAction SilentlyContinue ; New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Name 'RebootValueInUTC' -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue ; New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Name 'NotifyUI' -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue ; New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Name 'HardReboot' -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue ; New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Name 'OverrideRebootWindowTime' -Value 0 -PropertyType QWord -Force -ErrorAction SilentlyContinue ; New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Name 'OverrideRebootWindow' -Value 0 -PropertyType DWord -Force -ErrorAction SilentlyContinue ; New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Name 'PreferredRebootWindowTypes' -Value @('') -PropertyType MultiString -Force -ErrorAction SilentlyContinue ; New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Name 'GraceStartTimeStamp' -Value '0' -PropertyType DWord -Force -ErrorAction SilentlyContinue ; New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Name 'GraceSeconds' -Value '0' -PropertyType DWord -Force -ErrorAction SilentlyContinue ; Restart-Service -Name 'CcmExec' "
            $ScheduledTask_ScriptBlock = [scriptblock]::Create($ScheduledTask_ScriptBlock_Expanded)
        $ScheduledTask_Action_Argument      = "-NoProfile -NoLogo -WindowStyle Hidden -ExecutionPolicy Bypass -Command $([char](34) + "& " + $ScheduledTask_ScriptBlock + [char](34))"
        # $ScheduledTask_Action_WorkingDir    = ""

    # Metadata
        $Meta_Remediation_Result    = $false

    # Logging
        $Path_Log_Directory = "$($env:vr_Directory_Logs)\ConfigurationBaselines\Remediation"
        $Name_Log_File      = $ScheduledTask_Name
        $Path_Log_File      = $Path_Log_Directory + "\" + $ScheduledTask_Name + ".log"

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
        if ($Environment_Settings_DeleteOtherRebootSchedules -eq $false) {
            $Temp_Log_Body    = @"

  Cleanup Existing Reboot Tasks: Disabled
  Status: Skipped

-----------------------------------------------------------------------------------
"@

            Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop
        }
        else {
            try {
                # Get Matching Scheduled Tasks
                    $Temp_ScheduledTasks_Existing = Get-ScheduledTask -TaskPath "$ScheduledTask_Path\*" | Where-Object -Property TaskName -like $Environment_Settings_DeleteOtherRebootSchedules_Pattern -ErrorAction Stop

                    if (($Temp_ScheduledTasks_Existing | Measure-Object).Count -in "",$null,"0") {
                        $Temp_Log_Body    = @"

  Cleanup Existing Reboot Tasks: Enabled
  Count: $(($Temp_ScheduledTasks_Existing | Measure-Object).Count)
  Status: Not Applicable

-----------------------------------------------------------------------------------
"@

                        Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop
                    }
                    else {
                        $Temp_Log_Body    = @"
  Cleanup Existing Reboot Tasks: Enabled
  Count: $(($Temp_ScheduledTasks_Existing | Measure-Object).Count)

"@

                        Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop

                        foreach ($Item in $Temp_ScheduledTasks_Existing) {
                            Unregister-ScheduledTask -TaskName $Item.TaskName -TaskPath $Item.TaskPath -Confirm:$false -ErrorAction Stop

                            $Temp_Log_Body    = @"
  Task Name: $($Item.TaskName)
  Task Path: $($item.TaskPath)
  Status: Deleted

"@

                            Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop
                        }
                    }
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
            # Create Trigger
                $Object_Task_Trigger = New-ScheduledTaskTrigger -Weekly -WeeksInterval $ScheduledTask_Trigger_WeekInterval -DaysOfWeek $ScheduledTask_Trigger_DaysOfWeek -At $ScheduledTask_Trigger_At -ErrorAction Stop
                if ($ScheduledTask_Trigger_Expiration -notin "",$null) {
                    $Object_Task_Trigger.EndBoundary = $ScheduledTask_Trigger_Expiration
                }

            # Create Action
                $Object_Task_Action = New-ScheduledTaskAction -Execute $ScheduledTask_Action_Execute -Argument $ScheduledTask_Action_Argument -ErrorAction Stop # -WorkingDirectory $ScheduledTask_Action_WorkingDir

            # Configure Task Settings
                # $Object_Task_Principal = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel Limited
                $Object_Task_Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DeleteExpiredTaskAfter (New-TimeSpan -Days 30) -DontStopIfGoingOnBatteries -DontStopOnIdleEnd -ExecutionTimeLimit (New-TimeSpan -Minutes 30) -MultipleInstances IgnoreNew -WakeToRun -ErrorAction Stop

            # Create the Scheduled Task
                # Creat COM object
                    $Object_Schedule = New-Object -ComObject Schedule.Service -ErrorAction Stop

                # Connect to COM object
                    $Object_Schedule.connect()

                # Get parent folder information
                    $TaskScheduler_Folder_Root = $Object_Schedule.GetFolder("\")

                # Check if the folder exists and if not then create the new folder
                    try {
                        $Object_Schedule.GetFolder($ScheduledTask_Path)
                    }
                    catch {
                        [void]$TaskScheduler_Folder_Root.CreateFolder($ScheduledTask_Path)
                    }

                $Object_ScheduledTask = New-ScheduledTask -Description $ScheduledTask_Description -Action $Object_Task_Action -Trigger $Object_Task_Trigger -Settings $Object_Task_Settings -ErrorAction Stop # -Principal $Object_Task_Principal
                $Object_ScheduledTask.Author = $ScheduledTask_Author
                Register-ScheduledTask -TaskName $ScheduledTask_Name -InputObject $Object_ScheduledTask -User "System" -TaskPath $ScheduledTask_Path -ErrorAction Stop | Out-Null

            # Check for Newly Created Task
                $Temp_ScheduledTasks_Existing_Result = [bool](Get-ScheduledTask -TaskPath "$ScheduledTask_Path\*" | Where-Object -Property TaskName -like $ScheduledTask_Name -ErrorAction Stop)

                if ($Temp_ScheduledTasks_Existing_Result -eq $true) {
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
-----------------------------------------------------------------------------------

  Name: $($ScheduledTask_Name)
  Author: $($ScheduledTask_Author)
  Description: $($ScheduledTask_Description)
  Path: $($ScheduledTask_Path)
  Week Interval: $($ScheduledTask_Trigger_WeekInterval)
  Days of Week: $($ScheduledTask_Trigger_DaysOfWeek)
  Time of Day: $($ScheduledTask_Trigger_At)
  Expiration: $($ScheduledTask_Trigger_Expiration)
  Execute: $($ScheduledTask_Action_Execute)
  Argument: $($ScheduledTask_Action_Argument)

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
