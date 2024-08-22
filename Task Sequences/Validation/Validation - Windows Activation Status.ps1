#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

# param (
#     [string]$ParamName                # [ExampleInputValues]
# )

#--------------------------------------------------------------------------------------------
Start-Transcript -Path "C:\VividRock\MECM Toolkit\Logs\[Collection]\[SpecificOperation].log"  -Append -ErrorAction SilentlyContinue

#--------------------------------------------------------------------------------------------
# Header   (Outputs to SMSTS.log)
#--------------------------------------------------------------------------------------------
#Region Header

    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  MECM Toolkit - Validation - Windows Activation Status"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:     Dustin Estes"
    Write-Host "    Company:    VividRock"
    Write-Host "    Date:       November 24, 2019"
    Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:    Validates that the current running Windows OS is activated."
    Write-Host "    Links:      https://learn.microsoft.com/en-us/previous-versions/windows/desktop/sppwmi/softwarelicensingproduct"
    Write-Host "    Template:   1.0"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host ""

<#
    To Do:
        - Item
        - Item
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

    # Metadata
        $Meta_Script_Start_DateTime     = Get-Date
        $Meta_Script_Complete_DateTime  = $null
        $Meta_Script_Complete_TimeSpan  = $null
        [bool]$Meta_Script_Success = $false
        $Meta_Activation_Status = "Unknown"

    # Names

    # Paths

    # Files

    # Hashtables
        $Hashtable_LicenseStatus_Descriptions = @{
            "0" = "Unlicensed"
            "1" = "Licensed"
            "2" = "OOBGrace"
            "3" = "OOTGrace"
            "4" = "NonGenuineGrace"
            "5" = "Notification"
            "6" = "ExtendedGrace"
        }

    # Arrays
        $Array_LicenseStatus_Properties = @(
            "Name"                                              # Windows(R), Enterprise edition
            "Description"                                       # Windows(R) Operating System, VOLUME_KMSCLIENT channel
            "PartialProductKey"                                 # [5-digitKey]
            "ProductKeyChannel"                                 # Volume#GVLK
            "LicenseFamily"                                     # Enterprise
            "LicenseStatus"                                     # 1
            "DiscoveredKeyManagementServiceMachineName"         # [ServerName].[Domin].com
            "DiscoveredKeyManagementServiceMachineIpAddress"    # [IPAddress]
            "DiscoveredKeyManagementServiceMachinePort"         # 1688
        )

    # Registry

    # WMI
        $WMI_Namespace_Path     = "root/cimv2"
        $WMI_Class_Name         = "SoftwareLicensingProduct"

    # Datasets

    # Temporary

    # Output to Log
        Write-Host "    - WMI"
        Write-Host "        Namespace: $($WMI_Namespace_Path)"
        Write-Host "        Class Name: $($WMI_Class_Name)"
        Write-Host "    - LicenseStatus Properties"
        foreach ($Item in $Array_LicenseStatus_Properties) {
            Write-Host "        $($Item)"
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
                        Write-Host "        Return"
                        Return
                    }
                    Default {
                        Write-Host "        Unknown Exit option in Write-vr_ErrorCode parameter"
                    }
                }
            }
        }

        Write-Host "        Success"

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Functions
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Environment
#   Error Range: 1400 - 1499
#--------------------------------------------------------------------------------------------
#Region Environment

    Write-Host "  Environment"

    # Create TSEnvironment COM Object
        Write-Host "    - Create TSEnvironment COM Object"

        try {
            $Object_MECM_TSEnvironment = New-Object -ComObject Microsoft.SMS.TSEnvironment -ErrorAction Stop
            Write-host "        Status: Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1401 -Exit $true -Object $PSItem
        }

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Environment
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Validation
#   Error Range: 1500 - 1599
#--------------------------------------------------------------------------------------------
#Region Validaion

    Write-Host "  Validation"

    # WMI Class
        Write-Host "    - WMI Class"

        try {
            Get-CimClass -Namespace $WMI_Namespace_Path -ClassName $WMI_Class_Name -ErrorAction Stop | Out-Null
            Write-host "        Status: Exists"
        }
        catch {
            Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
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

    # Write-Host "  Data Gather"

    # # [StepName]
    #     Write-Host "    - [StepName]"

    #     try {

    #         Write-Host "        Status: Success"
    #     }
    #     catch {
    #         Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
    #     }

    # # [StepName]
    #     foreach ($Item in (Get-Variable -Name "Path_*")) {
    #         Write-Host "    - $($Item.Name)"

    #         try {

    #             Write-Host "        Status: Success"
    #         }
    #         catch {
    #             Write-vr_ErrorCode -Code 1602 -Exit $true -Object $PSItem
    #         }
    #     }

    # Write-Host "    - Complete"
    # Write-Host ""

#EndRegion Data Gather
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Execution
#   Error Range: 1700 - 1799
#--------------------------------------------------------------------------------------------
#Region Execution

    Write-Host "  Execution"

    # Windows License Activation Status
        Write-Host "    - Windows License Activation Status"

        $Counter_Activation_LicensesNotActivated = 0

        try {
            $Dataset_WMI_SoftwareLicensingProduct = Get-CimInstance -Namespace $WMI_Namespace_Path -ClassName $WMI_Class_Name -Filter "partialproductkey is not null" -ErrorAction Stop | Where-Object -Property "Name" -like "Windows*"
            foreach ($Object in $Dataset_WMI_SoftwareLicensingProduct) {
                foreach ($Property in $Array_LicenseStatus_Properties) {
                    switch ($Property) {
                        "LicenseStatus" {
                            Write-Host "        LicenseStatus: $($Object.$($Property))"
                            Write-Host "        LicenseStatus Name: $($Hashtable_LicenseStatus_Descriptions.`"$($Object.$($Property))`")"
                        }
                        Default { Write-Host "        $($Property): $($Object.$($Property))" }
                    }
                }

                if ($Object.LicenseStatus -ne 1) {
                    $Counter_Activation_LicensesNotActivated += 1
                }

                Write-Host ""
            }
        }
        catch {
            Write-vr_ErrorCode -Code 1701 -Exit $true -Object $PSItem
        }

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Main Execution
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Output
#   Error Range: 1800 - 1899
#--------------------------------------------------------------------------------------------
#Region Output

    Write-Host "  Output"

    # Set TSEnvironment Variable
        Write-Host "    - Set TSEnvironment Variable"

        try {
            if ($Counter_Activation_LicensesNotActivated -gt 0) {
                $Meta_Activation_Status = "Not Activated"
            }
            else {
                $Meta_Activation_Status = "Activated"
            }

            $Object_MECM_TSEnvironment.Value("vr_Validation_WindowsLicenseActivation") = $Meta_Activation_Status
            Write-Host "        vr_Validation_WindowsLicenseActivation = $($Meta_Activation_Status)"
        }
        catch {
            Write-vr_ErrorCode -Code 1901 -Exit $true -Object $PSItem
        }

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Return
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Cleanup
#   Error Range: 1900 - 1999
#--------------------------------------------------------------------------------------------
#Region Cleanup

    # Write-Host "  Cleanup"

    # # [StepName]
    #     Write-Host "    - [StepName]"

    #     try {

    #         Write-host "        Success"
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
        Write-Host "  Script Result: $($Meta_Script_Success)"
        Write-Host "  Script Started: $($Meta_Script_Start_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd HH:mm:ss`")) (UTC)"
        Write-Host "  Script Completed: $($Meta_Script_Complete_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd HH:mm:ss`")) (UTC)"
        Write-Host "  Total Time: $($Meta_Script_Complete_TimeSpan.Days) days, $($Meta_Script_Complete_TimeSpan.Hours) hours, $($Meta_Script_Complete_TimeSpan.Minutes) minutes, $($Meta_Script_Complete_TimeSpan.Seconds) seconds, $($Meta_Script_Complete_TimeSpan.Milliseconds) milliseconds"
        Write-Host "------------------------------------------------------------------------------"
        Write-Host "  End of Script"
        Write-Host "------------------------------------------------------------------------------"

#EndRegion Footer
#--------------------------------------------------------------------------------------------

Return $Meta_Script_Success
Stop-Transcript