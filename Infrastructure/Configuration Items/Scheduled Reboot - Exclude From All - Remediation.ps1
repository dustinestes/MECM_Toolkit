#--------------------------------------------------------------------------------------------
# Input
#--------------------------------------------------------------------------------------------
#Region Input
    # Cleanup Settings
        $Cleanup_RebootSchedules_Pattern = "CI - Scheduled Reboot - *"
        $Cleanup_ScheduledTask_Path = "\VividRock\MECM Toolkit\Scheduled Reboots"

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



#EndRegion Environment
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Remediation
#   Error Range: 1200 - 1299
#--------------------------------------------------------------------------------------------
#Region Remediation

    # Cleanup Existing Reboot Schedules
        try {
            # Get Matching Scheduled Tasks
                $Temp_ScheduledTasks_Existing = Get-ScheduledTask -TaskPath "$Cleanup_ScheduledTask_Path\*" | Where-Object -Property TaskName -like $Cleanup_RebootSchedules_Pattern -ErrorAction Stop

                if (($Temp_ScheduledTasks_Existing | Measure-Object).Count -in "",$null,"0") {
                    $Temp_Log_Body    = @"

  Cleanup Existing Reboot Tasks: Enabled
  Count: $(($Temp_ScheduledTasks_Existing | Measure-Object).Count)
  Status: Not Applicable

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

  Error ID: 1201
  Command:  $($PSItem.CategoryInfo.Activity)
  Message:  $($PSItem.Exception.Message)

-----------------------------------------------------------------------------------
"@

            Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Error -Append -ErrorAction Stop
            Exit 1201
        }

    # Check to Ensure Scheduled Tasks Were Removed
        try {
            $Temp_ScheduledTasks_Existing_Result = [bool](Get-ScheduledTask -TaskPath "$ScheduledTask_Path\*" | Where-Object -Property TaskName -like $Cleanup_RebootSchedules_Pattern -ErrorAction Stop)

            if ($Temp_ScheduledTasks_Existing_Result -eq $false) {
                $Meta_Remediation_Result = "Success"
            }
            else {
                $Meta_Remediation_Result = "Failure"
            }
        }
        catch {
            $Temp_Log_Error    = @"

  Error ID: 1202
  Command:  $($PSItem.CategoryInfo.Activity)
  Message:  $($PSItem.Exception.Message)

-----------------------------------------------------------------------------------
"@

            Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Error -Append -ErrorAction Stop
            Exit 1202
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
