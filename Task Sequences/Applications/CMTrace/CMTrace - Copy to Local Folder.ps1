#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
    [string]$Source,                        # 'C:\Windows\CCM\CMTrace.exe'
    [string]$Destination                    # '%vr_Directory_Tools%'
)

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  Task Sequence Toolkit - CMTrace - Copy to Local Folder"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:     Dustin Estes"
    Write-Host "    Company:    VividRock"
    Write-Host "    Date:       December 19, 2019"
    Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:    This script will copy the CMTrace tool from its default location"
    Write-Host "                to a local folder so it isn't uninstalled during client uninstall."
    Write-host "                Such as when you are trying to troubleshoot/reinstall clients"
    Write-Host "                and still need the tool to monitor log output."
    Write-Host "    Links:      [Links to Helpful Source Material]"
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
        $Param_Source        = $Source
        $Param_Destination   = $Destination

    # Names

    # Paths

    # Registry

    # Hashtables

    # Arrays

    # Output to Log
        Write-Host "    - Source: $($Param_Source)"
        Write-Host "    - Destination: $($Param_Destination)"

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

    Write-Host "  Validate Data"

    # Validate Source File Exists
        Write-Host "    - Source File Exists"

        If (Test-Path $Param_Source) {
            Write-Host "        Success"
        }
        Else {
            Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
        }

    # Validate Destination Directory Exists
        Write-Host "    - Destination Directory Exists"

        If (Test-Path $Param_Destination) {
            Write-Host "        Success"
        }
        Else {
            try {
                New-Item -Path $Param_Destination -ItemType Directory -Force -ErrorAction Stop | Out-Null
                Write-Host "        Created"
            }
            catch {
                Write-vr_ErrorCode -Code 1502 -Exit $true -Object $PSItem
            }
        }

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Validation
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Execution
#   Error Range: 1600 - 1699
#--------------------------------------------------------------------------------------------
#Region Execution

    Write-Host "  Main Execution"

    # Copy Source Content to Destination
        Write-Host "    - Copy Source Content to Destination"

        try {
            Copy-Item -Path $Param_Source -Destination $Param_Destination -Force -ErrorAction Stop
            Write-Host "        Success: Content Copied"
        }
        catch {
            Write-vr_ErrorCode -Code 1601 -Exit $true -Object $PSItem
        }

    Write-Host "    - Complete"
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
