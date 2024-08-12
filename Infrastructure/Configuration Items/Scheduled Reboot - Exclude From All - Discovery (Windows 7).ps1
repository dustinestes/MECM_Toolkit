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
        $Meta_Discovery_Result      = $false
        $Meta_Discovery_Desired     = $true
        $Meta_Discovery_Actual      = $null

    # Logging
        $Path_Log_Directory = "$($env:vr_Directory_Logs)\ConfigurationBaselines\Discovery"
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

        # Get Scheduled Tasks
            $Object_ScheduledTask_Cleanup = $Object_Schedule_FolderRoot.GetTasks(0) | Where-Object -Property Name -like $Settings_DeleteOtherRebootSchedules_Pattern -ErrorAction Stop

            if (($Object_ScheduledTask_Cleanup | Measure-Object).Count -in "",$null,"0") {
                $Meta_Discovery_Result = $true
                $Temp_Log_Body    = @"

Cleanup Existing Reboot Tasks: Enabled
Count: $(($Object_ScheduledTask_Cleanup | Measure-Object).Count)
Status: Not Applicable

-----------------------------------------------------------------------------------
"@

                Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop
            }
            else {
                $Meta_Discovery_Result = $false
                $Temp_Log_Body    = @"
Cleanup Existing Reboot Tasks: Enabled
Count: $(($Object_ScheduledTask_Cleanup | Measure-Object).Count)

-----------------------------------------------------------------------------------
"@

                Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop

                foreach ($Item in $Object_ScheduledTask_Cleanup) {
                    $Temp_Log_Body    = @"
Task Name: $($Item.Name)
Task Path: $($item.Path)
Status: Found

-----------------------------------------------------------------------------------
"@

                    Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop
                }
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