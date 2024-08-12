#--------------------------------------------------------------------------------------------
# Input
#--------------------------------------------------------------------------------------------
#Region Input

    # BitLocker Management Data
        $Registry_BitLocker_01 = @{
            "Path"          = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
            "Name"          = "DisallowCPL"
            "Value"         = "1"
            "PropertyType"  = "DWORD"
            "Force"         = $true
            "ErrorAction"   = "Stop"
        }

        $Registry_BitLocker_02 = @{
            "Path"          = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowCpl"
            "Name"          = "BLM_1"
            "Value"         = "Microsoft.BitLockerDriveEncryption"
            "PropertyType"  = "String"
            "Force"         = $true
            "ErrorAction"   = "Stop"
        }

    # Metadata
        $Meta_Discovery_Result      = $false
        $Meta_Discovery_Desired     = $true
        $Meta_Discovery_Actual      = $null

    # Logging
        $Path_Log_Directory = "$($env:vr_Directory_Logs)\ConfigurationBaselines\Discovery"
        $Name_Log_File      = "CI - BitLocker Management - Retail Control Panel Applet - Hide"
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
# Discovery
#   Error Range: 1200 - 1299
#--------------------------------------------------------------------------------------------
#Region Discovery

    # Test for Existence of Registry Property/Value
        try {
            $Meta_Discovery_Actual = Get-ItemProperty -Path $Registry_BitLocker_01.Path -Name $Registry_BitLocker_01.Name -ErrorAction $Registry_BitLocker_01.ErrorAction

            if (([bool]$Meta_Discovery_Actual -eq $true) -and ($Meta_Discovery_Actual.$($Registry_BitLocker_01.Name) -eq $Registry_BitLocker_01.Value)) {
                $Meta_Discovery_Actual_01 = $true

                $Temp_Log_Body    = @"

  Path: $($Registry_BitLocker_01.Path)
  Property: $($Registry_BitLocker_01.Name)
  Desired Value: $($Registry_BitLocker_01.Value)
  Actual Value: $($Meta_Discovery_Actual.$($Registry_BitLocker_01.Name))

  Discovery Result: $($Meta_Discovery_Actual_01)

-----------------------------------------------------------------------------------
"@

                Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop

            }
            else {
                $Meta_Discovery_Actual_01 = $false

                $Temp_Log_Error    = @"

  Path: $($Registry_BitLocker_01.Path)
  Property: $($Registry_BitLocker_01.Name)
  Desired Value: $($Registry_BitLocker_01.Value)
  Actual Value: $($Meta_Discovery_Actual.$($Registry_BitLocker_01.Name))

  Discovery Result: $($Meta_Discovery_Actual_01)

-----------------------------------------------------------------------------------
"@

                Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Error -Append -ErrorAction Stop

            }
        }
        catch [System.Management.Automation.ItemNotFoundException],[System.Management.Automation.PSArgumentException] {
            $Meta_Discovery_Actual_01 = $false

            $Temp_Log_Error    = @"

  Path: $($Registry_BitLocker_01.Path)
  Property: $($Registry_BitLocker_01.Name)
  Exists: False

  Discovery Result: $($Meta_Discovery_Actual_01)

-----------------------------------------------------------------------------------
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


    # Test for Existence of Registry Property/Value
        try {
            $Meta_Discovery_Actual = Get-ItemProperty -Path $Registry_BitLocker_02.Path -Name $Registry_BitLocker_02.Name -ErrorAction $Registry_BitLocker_02.ErrorAction

            if (([bool]$Meta_Discovery_Actual -eq $true) -and ($Meta_Discovery_Actual.$($Registry_BitLocker_02.Name) -eq $Registry_BitLocker_02.Value)) {
                $Meta_Discovery_Actual_02 = $true

                $Temp_Log_Body    = @"

  Path: $($Registry_BitLocker_02.Path)
  Property: $($Registry_BitLocker_02.Name)
  Desired Value: $($Registry_BitLocker_02.Value)
  Actual Value: $($Meta_Discovery_Actual.$($Registry_BitLocker_02.Name))

  Discovery Result: $($Meta_Discovery_Actual_02)

-----------------------------------------------------------------------------------
"@

            Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop
            }
            else {
                $Meta_Discovery_Actual_02 = $false

                $Temp_Log_Error    = @"

  Path: $($Registry_BitLocker_02.Path)
  Property: $($Registry_BitLocker_02.Name)
  Desired Value: $($Registry_BitLocker_02.Value)
  Actual Value: $($Meta_Discovery_Actual.$($Registry_BitLocker_02.Name))

  Discovery Result: $($Meta_Discovery_Actual_02)

-----------------------------------------------------------------------------------
"@

                Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Error -Append -ErrorAction Stop

            }
        }
        catch [System.Management.Automation.ItemNotFoundException],[System.Management.Automation.PSArgumentException] {
            $Meta_Discovery_Actual_02 = $false

            $Temp_Log_Error    = @"

  Path: $($Registry_BitLocker_02.Path)
  Property: $($Registry_BitLocker_02.Name)
  Exists: False

  Discovery Result: $($Meta_Discovery_Actual_02)

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

    # Determine Discovery Result
        if (($Meta_Discovery_Actual_01 -eq $Meta_Discovery_Desired) -and ($Meta_Discovery_Actual_02 -eq $Meta_Discovery_Desired)) {
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
