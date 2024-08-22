#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
    [string]$Filename                # 'VR_Validation_Hardware.log'
)

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  MECM Toolkit - Validation - Hardware Status"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:     Dustin Estes"
    Write-Host "    Company:    VividRock"
    Write-Host "    Date:       December 23, 2019"
    Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:    This script will scan the hardware on the device and check for"
    Write-Host "                any hardware with an error code != 0. If found, it will prompt"
    Write-Host "                prompt the user with the hardware info and status."
    Write-Host "    Links:      https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-pnpentity?redirectedfrom=MSDN"
    Write-Host "                https://support.microsoft.com/en-us/topic/error-codes-in-device-manager-in-windows-524e9e89-4dee-8883-0afa-6bca0456324e"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host ""

#EndRegion Header
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Variables
#   Error Range: 1200 - 1299
#--------------------------------------------------------------------------------------------
#Region Variables

    Write-Host "  Variables"

    # Parameters

    # MECM
        $Object_MECM_TSEnvironment           = New-Object -ComObject Microsoft.SMS.TSEnvironment -ErrorAction Stop
        $vr_TS_VariableName_ValidationStatus    = "vr_Validation_HardwareStatus"
            # Success = No errors found, Failure = 1 or more errors found
        $vr_TS_VariableName_TotalHardware       = "vr_Validation_HardwareTotal"
        $vr_TS_VariableName_TotalErrors         = "vr_Validation_HardwareErrors"

    # Names
        $Name_WMI_Class          = "Win32_PnpEntity"

    # Paths
        $Path_WMI_Namespace      = "root\cimV2"

    # Files
        $File_HardwareInfo_LogOutput    = "$($Object_MECM_TSEnvironment.Value("vr_Directory_TaskSequences"))\$($Filename)"

    # Hashtables
        $ErrorCodes_Win32PnpEntity_ConfigMngr = @{
            "1" = "This device is not configured correctly. (Code 1)"
            "3" = "The driver for this devicemight be corrupted… (Code 3)"
            "9" = "Windows cannot identify this hardware… (Code 9)"
            "10" = "This device cannot start. (Code 10)"
            "12" = "This device cannot find enough free resources that it can use... (Code 12) "
            "14" = "This device cannotwork properly until you restart your computer. (Code 14)"
            "16" = "Windows cannot identify all the resources this device uses. (Code 16)"
            "18" = "Reinstall the drivers for this device. (Code 18)"
            "19" = "Windows cannot start this hardware device… (Code 19)"
            "21" = "Windows is removing this device...(Code 21)"
            "22" = "This device is disabled. (Code 22)"
            "24" = "This device is notpresent, is not working properly… (Code 24)"
            "28" = "The drivers for this device are not installed. (Code 28)"
            "29" = "This device is disabled...(Code 29)"
            "31" = "This device is not working properly...(Code 31)"
            "32" = "A driver (service) for this device has been disabled. (Code 32)"
            "33" = "Windows cannot determinewhich resources are required for this device. (Code 33)"
            "34" = "Windows cannot determine the settings for this device... (Code 34)"
            "35" = "Your computer`'s system firmware does not… (Code 35)"
            "36" = "This device is requesting a PCI interrupt… (Code 36)"
            "37" = "Windows cannot initialize the device driver for this hardware. (Code 37)"
            "38" = "Windows cannot load the device driver… (Code 38)"
            "39" = "Windows cannot load the device driver for this hardware... (Code 39)."
            "40" = "Windows cannot access this hardware… (Code 40)"
            "41" = "Windows successfully loaded the device driver… (Code 41)"
            "42" = "Windows cannot load the device driver…  (Code 42)"
            "43" = "Windows has stopped this device because it has reported problems. (Code 43)"
            "44" = "An application or service has shut down this hardware device. (Code 44)"
            "45" = "Currently, this hardware device is not connected to the computer... (Code 45)"
            "46" = "Windows cannot gain accessto this hardware device… (Code 46)"
            "47" = "Windows cannot use this hardware device… (Code 47)"
            "48" = "The software for this device has been blocked… (Code 48)."
            "49" = "Windows cannot start new hardware devices… (Code 49)."
            "50" = "Windows cannot apply all of the properties for this device... (Code 50)"
            "51" = "This device is currently waiting on another device… (Code 51)."
            "52" = "Windows cannot verify the digital signature for the drivers required for this device. (Code 52)"
            "53" = "This device has been reserved for use by the Windows kernel debugger... (Code 53)"
            "54" = "This device has failed and is undergoing a reset. (Code 54)"
        }

    # Arrays

    # Output to Log
        Write-Host "      - WMI Namespace: $($Path_WMI_Namespace)"
        Write-Host "      - WMI Class: $($Name_WMI_Class)"
        Write-Host "      - Log Output: $($File_HardwareInfo_LogOutput)"

    Write-Host "      - Complete"
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

    # Write-Host "  Environment"



    # Write-Host "    - Complete"
    # Write-Host ""

#EndRegion Environment
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Validation
#   Error Range: 1500 - 1599
#--------------------------------------------------------------------------------------------
#Region Validation

    # Write-Host "  Validation"



    # Write-Host "    - Complete"
    # Write-Host ""

