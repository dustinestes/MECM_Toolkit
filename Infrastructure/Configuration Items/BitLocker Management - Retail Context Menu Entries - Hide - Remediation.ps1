#--------------------------------------------------------------------------------------------
# Input
#--------------------------------------------------------------------------------------------
#Region Input

    # BitLocker Management Data
        $Registry_BitLocker_01 = @{
            "Path"          = "HKCR:\Drive\shell\change-passphrase"
            "Name"          = "ProgrammaticAccessOnly"
            "Value"         = ""
            "PropertyType"  = "String"
            "Force"         = $true
            "ErrorAction"   = "Stop"
        }

        $Registry_BitLocker_02 = @{
            "Path"          = "HKCR:\Drive\shell\change-pin"
            "Name"          = "ProgrammaticAccessOnly"
            "Value"         = ""
            "PropertyType"  = "String"
            "Force"         = $true
            "ErrorAction"   = "Stop"
        }

        $Registry_BitLocker_03 = @{
            "Path"          = "HKCR:\Drive\shell\encrypt-bde"
            "Name"          = "ProgrammaticAccessOnly"
            "Value"         = ""
            "PropertyType"  = "String"
            "Force"         = $true
            "ErrorAction"   = "Stop"
        }

        $Registry_BitLocker_04 = @{
            "Path"          = "HKCR:\Drive\shell\encrypt-bde-elev"
            "Name"          = "ProgrammaticAccessOnly"
            "Value"         = ""
            "PropertyType"  = "String"
            "Force"         = $true
            "ErrorAction"   = "Stop"
        }

        $Registry_BitLocker_05 = @{
            "Path"          = "HKCR:\Drive\shell\manage-bde"
            "Name"          = "ProgrammaticAccessOnly"
            "Value"         = ""
            "PropertyType"  = "String"
            "Force"         = $true
            "ErrorAction"   = "Stop"
        }

        $Registry_BitLocker_06 = @{
            "Path"          = "HKCR:\Drive\shell\manage-bde-elev"
            "Name"          = "ProgrammaticAccessOnly"
            "Value"         = ""
            "PropertyType"  = "String"
            "Force"         = $true
            "ErrorAction"   = "Stop"
        }

        $Registry_BitLocker_07 = @{
            "Path"          = "HKCR:\Drive\shell\resume-bde"
            "Name"          = "ProgrammaticAccessOnly"
            "Value"         = ""
            "PropertyType"  = "String"
            "Force"         = $true
            "ErrorAction"   = "Stop"
        }

        $Registry_BitLocker_08 = @{
            "Path"          = "HKCR:\Drive\shell\resume-bde-elev"
            "Name"          = "ProgrammaticAccessOnly"
            "Value"         = ""
            "PropertyType"  = "String"
            "Force"         = $true
            "ErrorAction"   = "Stop"
        }

        $Registry_BitLocker_09 = @{
            "Path"          = "HKCR:\Drive\shell\unlock-bde"
            "Name"          = "ProgrammaticAccessOnly"
            "Value"         = ""
            "PropertyType"  = "String"
            "Force"         = $true
            "ErrorAction"   = "Stop"
        }

    # Metadata
        $Meta_Remediation_Result    = $false

    # Logging
        $Path_Log_Directory = "$($env:vr_Directory_Logs)\ConfigurationBaselines\Remediation"
        $Name_Log_File      = "CI - BitLocker Management - Retail Context Menu Entries - Hide"
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
# Remediation
#   Error Range: 1200 - 1299
#--------------------------------------------------------------------------------------------
#Region Remediation

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

                if ($Temp_Registry_Entries_Return.$($Item.Value.Name) -eq $Item.Value.Value) {
                    # Do Nothing, Values Match
                    $Meta_Remediation_Action = "Skipped"
                }
                else {
                    Set-ItemProperty -Path $Item.Value.Path -Name $Item.Value.Name -Value $Item.Value.Value -ErrorAction $Item.Value.ErrorAction | Out-Null
                    $Meta_Remediation_Action = "Modified"
                }

                $Temp_Log_Body    = @"

  Path: $($Item.Value.Path)
  Property: $($Item.Value.Name)
  Desired Value: $($Item.Value.Value)
  Actual Value: $($Temp_Registry_Entries_Return.$($Item.Value.Name))

  Remediation Result: $($Meta_Remediation_Action)

-----------------------------------------------------------------------------------
"@

                Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop
            }
            catch [System.Management.Automation.ItemNotFoundException],[System.Management.Automation.PSArgumentException] {
                New-ItemProperty -Path $Item.Value.Path -Name $Item.Value.Name -PropertyType $Item.Value.PropertyType -Value $Item.Value.Value -ErrorAction $Item.Value.ErrorAction | Out-Null

                $Meta_Remediation_Action = "Created"

                $Temp_Log_Body    = @"

  Path: $($Item.Value.Path)
  Property: $($Item.Value.Name)
  Exists: False

  Remediation Result: $($Meta_Remediation_Action)

-----------------------------------------------------------------------------------
"@

                Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop
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
                $Meta_Remediation_Action = $null
        }

    # Determine Remediation Result
        $Meta_Remediation_Result = $true,"Success"

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

  Overall Remediation Result: $($Meta_Remediation_Result[1])

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
        if ($Meta_Remediation_Result[0] -eq $true) {
            Exit 0
        }
        else {
            Exit 2000
        }

#EndRegion Output
#--------------------------------------------------------------------------------------------
