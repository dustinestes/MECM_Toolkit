#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
    [string]$TemplateName,          # "WorkstationAuthentication"
    [string]$TargetStore,           # "cert:\LocalMachine\My"
    [string]$ServerURL              # "ldap://servername.domain.com/"
)

#--------------------------------------------------------------------------------------------
#Start-Transcript -Path "C:\VividRock\MECM Toolkit\Logs\Task Sequences\Certificates - Enroll in Client Auth Certificate.log" -Append -ErrorAction SilentlyContinue

#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  MECM Toolkit - Task Sequences - Certificates - Enroll in Client Auth Certificate"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:     Dustin Estes"
    Write-Host "    Company:    VividRock"
    Write-Host "    Date:       March 23, 2020"
    Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:    This script will take input information and enroll the device"
    Write-Host "                into the specified Client Authentication Certificate for HTTPS."
    Write-Host "    Links:      None"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host ""

    <#
    To Do:
        - None
    #>

#EndRegion Header
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Variables
#   Error Range: 1200 - 1299
#--------------------------------------------------------------------------------------------
#Region Variables

    Write-Host "  Variables"

    # Parameters
        $Param_Certificate_Template      = $TemplateName
        $Param_Certificate_TargetStore   = $TargetStore
        $Param_Certificate_ServerURL     = $ServerURL

    # Metadata
        $Meta_Script_Start_DateTime     = Get-Date
        $Meta_Script_Complete_DateTime  = $null
        $Meta_Script_Complete_TimeSpan  = $null
        $Meta_Script_Result = $false,"Failure"

    # Names

    # Paths

    # Files

    # Hashtables

    # Arrays

    # Registry

    # WMI

    # Datasets

    # Temporary

    # Output to Log
        Write-Host "    - Parameters"
        foreach ($Item in (Get-Variable -Name "Param_*")) {
            Write-Host "        $(($Item.Name) -replace 'Param_',''): $($Item.Value)"
        }

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Variables
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Functions
#   Error Range: 1300 - 1399
#--------------------------------------------------------------------------------------------
#Region Functions

    Write-Host "  Functions"

    # Write Error Codes
        Write-Host "    - Write-vr_ErrorCode"
        function Write-vr_ErrorCode ($Code,$Exit,$Object) {
            # Code: XXXX   4-digit code to identify where in script the operation failed
            # Exit: Boolean option to define if  exits or not
            # Object: The error object created when the script encounters an error ($Error[0], $PSItem, etc.)

            begin {

            }

            process {
                Write-Host "        Error: $($Object.Exception.ErrorId)"
                Write-Host "        Command Name: $($Object.CategoryInfo.Activity)"
                Write-Host "        Message: $($Object.Exception.Message)"
                Write-Host "        Line/Position: $($Object.Exception.Line)/$($Object.Exception.Offset)"
            }

            end {
                switch ($Exit) {
                    $true {
                        Write-Host "        Exit: $($Code)"
                        Exit $Code
                    }
                    $false {
                        Write-Host "        Continue Processing..."
                    }
                    Default {
                        Write-Host "        Unknown Exit option in Write-vr_ErrorCode parameter"
                    }
                }
            }
        }

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Functions
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Environment
#   Error Range: 1400 - 1499
#--------------------------------------------------------------------------------------------
#Region Environment

    # Write-Host "  Environment"

    # # Create TSEnvironment COM Object
    #     Write-Host "    - Create TSEnvironment COM Object"

    #     try {
    #         $Object_MECM_TSEnvironment = New-Object -ComObject Microsoft.SMS.TSEnvironment -ErrorAction Stop
    #         Write-Host "        Status: Success"
    #     }
    #     catch {
    #         Write-vr_ErrorCode -Code 1401 -Exit $true -Object $PSItem
    #     }

    # Write-Host "    - Complete"
    # Write-Host ""

