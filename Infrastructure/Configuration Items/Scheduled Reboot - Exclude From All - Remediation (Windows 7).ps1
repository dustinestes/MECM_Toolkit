#--------------------------------------------------------------------------------------------
# Input
#--------------------------------------------------------------------------------------------
#Region Input

    # Environment Settings
        $Settings_DeleteOtherRebootSchedules = $true
        $Settings_DeleteOtherRebootSchedules_Pattern = "CI - Scheduled Reboot - *"


    # Scheduled Task Data
        $Path_ScheduledTask = "\VividRock\MECM Toolkit\Scheduled Reboots"

    # Metadata
        $Meta_Remediation_Result    = $false

    # Logging
        $Path_Log_Directory = "$($env:vr_Directory_Logs)\ConfigurationBaselines\Remediation"
        $Name_Log_File      = "CI - Scheduled Reboot - Exclude From All"
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

    # Check for Tasks
        $Object_ScheduledTask_Existing_Result = $Object_Schedule_FolderRoot.GetTasks(0) | Where-Object -Property Name -like $Settings_DeleteOtherRebootSchedules_Pattern -ErrorAction Stop

        if ($Object_ScheduledTask_Existing_Result -notin "",$null) {
            $Meta_Remediation_Result = "Failure"
        }
        else {
            $Meta_Remediation_Result = "Success"
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
