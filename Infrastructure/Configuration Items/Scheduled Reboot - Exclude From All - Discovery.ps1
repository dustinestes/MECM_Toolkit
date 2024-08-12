#--------------------------------------------------------------------------------------------
# Input
#--------------------------------------------------------------------------------------------
#Region Input

    # Cleanup Settings
        $Cleanup_RebootSchedules_Pattern = "CI - Scheduled Reboot - *"
        $Cleanup_ScheduledTask_Path = "\VividRock\MECM Toolkit\Scheduled Reboots"

    # Metadata
        $Meta_Discovery_Result      = $null
        $Meta_Discovery_Desired     = 0

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
            # Get Scheduled Task Objects
                $Temp_ScheduledTasks_Existing = Get-ScheduledTask -TaskPath "$Cleanup_ScheduledTask_Path\*" | Where-Object -Property TaskName -like $Cleanup_RebootSchedules_Pattern -ErrorAction Stop

            # Output Found Task Sequences
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
                        $Temp_Log_Body    = @"

  Task Name: $($Item.TaskName)
  Task Path: $($item.TaskPath)

"@

                        Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop
                    }
                }

            # Set Discovery Output
                if (($Temp_ScheduledTasks_Existing | Measure-Object).Count -eq $Meta_Discovery_Desired) {
                    $Meta_Discovery_Result = $true
                }
                else {
                    $Meta_Discovery_Result = $false
                }
        }
        catch [Microsoft.PowerShell.Cmdletization.Cim.CimJobException] {
            $Temp_Log_Error    = @"

  No Scheduled Tasks Found

"@

            Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Error -Append -ErrorAction Stop
            $Meta_Discovery_Result = $true
        }
        catch {
            $Temp_Log_Error    = @"

  Error ID: 1201
  Command:  $($PSItem.CategoryInfo.Activity)
  Message:  $($PSItem.Exception.Message)

-----------------------------------------------------------------------------------
"@

            Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Error -Append -ErrorAction Stop
            Exit 1301
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
-----------------------------------------------------------------------------------

  Desired State: $($Meta_Discovery_Desired)
  Actual State: $(($Temp_ScheduledTasks_Existing | Measure-Object).Count)

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