#EndRegion Validation
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Execution
#   Error Range: 1600 - 1699
#--------------------------------------------------------------------------------------------
#Region Execution

    Write-Host "  Execution"

    # Get Hardware with Errors
        Write-Host "      - Get Hardware with Errors"

        try {
            $Temp_Hardware_All      = Get-WmiObject -Namespace $Path_WMI_Namespace -Class $Name_WMI_Class -ComputerName localhost
            $Temp_Hardware_Errors   = $Temp_Hardware_All | Where-Object {$_.ConfigManagerErrorCode -gt 0 }
            Write-Host "          Total Hardware: $(($Temp_Hardware_All | Measure-Object).Count)"
            Write-Host "          Hardware Errors: $(($Temp_Hardware_Errors | Measure-Object).Count)"
            Write-Host "          Success: Gathered Hardware with Errors"
        }
        catch {
            Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
        }

    # Output Hardware with Errors
        Write-Host "      - Output Hardware with Errors"

        try {
            if ((($Temp_Hardware_Errors | Measure-Object).Count) -gt 0) {
                foreach ($Item in $Temp_Hardware_Errors) {
                    Write-Host "          Device Name: $($Item.Name)"
                    Write-Host "          Error Code: $($Item.ConfigManagerErrorCode)"
                    Write-Host "          Error Message: $($ErrorCodes_Win32PnpEntity_ConfigMngr[[string]$Item.ConfigManagerErrorCode])"
                }

                Write-Host "          Success: Output Hardware with Errors"
            }
            else {
                Write-Host "          Skipped: No Hardware with Errors"
            }

        }
        catch {
            Write-vr_ErrorCode -Code 1602 -Exit $true -Object $PSItem
        }

    # Set Task Sequence Variables
        Write-Host "      - Set Task Sequence Variables"

        try {
            if ((($Temp_Hardware_Errors | Measure-Object).Count) -gt 0) {
                $Object_MECM_TSEnvironment.Value("$($vr_TS_VariableName_ValidationStatus)") = "Errors Found"
            }
            else {
                $Object_MECM_TSEnvironment.Value("$($vr_TS_VariableName_ValidationStatus)") = "Success"
            }
            $Object_MECM_TSEnvironment.Value("$($vr_TS_VariableName_TotalHardware)") = ($Temp_Hardware_All | Measure-Object).Count
            $Object_MECM_TSEnvironment.Value("$($vr_TS_VariableName_TotalErrors)")   = ($Temp_Hardware_Errors | Measure-Object).Count

            Write-Host "          $($vr_TS_VariableName_ValidationStatus): $($Object_MECM_TSEnvironment.Value("$($vr_TS_VariableName_ValidationStatus)"))"
            Write-Host "          $($vr_TS_VariableName_TotalHardware): $($Object_MECM_TSEnvironment.Value("$($vr_TS_VariableName_TotalHardware)"))"
            Write-Host "          $($vr_TS_VariableName_TotalErrors): $($Object_MECM_TSEnvironment.Value("$($vr_TS_VariableName_TotalErrors)"))"
            Write-Host "          Success: Set Task Sequence Variables"
        }
        catch {
            Write-vr_ErrorCode -Code 1603 -Exit $true -Object $PSItem
        }

    # Log Detailed Hardware Information
        Write-Host "      - Log Detailed Hardware Information"

        try {
            foreach ($Item in $Temp_Hardware_All) {
                $Temp_Log_Entry = "Device Name: $($Item.Name)
Status Code: $($Item.ConfigManagerErrorCode)
Status Message: $($ErrorCodes_Win32PnpEntity_ConfigMngr[[string]$Item.ConfigManagerErrorCode])
"

                Out-File -FilePath $File_HardwareInfo_LogOutput -InputObject $Temp_Log_Entry -Append -ErrorAction Stop
            }
            Write-Host "          Success: Logged Detailed Hardware Information"
        }
        catch {
            Write-vr_ErrorCode -Code 1604 -Exit $true -Object $PSItem
        }

    Write-Host "      - Complete"
    Write-Host ""

#EndRegion Execution
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Cleanup
#   Error Range: 1800 - 1899
#--------------------------------------------------------------------------------------------
#Region Cleanup

    # Write-Host "  Cleanup"

    # # [StepName]
    #     Write-Host "    - [StepName]"

    #     try {

    #         Write-host "        Success"
    #     }
    #     catch {
    #         Write-vr_ErrorCode -Code 1801 -Exit $true -Object $PSItem
    #     }

    # Write-Host "    - Complete"
    # Write-Host ""

#EndRegion Cleanup
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Output
#   Error Range: 1900 - 1999
#--------------------------------------------------------------------------------------------
#Region Output

    # Write-Host "  Output"

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

#EndRegion Output
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Footer
#--------------------------------------------------------------------------------------------
#Region Footer

    Write-Host ""
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  End of Script"
    Write-Host "------------------------------------------------------------------------------"

#EndRegion Footer
#--------------------------------------------------------------------------------------------
