#--------------------------------------------------------------------------------------------
# Input
#--------------------------------------------------------------------------------------------
#Region Input

    # Scheduled Task Data
        $Name_ScheduledTask = "CI - Scheduled Reboot - Weekly Sunday at 0130 (Local Time) - Mandatory"
        $Path_ScheduledTask = "\VividRock\MECM Toolkit\Scheduled Reboots"

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
  Date:        February 17, 2024
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
            $Meta_Discovery_Actual = [bool](Get-ScheduledTask -TaskPath "$($Path_ScheduledTask)\*" | Where-Object -Property TaskName -like $Name_ScheduledTask -ErrorAction Stop)

            if ($Meta_Discovery_Actual -eq $Meta_Discovery_Desired) {
                $Meta_Discovery_Result = $true
            }
            else {
                $Meta_Discovery_Result = $false
            }
        }
        catch [Microsoft.PowerShell.Cmdletization.Cim.CimJobException] {
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
