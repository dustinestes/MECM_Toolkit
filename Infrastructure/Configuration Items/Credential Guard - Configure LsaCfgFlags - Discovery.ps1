#--------------------------------------------------------------------------------------------
# Input
#--------------------------------------------------------------------------------------------
#Region Input

<#
Link: https://learn.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/microsoft-windows-deviceguard-unattend-lsacfgflags

#>
    # Registry Data
        $Registry_01 = @{
            "Path"          = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
            "Name"          = "LsaCfgFlagsDefault"
            "Value"         = 0
            "PropertyType"  = "Dword"
            "Force"         = $true
            "ErrorAction"   = "Stop"
        }

    # Metadata
        $Meta_Discovery_Result                  = $false
        $Meta_Discovery_Desired                 = $true
        $Meta_Discovery_Actual                  = $null
        $Meta_Discovery_Actual_Failure_Count    = 0

    # Logging
        $Path_Log_Directory = "$($env:vr_Directory_Logs)\ConfigurationBaselines\Discovery"
        $Name_Log_File      = "CI - Credential Guard - Configure LsaCfgFlags"
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
            if ((Test-Path -Path "HKLM:\" -ErrorAction Stop) -eq $false) {
                New-PSDrive -Name HKLM -PSProvider Registry -Root HKEY_CLASSES_ROOT -ErrorAction Stop | Out-Null
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
            $Temp_Registry_Entries = Get-Variable -Name "Registry_*" -ErrorAction Stop
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
                    $Meta_Discovery_Actual = $true
                }
                else {
                    $Meta_Discovery_Actual = $false
                    $Meta_Discovery_Actual_Failure_Count ++
                }

                $Temp_Log_Body    = @"

  Path: $($Item.Value.Path)
  Property: $($Item.Value.Name)
  Desired Value: $($Item.Value.Value)
  Actual Value: $($Temp_Registry_Entries_Return.$($Item.Value.Name))

  Discovery Result: $($Meta_Discovery_Actual)

-----------------------------------------------------------------------------------
"@

                Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop
            }
            catch [System.Management.Automation.ItemNotFoundException],[System.Management.Automation.PSArgumentException] {
                $Meta_Discovery_Actual_Failure_Count += 1

                $Temp_Log_Error    = @"

  Path: $($Item.Value.Path)
  Property: $($Item.Value.Name)
  Exists: False

  Discovery Result: False

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
        }

    # Determine Discovery Result
        if ($Meta_Discovery_Actual_Failure_Count -le 0) {
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
