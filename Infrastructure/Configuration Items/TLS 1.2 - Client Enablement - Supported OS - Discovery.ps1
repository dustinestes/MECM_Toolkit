#--------------------------------------------------------------------------------------------
# Input
#--------------------------------------------------------------------------------------------
#Region Input

    # Metadata
        $Meta_Discovery_Desired     = $true
        $Meta_Discovery_Actual      = $null
        $Meta_Discovery_Result      = $false

    # Logging
        $Path_Log_Directory = "$($env:vr_Directory_Logs)\ConfigurationBaselines\Discovery"
        $Name_Log_File      = "CI - TLS 1.2 - Client Enablement - Supported OS"
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

    # Test for Supported Operating System
        $Temp_OperatingSystem = Get-WmiObject -Class Win32_OperatingSystem

        switch -wildcard ($Temp_OperatingSystem.Version) {
            # Windows 10 and Up Natively Support TLS 1.2
                "10*"   {$Meta_Discovery_Actual = $true; Break}

            # Operating Systems Prior to Windows 10 Require an Update to Enable Support for TLS 1.2
                "6.3*"  {$Meta_Discovery_Actual = $true; Break}
                "6.2*"  {$Meta_Discovery_Actual = $true; Break}
                "6.1*"  {$Meta_Discovery_Actual = $true; Break}

            # Operating Systems Prior to Windows 7 Do Not Support TLS 1.2
                "6*"    {$Meta_Discovery_Actual = $false; Break}
                "5.2*"  {$Meta_Discovery_Actual = $false; Break}
                "5.1*"  {$Meta_Discovery_Actual = $false; Break}
                "5*"    {$Meta_Discovery_Actual = $false; Break}

            Default {Write-Host "Nothing"}
        }

        # Output Data
            $Temp_Log_Body    = @"

  Operating System Validation
    Caption: $($Temp_OperatingSystem.Caption)
    Version: $($Temp_OperatingSystem.Version)
    Supports TLS: $($Meta_Discovery_Actual)

"@

            Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop

    # Determine Discovery Result
        if ($Meta_Discovery_Actual -eq $Meta_Discovery_Desired) {
            $Meta_Discovery_Result = $true
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
  Actual State: $($Meta_Discovery_Actual)

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
