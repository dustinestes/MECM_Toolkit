#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

# param (
#     [string]$MAK                # 'XXXXX-XXXXX-XXXXX-XXXXX-XXXXX' / '%%'
# )

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  Task Sequence Toolkit - Windows - License Activation"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:     Dustin Estes"
    Write-Host "    Company:    VividRock"
    Write-Host "    Date:       November 23, 2019"
    Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:    This script will attempt to activate the device with the provided"
    Write-Host "                MAK License key."
    Write-Host "    Links:      None"
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

    # Names
        $Name_WMI_Namespace     = "root/cimv2"
        $Name_WMI_ClassName     = "SoftwareLicensingProduct"

    # Paths

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

    # Output to Log
        Write-Host "    - WMI"
        Write-Host "        Namespace: $($Name_WMI_Namespace)"
        Write-Host "        Class: $($Name_WMI_ClassName)"

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

    Write-Host "  Validation"

    # WMI Class Exists
        Write-Host "    - WMI Class Exists"

        try {
            $Dataset_WMI_SoftwareLicensingProduct = Get-CimInstance -Namespace $Name_WMI_Namespace -ClassName $Name_WMI_ClassName -Filter "partialproductkey is not null" -ErrorAction Stop | Where-Object -Property "Name" -like "Windows*"
            Write-host "        Success"
        }
        catch {
            Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
        }

    # Activation Status
        Write-Host "    - Activation Status"

        try {
            Write-Host "        Actiation Status: $($Dataset_WMI_SoftwareLicensingProduct.LicenseStatus)"
            Write-Host "        Status Name: $($Hashtable_LicenseStatus_Descriptions.`"$($Dataset_WMI_SoftwareLicensingProduct.LicenseStatus)`")"
        }
        catch {
            Write-vr_ErrorCode -Code 1502 -Exit $true -Object $PSItem
        }


    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Validation
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Execution
#   Error Range: 1500 - 1599
#--------------------------------------------------------------------------------------------
#Region Execution

    Write-Host "  Execution"

    # Activate Windows
        Write-Host "    - Activate Windows"

        try {

            if ($Dataset_WMI_SoftwareLicensingProduct.LicenseStatus -ne "1") {
                $Temp_Counter   = 0
                $Temp_RetryMax  = 5

                do {
                    $Temp_Counter += 1
                    Write-Host "        Attempt $($Temp_Counter)/$($Temp_RetryMax)"
                    Start-Process -FilePath "C:\Windows\System32\cscript.exe" -ArgumentList "slmgr.vbs","/ato" -WindowStyle Hidden -Wait -ErrorAction Stop
                    Start-Sleep -Seconds 20
                    
                } until (
                    ($Dataset_WMI_SoftwareLicensingProduct.LicenseStatus -eq "1") -or ($Temp_Counter -eq $Temp_RetryMax)
                )
                
    
                Write-Host "        Success"
            }
            else {
                Write-Host "        Already Activated"
            }

        }
        catch {
            Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
        }

    # Activation Status
        Write-Host "    - Activation Status"

        try {
            Write-Host "        Actiation Status: $($Dataset_WMI_SoftwareLicensingProduct.LicenseStatus)"
            Write-Host "        Status Name: $($Hashtable_LicenseStatus_Descriptions.`"$($Dataset_WMI_SoftwareLicensingProduct.LicenseStatus)`")"
        }
        catch {
            Write-vr_ErrorCode -Code 1502 -Exit $true -Object $PSItem
        }


    Write-Host "    - Complete"
    Write-Host ""

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Main Execution
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
