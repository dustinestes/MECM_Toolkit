#--------------------------------------------------------------------------------------------
# Input
#--------------------------------------------------------------------------------------------
#Region Input

    # BitLocker Management Data
        $Registry_BitLocker_01 = @{
            "Path"          = "HKCR:\Drive\shell\change-passphrase"
            "Name"          = "ProgrammaticAccessOnly"
            "ErrorAction"   = "Stop"
        }

        $Registry_BitLocker_02 = @{
            "Path"          = "HKCR:\Drive\shell\change-pin"
            "Name"          = "ProgrammaticAccessOnly"
            "ErrorAction"   = "Stop"
        }

        $Registry_BitLocker_03 = @{
            "Path"          = "HKCR:\Drive\shell\encrypt-bde"
            "Name"          = "ProgrammaticAccessOnly"
            "ErrorAction"   = "Stop"
        }

        $Registry_BitLocker_04 = @{
            "Path"          = "HKCR:\Drive\shell\encrypt-bde-elev"
            "Name"          = "ProgrammaticAccessOnly"
            "ErrorAction"   = "Stop"
        }

        $Registry_BitLocker_05 = @{
            "Path"          = "HKCR:\Drive\shell\manage-bde"
            "Name"          = "ProgrammaticAccessOnly"
            "ErrorAction"   = "Stop"
        }

        $Registry_BitLocker_06 = @{
            "Path"          = "HKCR:\Drive\shell\manage-bde-elev"
            "Name"          = "ProgrammaticAccessOnly"
            "ErrorAction"   = "Stop"
        }

        $Registry_BitLocker_07 = @{
            "Path"          = "HKCR:\Drive\shell\resume-bde"
            "Name"          = "ProgrammaticAccessOnly"
            "ErrorAction"   = "Stop"
        }

        $Registry_BitLocker_08 = @{
            "Path"          = "HKCR:\Drive\shell\resume-bde-elev"
            "Name"          = "ProgrammaticAccessOnly"
            "Value"         = ""
            "ErrorAction"   = "Stop"
        }

        $Registry_BitLocker_09 = @{
            "Path"          = "HKCR:\Drive\shell\unlock-bde"
            "Name"          = "ProgrammaticAccessOnly"
            "Value"         = ""
            "ErrorAction"   = "Stop"
        }

    # Metadata
        $Meta_Discovery_Result                  = $false
        $Meta_Discovery_Desired                 = $true
        $Meta_Discovery_Actual                  = $null
        $Meta_Discovery_Actual_Found_Count      = 0
        $Meta_Discovery_Actual_Failure_Count    = 0

    # Logging
        $Path_Log_Directory = "$($env:vr_Directory_Logs)\ConfigurationBaselines\Discovery"
        $Name_Log_File      = "CI - BitLocker Management - Retail Context Menu Entries - Show"
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
  Date:        April 01, 2024
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
# Environment
#   Error Range: 1100 - 1199
#--------------------------------------------------------------------------------------------
#Region Environment

    # Create Drive for Registry Access
        try {
            if ((Test-Path -Path "HKCR:\" -ErrorAction Stop) -eq $false) {
                New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT -ErrorAction Stop | Out-Null
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

#EndRegion Environment
#--------------------------------------------------------------------------------------------



#--------------------------------------------------------------------------------------------
# Discovery
#   Error Range: 1200 - 1299
#--------------------------------------------------------------------------------------------
#Region Discovery

    # Get All Defined Variables
        try {
            $Temp_Registry_Entries = Get-Variable -Name "Registry_BitLocker_*" -ErrorAction Stop
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

    # Loop Through All Variables
        foreach ($Item in $Temp_Registry_Entries) {

            try {
                $Temp_Registry_Entries_Return = Get-ItemProperty -Path $Item.Value.Path -Name $Item.Value.Name -ErrorAction $Item.Value.ErrorAction

                if ($Temp_Registry_Entries_Return -notin "",$null) {
                    $Meta_Discovery_Actual_Found_Count += 1
                    $Meta_Discovery_Actual = "Failure"
                }

                $Temp_Log_Body    = @"

  Path: $($Item.Value.Path)
  Property: $($Item.Value.Name)
  Exists: True

  Discovery Result: $($Meta_Discovery_Actual)

-----------------------------------------------------------------------------------
"@

                Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop
            }
            catch [System.Management.Automation.ItemNotFoundException],[System.Management.Automation.PSArgumentException] {
                # $Meta_Discovery_Actual_Failure_Count += 1

                $Temp_Log_Error    = @"

  Path: $($Item.Value.Path)
  Property: $($Item.Value.Name)
  Exists: False

  Discovery Result: Success

-----------------------------------------------------------------------------------
"@

                Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Error -Append -ErrorAction Stop
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

            # Reset Variables in Loop
                $Meta_Discovery_Actual = $null
        }

    # Determine Discovery Result
        if ($Meta_Discovery_Actual_Found_Count -le 0) {
            $Meta_Discovery_Result = $true,"Success"
        }
        else {
            $Meta_Discovery_Result = $false,"Failure"
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

  Overall Discovery Result: $($Meta_Discovery_Result[1])

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
        Return $Meta_Discovery_Result[0]

#EndRegion Output
#--------------------------------------------------------------------------------------------