#EndRegion Environment
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Validation
#   Error Range: 1500 - 1599
#--------------------------------------------------------------------------------------------
#Region Validation

    Write-Host "  Validation"

    # Certificate Server
        Write-Host "    - Certificate Server"

        try {
            If (Test-Connection -ComputerName ($Param_Certificate_ServerURL -replace "ldap://","" -replace "/","") -Quiet -ErrorAction Stop) {
                Write-Host "        Status: Reachable"
            }
            Else {
                Write-Host "        Error: Not Reachable"
                Write-Host "        Command Name: Test-Connection"
                Exit 1502
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
        }

    # Target Certificate Store
        Write-Host "    - Target Certificate Store"
        try {
            If (Test-Path -Path $Param_Certificate_TargetStore -ErrorAction Stop) {
                Write-Host "        Status: Exists"
            }
            Else {
                Write-Host "        Error: Not Exists"
                Write-Host "        Command Name: Test-Path"
                Exit 1504
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1503 -Exit $true -Object $PSItem
        }

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Validation
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Data Gather
#   Error Range: 1600 - 1699
#--------------------------------------------------------------------------------------------
#Region Data Gather

    Write-Host "  Data Gather"

    # Operating System
        Write-Host "    - Operating System"

        try {
            $Temp_OperatingSystem_Object = Get-CimInstance -ClassName Win32_OperatingSystem
            Write-Host "        Caption: $($Temp_OperatingSystem_Object.Caption)"
            Write-Host "        Version: $($Temp_OperatingSystem_Object.Version)"
        }
        catch {
            Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
        }

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Data Gather
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Execution
#   Error Range: 1700 - 1799
#--------------------------------------------------------------------------------------------
#Region Execution

    Write-Host "  Execution"

    # Enroll in Certificate
        if ($Temp_OperatingSystem_Object.Version -like "6.1.*") {
            Write-Host "    - Enroll in Certificate (Windows 7)"

            try {
                $Temp_Construct_Expression = "certreq -enroll -machine -policyserver $($Param_Certificate_ServerURL) $($Param_Certificate_Template)"
                Write-Host "        Command: $($Temp_Construct_Expression)"

                $Counter_Enroll_Attempts = 0
                do {
                    $Counter_Enroll_Attempts ++
                    Write-Host "        Attempt: $($Counter_Enroll_Attempts)"
                    $Result_Enroll = Invoke-Expression -Command $Temp_Construct_Expression -ErrorAction Continue

                    if ([bool]$Result_Enroll -eq $false) {
                        Start-Sleep -Seconds 15
                    }
                } until (
                    ($Counter_Enroll_Attempts -eq 80) -or ([bool]$Result_Enroll -eq $true)
                )

                Write-Host "        Status:  $($Result_Enroll)"
            }
            catch {
                Write-vr_ErrorCode -Code 1701 -Exit $true -Object $PSItem
            }
        }
        else {
            Write-Host "    - Enroll in Certificate"

            try {
                # Perform Multiple Attempts to Allow for Replication Delays in Active Directory
                    $Counter_Enroll_Attempts = 0
                    do {
                        $Counter_Enroll_Attempts ++
                        Write-Host "        Attempt: $($Counter_Enroll_Attempts)"
                        $Result_Enroll = Get-Certificate -Template $Param_Certificate_Template -Url $Param_Certificate_ServerURL -CertStoreLocation $Param_Certificate_TargetStore -ErrorAction Continue

                        if ([bool]$Result_Enroll -eq $false) {
                            Write-Host "            Successful: $([bool]$Result_Enroll)"
                            Write-Host "            Command Name: $($Error[0].CategoryInfo.Activity)"
                            Write-Host "            Message: $($Error[0].Exception.Message)"
                            Start-Sleep -Seconds 15
                        }
                    } until (
                        ($Counter_Enroll_Attempts -eq 80) -or ($Result_Enroll.Status -eq "Issued")
                    )

                # Output Results or Exit if Unsuccessful
                    if ($Result_Enroll.Status -eq "Issued") {
                        Write-Host "        Result"
                        Write-Host "            Status:  $($Result_Enroll.Status)"
                        Write-Host "            Subject: $($Result_Enroll.Certificate.Subject)"
                        Write-Host "            Issued:  $($Result_Enroll.Certificate.NotBefore)"
                        Write-Host "            Expires: $($Result_Enroll.Certificate.NotAfter)"
                    }
                    else {
                        Write-vr_ErrorCode -Code 1702 -Exit $true -Object $Error[0]
                    }
            }
            catch {
                Write-vr_ErrorCode -Code 1701 -Exit $true -Object $PSItem
            }
        }

    # Determine Script Result
        $Meta_Script_Result = $true,"Success"

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Execution
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Output
#   Error Range: 1800 - 1899
#--------------------------------------------------------------------------------------------
#Region Output

    # Write-Host "  Output"

    # # [StepName]
    #     Write-Host "    - [StepName]"

    #     try {

    #         Write-Host "        Status: Success"
    #     }
    #     catch {
    #         Write-vr_ErrorCode -Code 1801 -Exit $true -Object $PSItem
    #     }

    # Write-Host "    - Complete"
    # Write-Host ""

#EndRegion Output
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Cleanup
#   Error Range: 1900 - 1999
#--------------------------------------------------------------------------------------------
#Region Cleanup

    # Write-Host "  Cleanup"

    # # Confirm Cleanup
    #     Write-Host "    - Confirm Cleanup"

    #     do {
    #         $Temp_Cleanup_UserInput = Read-Host -Prompt "        Do you want to automatically clean up the unecessary content from this script? [Y]es or [N]o" -ErrorAction Stop
    #     } until (
    #         $Temp_Cleanup_UserInput -in "Y","Yes","N","No"
    #     )

    # # [StepName]
    #     Write-Host "    - [StepName]"

    #     try {
    #         if ($Temp_Cleanup_UserInput -in "Y", "Yes") {

    #             Write-Host "        Status: Success"
    #         }
    #         else {
    #             Write-Host "            Status: Skipped"
    #         }
    #     }
    #     catch {
    #         Write-vr_ErrorCode -Code 1901 -Exit $true -Object $PSItem
    #     }

    # Write-Host "    - Complete"
    # Write-Host ""

#EndRegion Cleanup
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Footer
#--------------------------------------------------------------------------------------------
#Region Footer

    # Gather Data
        $Meta_Script_Complete_DateTime  = Get-Date
        $Meta_Script_Complete_TimeSpan  = New-TimeSpan -Start $Meta_Script_Start_DateTime -End $Meta_Script_Complete_DateTime

    # Output
        Write-Host ""
        Write-Host "------------------------------------------------------------------------------"
        Write-Host "  Script Result: $($Meta_Script_Result[1])"
        Write-Host "  Script Started: $($Meta_Script_Start_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd HH:mm:ss`")) (UTC)"
        Write-Host "  Script Completed: $($Meta_Script_Complete_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd HH:mm:ss`")) (UTC)"
        Write-Host "  Total Time: $($Meta_Script_Complete_TimeSpan.Days) days, $($Meta_Script_Complete_TimeSpan.Hours) hours, $($Meta_Script_Complete_TimeSpan.Minutes) minutes, $($Meta_Script_Complete_TimeSpan.Seconds) seconds, $($Meta_Script_Complete_TimeSpan.Milliseconds) milliseconds"
        Write-Host "------------------------------------------------------------------------------"
        Write-Host "  End of Script"
        Write-Host "------------------------------------------------------------------------------"

#EndRegion Footer
#--------------------------------------------------------------------------------------------

Return $Meta_Script_Result[0]
# Stop-Transcript