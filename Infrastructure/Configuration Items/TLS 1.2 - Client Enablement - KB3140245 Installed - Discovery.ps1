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
        $Name_Log_File      = "CI - TLS 1.2 - Client Enablement - KB3140245 Installed"
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

    # Test for Update Requirement
        try {
            $Temp_OperatingSystem = Get-WmiObject -Class Win32_OperatingSystem

            switch -wildcard ($Temp_OperatingSystem.Version) {
                # Windows 10 and Up Natively Support TLS 1.2
                    "10*"   {$Temp_Update_Required = $false; Break}

                # Operating Systems Prior to Windows 10 Require an Update to Enable Support for TLS 1.2
                    "6.3*"  {$Temp_Update_Required = $true; Break}
                    "6.2*"  {$Temp_Update_Required = $true; Break}
                    "6.1*"  {$Temp_Update_Required = $true; Break}

                # Operating Systems Prior to Windows 7 Do Not Support TLS 1.2
                    "6*"    {$Temp_Update_Required = "Unsupported"; Break}
                    "5.2*"  {$Temp_Update_Required = "Unsupported"; Break}
                    "5.1*"  {$Temp_Update_Required = "Unsupported"; Break}
                    "5*"    {$Temp_Update_Required = "Unsupported"; Break}

                Default {Write-Host "Nothing"}
            }

            # Output Data
                $Temp_Log_Body   = @"

  Update KB3140245 Validation
    Required: $($Temp_Update_Required)
"@

                Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop
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


    # Test for Update Existence
        try {
            if ($Temp_Update_Required -eq $true) {
                $Temp_Update_Exists = Get-Hotfix -Id "KB3140245"

                if ([bool]$Temp_Update_Exists -eq $true) {
                    $Temp_Log_Body   = @"
    Status: Exists
      Description: $($Temp_Update_Exists.Description)
      HotfixID: $($Temp_Update_Exists.HotFixID)
      InstalledBy: $($Temp_Update_Exists.InstalledBy)
      InstalledOn: $($Temp_Update_Exists.InstalledOn)

"@

                    Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop

                    $Meta_Discovery_Actual = $true
                }
                else {
                    $Temp_Log_Body   = @"
    Status: Not Exists

"@

                    Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop

                    $Meta_Discovery_Actual = $false
                }
            }
            elseif ($Temp_Update_Required -eq $false) {
                $Temp_Log_Body   = @"
    Status: Skip Existence Validation

"@

                Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop

                $Meta_Discovery_Actual = $true
            }
            elseif ($Temp_Update_Required -eq "Unsupported") {
                $Temp_Log_Body   = @"
    Status: OS Unsupported

"@

                Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop

                $Meta_Discovery_Actual = $false
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

    # Determine Discovery Result
        try {
            if ($Meta_Discovery_Actual -eq $Meta_Discovery_Desired) {
                $Meta_Discovery_Result = $true
            }
            else {
                $Meta_Discovery_Result = $false
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
