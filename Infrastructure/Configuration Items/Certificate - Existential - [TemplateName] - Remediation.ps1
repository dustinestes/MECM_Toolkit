#--------------------------------------------------------------------------------------------
# Input
#--------------------------------------------------------------------------------------------
#Region Input

    # Certificate Data
        $Name_Certificate_Template  = 'Workstation Authentication'
        $Path_Certificate_Store     = "Cert:\LocalMachine\My"
        $Name_Certificate_Server    = "ldap://servername.domain.com/"

        $Path_Certificate_AutoEnroll    = "HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\AutoEnrollment"
        $Name_Certificate_AutoEnroll    = "AEPolicy"
        $Value_Certificate_AutoEnroll   = "7"

    # Metadata
        $Meta_Remediation_Result    = $false

    # Logging
        $Path_Log_Directory = "$($env:vr_Directory_Logs)\ConfigurationBaselines\Remediation"
        $Name_Log_File      = "CI - Certificate - Existential - $($Name_Certificate_Template)"
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

    # Get Operating System
        try {
            $Temp_OperatingSystem_Object = Get-CimInstance -ClassName Win32_OperatingSystem

            $Temp_Log_Body    = @"

  Operating System
      Caption:   $($Temp_OperatingSystem_Object.Caption)
      Version:   $($Temp_OperatingSystem_Object.Version)

-----------------------------------------------------------------------------------
"@

            Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop
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

    # Get AutoEnrollment Status
        try {
            $Temp_Certificate_AutoEnrollmentStatus = Get-ItemProperty -Path $Path_Certificate_AutoEnroll -Name $Name_Certificate_AutoEnroll -ErrorAction Stop

            $Temp_Log_Body    = @"

  AutoEnrollment Configuration
      AEPolicy Desired State:   $($Value_Certificate_AutoEnroll)
      AEPolicy Actual State:   $($Temp_Certificate_AutoEnrollmentStatus.AEPolicy)

-----------------------------------------------------------------------------------
"@

            Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            $Temp_Log_Error    = @"

  Error ID: 1102
  Command:  $($PSItem.CategoryInfo.Activity)
  Message:  $($PSItem.Exception.Message)

-----------------------------------------------------------------------------------
"@

            Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Error -Append -ErrorAction Stop
            #Exit 1102
        }
        catch {
            $Temp_Log_Error    = @"

  Error ID: 1103
  Command:  $($PSItem.CategoryInfo.Activity)
  Message:  $($PSItem.Exception.Message)

-----------------------------------------------------------------------------------
"@

            Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Error -Append -ErrorAction Stop
            Exit 1103
        }

#EndRegion Environment
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Remediation
#   Error Range: 1200 - 1299
#--------------------------------------------------------------------------------------------
#Region Remediation

    # Enroll in Certificate
        try {
            if ($Temp_OperatingSystem_Object.Version -like "6.1.*") {
                try {
                    $Temp_Construct_Expression = "certreq -enroll -machine -policyserver `"$($Name_Certificate_Server)`" -q `"$($Name_Certificate_Template)`""
                    $Result_Enroll = Invoke-Expression -Command $Temp_Construct_Expression -ErrorAction Stop

                    $Temp_Log_Body    = @"

  Certificate Enrollment (Windows 7)
      Command:   $($Temp_Construct_Expression)
      Result:   $($Result_Enroll)

-----------------------------------------------------------------------------------
"@

                    Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop

                    $Meta_Remediation_Result = $true
                }
                catch {
                    Write-vr_ErrorCode -Code 1701 -Exit $true -Object $PSItem
                }
            }
            else {
                try {
                    $Result_Enroll = Get-Certificate -Template $Name_Certificate_Template -Url $Name_Certificate_Server -CertStoreLocation $Path_Certificate_Store -ErrorAction Stop

                    $Temp_Log_Body    = @"

  Certificate Enrollment
      Result:   $($Result_Enroll.Status)
      Issuer:   $($Result_Enroll.Certificate.Issuer)
      Subject:   $($Result_Enroll.Certificate.Subject)
      EKU List:   $($Result_Enroll.Certificate.EnhancedKeyUsageList)
      Issued:   $($Result_Enroll.Certificate.NotBefore)
      Expires:   $($Result_Enroll.Certificate.NotAfter)
      Version:   $($Result_Enroll.Certificate.Version)
      Serial:   $($Result_Enroll.Certificate.SerialNumber)
      Thumbprint:   $($Result_Enroll.Certificate.Thumbprint)

-----------------------------------------------------------------------------------
"@

                    Out-File -FilePath $Path_Log_File -InputObject $Temp_Log_Body -Append -ErrorAction Stop

                    $Meta_Remediation_Result = $true
                }
                catch {
                    Write-vr_ErrorCode -Code 1701 -Exit $true -Object $PSItem
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
        if ($Meta_Remediation_Result -eq $true) {
            Exit 0
        }
        else {
            Exit 2000
        }

#EndRegion Output
#--------------------------------------------------------------------------------------------
