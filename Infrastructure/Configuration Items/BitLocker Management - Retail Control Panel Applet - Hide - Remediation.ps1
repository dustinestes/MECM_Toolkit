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
            "Name"          = "BLM_01"
            "Value"         = "Microsoft.BitLockerDriveEncryption"
            "PropertyType"  = "String"
            "Force"         = $true
            "ErrorAction"   = "Stop"
        }

    # Metadata
        $Meta_Remediation_Result    = $false

    # Logging
        $Path_Log_Directory = "$($env:vr_Directory_Logs)\ConfigurationBaselines\Remediation"
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

    # Test for Existence of Registry Property/Value
        try {
            $Meta_Discovery_Actual = Get-ItemProperty -Path $Registry_BitLocker_01.Path -Name $Registry_BitLocker_01.Name -ErrorAction $Registry_BitLocker_01.ErrorAction

            if (([bool]$Meta_Discovery_Actual -eq $true) -and ($Meta_Discovery_Actual.$($Registry_BitLocker_01.Name) -eq $Registry_BitLocker_01.Value)) {
                #$Meta_Discovery_Actual_01 = $true

                $Temp_Log_Body    = @"

  Path: $($Registry_BitLocker_01.Path)
  Property: $($Registry_BitLocker_01.Name)
  Desired Value: $($Registry_BitLocker_01.Value)
  Actual Value: $($Meta_Discovery_Actual.$($Registry_BitLocker_01.Name))

  Remediation Result: Already Compliant

-----------------------------------------------------------------------------------
"@

                Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop

            }
            else {
                #$Meta_Discovery_Actual_01 = $false
                New-ItemProperty -Path $Registry_BitLocker_01.Path -Name $Registry_BitLocker_01.Name -PropertyType $Registry_BitLocker_01.PropertyType -Value $Registry_BitLocker_01.Value -Force:$Registry_BitLocker_01.Force -ErrorAction $Registry_BitLocker_01.ErrorAction | Out-Null

                $Temp_Log_Error    = @"

  Path: $($Registry_BitLocker_01.Path)
  Property: $($Registry_BitLocker_01.Name)
  Desired Value: $($Registry_BitLocker_01.Value)
  Actual Value: $($Meta_Discovery_Actual.$($Registry_BitLocker_01.Name))

  Remediation Result: Remediate Value

-----------------------------------------------------------------------------------
"@

                Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Error -Append -ErrorAction Stop

            }
        }
        catch [System.Management.Automation.ItemNotFoundException],[System.Management.Automation.PSArgumentException] {
            #$Meta_Discovery_Actual_01 = $false
            New-ItemProperty -Path $Registry_BitLocker_01.Path -Name $Registry_BitLocker_01.Name -PropertyType $Registry_BitLocker_01.PropertyType -Value $Registry_BitLocker_01.Value -Force:$Registry_BitLocker_01.Force -ErrorAction $Registry_BitLocker_01.ErrorAction | Out-Null

            $Temp_Log_Error    = @"

  Path: $($Registry_BitLocker_01.Path)
  Property: $($Registry_BitLocker_01.Name)
  Exists: False

  Remediation Result: Created Property/Value Pair

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
                #$Meta_Discovery_Actual_02 = $true

                $Temp_Log_Body    = @"

  Path: $($Registry_BitLocker_02.Path)
  Property: $($Registry_BitLocker_02.Name)
  Desired Value: $($Registry_BitLocker_02.Value)
  Actual Value: $($Meta_Discovery_Actual.$($Registry_BitLocker_02.Name))

  Remediation Result: Already Compliant

-----------------------------------------------------------------------------------
"@

            Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop
            }
            else {
                #$Meta_Discovery_Actual_02 = $false
                # Create Key
                    if ((Test-Path -Path $Registry_BitLocker_02.Path) -eq $false) {
                        New-Item -Path $Registry_BitLocker_02.Path -ErrorAction Continue
                    }

                # Create Property/Value Pair
                    New-ItemProperty -Path $Registry_BitLocker_02.Path -Name $Registry_BitLocker_02.Name -PropertyType $Registry_BitLocker_02.PropertyType -Value $Registry_BitLocker_02.Value -Force:$Registry_BitLocker_02.Force -ErrorAction $Registry_BitLocker_02.ErrorAction | Out-Null

                $Temp_Log_Error    = @"

  Path: $($Registry_BitLocker_02.Path)
  Property: $($Registry_BitLocker_02.Name)
  Desired Value: $($Registry_BitLocker_02.Value)
  Actual Value: $($Meta_Discovery_Actual.$($Registry_BitLocker_02.Name))

  Remediation Result: Remediated Value

-----------------------------------------------------------------------------------
"@

                Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Error -Append -ErrorAction Stop

            }
        }
        catch [System.Management.Automation.ItemNotFoundException],[System.Management.Automation.PSArgumentException] {
            #$Meta_Discovery_Actual_02 = $false
            # Create Key
                if ((Test-Path -Path $Registry_BitLocker_02.Path) -eq $false) {
                    New-Item -Path $Registry_BitLocker_02.Path -ErrorAction Continue | Out-Null
                }

            # Create Property/Value Pair
                New-ItemProperty -Path $Registry_BitLocker_02.Path -Name $Registry_BitLocker_02.Name -PropertyType $Registry_BitLocker_02.PropertyType -Value $Registry_BitLocker_02.Value -Force:$Registry_BitLocker_02.Force -ErrorAction $Registry_BitLocker_02.ErrorAction | Out-Null

            $Temp_Log_Error    = @"

  Path: $($Registry_BitLocker_02.Path)
  Property: $($Registry_BitLocker_02.Name)
  Exists: False

  Remediation Result: Created Property/Value Pair

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

    # Determine Remediation Result
        if ((Get-ItemProperty -Path $Registry_BitLocker_02.Path -Name $Registry_BitLocker_02.Name).$($Registry_BitLocker_02.Name) -eq $Registry_BitLocker_02.Value) {
            $Meta_Remediation_Result = $true,"Success"
        }
        else {
            $Meta_Remediation_Result = $false,"Failure"
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
